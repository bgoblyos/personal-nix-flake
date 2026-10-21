{
  flake.modules.homeManager."scripts/pluto" = {pkgs, ...}: let
    juliaEnv = (pkgs.julia-bin.withPackages.override {
      # Native libs for GR_jll / Plots.jl
      extraLibs = with pkgs; [
        libGL
        libx11
        libxext
        libxrender
        libxt
        fontconfig
        freetype
        zlib
      ];
    }) ["Pluto" "Plots"];

    pluto = pkgs.writeShellApplication {
      name = "pluto";
      runtimeInputs = [juliaEnv];
      runtimeEnv.GKSwstype = "100"; # GR headless/offscreen
      text = ''
        exec julia --startup-file=no -e 'using Pluto; Pluto.run()'
      '';
    };
  in {
    home.packages = [pluto];
  };
}
