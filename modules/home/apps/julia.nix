{
  flake.modules.homeManager.julia = {
    pkgs,
    lib,
    ...
  }: {
    home.packages = with pkgs; [
      julia-bin
    ];

    # Ensure Julia uses standard user depot for Pkg installs
    home.sessionVariables = {
      JULIA_DEPOT_PATH = "$HOME/.julia";
    };
  };
}
