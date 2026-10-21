{
  flake.modules.homeManager."scripts/julia-formatter" = {pkgs, ...}: let
    # Resolved and precompiled into the Nix store; no ~/.julia involvement
    juliaEnv = pkgs.julia-bin.withPackages ["JuliaFormatter"];

    julia-formatter = pkgs.writeShellApplication {
      name = "julia-formatter";
      runtimeInputs = [juliaEnv];
      text = ''
        # Uncomment once the supported version hits nixpkgs
        # exec julia --startup-file=no -m JuliaFormatter --inplace "$@"


        exec julia --startup-file=no -e '
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
    home.packages = [julia-formatter];
  };
}
