{
  flake.modules.homeManager."scripts/julia-formatter" = {pkgs, ...}: let
    juliaEnv = pkgs.julia-bin.withPackages [
      "JuliaFormatter"
      "PackageCompiler"
    ];

    # Build a precompiled .so shared object for JuliaFormatter
    formatterSysimage = pkgs.stdenv.mkDerivation {
      pname = "julia-formatter-sysimage";
      version = "1.0";

      nativeBuildInputs = [juliaEnv pkgs.stdenv.cc pkgs.cacert];
      dontUnpack = true;

      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

      buildPhase = ''
        export HOME=$TMPDIR
        export JULIA_DEPOT_PATH="$TMPDIR/.julia:''${JULIA_DEPOT_PATH:-}"

        export JULIA_PKG_OFFLINE="true"
        export JULIA_PKG_SERVER=""

        # Create a dummy General registry to prevent Git clone attempts
        mkdir -p $TMPDIR/.julia/registries/General
        cat <<'EOF' > $TMPDIR/.julia/registries/General/Registry.toml
        name = "General"
        uuid = "13b9122a-11a8-408a-82c0-b253dbb40b54"
        repo = "https://github.com/JuliaRegistries/General.git"
        description = "Dummy Nix Sandbox Registry"

        [packages]
        EOF

        julia -e '
          using Pkg
          Pkg.offline(true)

          using PackageCompiler

          create_sysimage(
            ["JuliaFormatter"];
            sysimage_path="sysimage.so"
          )
        '
      '';

      installPhase = ''
        mkdir -p $out
        cp sysimage.so $out/sysimage.so
      '';
    };

    # Executable wrapper using the precompiled sysimage
    juliaFormatter = pkgs.writeShellApplication {
      name = "julia-formatter";
      runtimeInputs = [juliaEnv];
      text = ''
        exec julia -J "${formatterSysimage}/sysimage.so" --startup-file=no -e '
          using JuliaFormatter
          for arg in ARGS
            if isfile(arg)
              format_file(arg)
            end
          end
        ' "$@"
      '';
    };
  in {
    home.packages = [juliaFormatter];
  };
}
