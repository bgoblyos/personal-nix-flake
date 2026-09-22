{
  flake.modules.homeManager."scripts/pluto" = {
    pkgs,
    lib,
    ...
  }: let
    juliaEnv = pkgs.julia-bin.withPackages [
      "Pluto"
      "Plots"
      "PackageCompiler"
    ];

    # C/C++ libraries required by GR_jll / Plots.jl
    grRuntimeLibs = with pkgs; [
      libGL
      libx11
      libxext
      libxrender
      libxt
      fontconfig
      freetype
      zlib
    ];

    libPath = lib.makeLibraryPath grRuntimeLibs;

    plutoSysimage = pkgs.stdenv.mkDerivation {
      pname = "pluto-plots-sysimage";
      version = "1.0";

      nativeBuildInputs = [juliaEnv pkgs.stdenv.cc pkgs.cacert];
      buildInputs = grRuntimeLibs;

      dontUnpack = true;

      # 1. Provide CA cert bundle for SSL/LibGit2
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

      buildPhase = ''
        export HOME=$TMPDIR
        export JULIA_DEPOT_PATH="$TMPDIR/.julia:''${JULIA_DEPOT_PATH:-}"

        # Force offline mode
        export JULIA_PKG_OFFLINE="true"
        export JULIA_PKG_SERVER=""

        # Supply C libraries & force GR into headless/offscreen mode
        export LD_LIBRARY_PATH="${libPath}:''${LD_LIBRARY_PATH:-}"
        export GKSwstype="100"

        # Dummy registry to prevent Git clone attempts
        mkdir -p $TMPDIR/.julia/registries/General
        cat <<'EOF' > $TMPDIR/.julia/registries/General/Registry.toml
        name = "General"
        uuid = "58a06abe-94cd-44cb-8d4e-ba0150f2b266"
        repo = "https://github.com/JuliaRegistries/General.git"
        description = "Dummy Nix Sandbox Registry"

        [packages]
        EOF

        # Compile sysimage
        julia -e '
          using Pkg
          Pkg.offline(true)
          using PackageCompiler

          create_sysimage(
            ["Pluto", "Plots"];
            sysimage_path="sysimage.so"
          )
        '
      '';

      installPhase = ''
        mkdir -p $out
        cp sysimage.so $out/sysimage.so
      '';
    };

    pluto = pkgs.writeShellApplication {
      name = "pluto";
      runtimeInputs = [juliaEnv];
      text = ''
        # Set up headless mode and shared libraries for GR at runtime
        export GKSwstype="100"
        export LD_LIBRARY_PATH="${libPath}:''${LD_LIBRARY_PATH:-}"

        exec julia -J "${plutoSysimage}/sysimage.so" -e 'using Pluto; Pluto.run()'
      '';
    };
  in {
    home.packages = [pluto];
  };
}
