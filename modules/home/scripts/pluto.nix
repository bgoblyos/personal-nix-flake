{
  flake.modules.homeManager."scripts/pluto" = {pkgs, ...}: let
    pluto = pkgs.julia-bin.withPackages ["Pluto"];
  in {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "pluto";
        runtimeInputs = [pluto];
        text = ''
          ${pluto}/bin/julia -e "using Pluto; Pluto.run()"
        '';
      })
    ];
  };
}
