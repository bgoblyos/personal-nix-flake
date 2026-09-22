{config, ...}: let
  # Captures flake-parts config in outer closure scope
  hm = config.flake.modules.homeManager;
  getHM = names: map (name: hm.${name}) names;
in {
  flake.modules.homeManager."suites/cli" = {...}: {
    imports = getHM [
      "comma"
      "fish"
      "starship"
      "git"
      "gpg"
      "nh"
      "scripts/nix-sync"
      "scripts/dirty"
      "scripts/music-dl"
      "scripts/cleanup"
    ];
  };

  flake.modules.homeManager."suites/common" = {...}: {
    imports = getHM [
      "suites/cli"
      "fonts"
      "nvim"
    ];
  };

  flake.modules.homeManager."suites/julia" = {...}: {
    imports = getHM [
      "julia"
      "scripts/pluto"
      "scripts/julia-formatter"
    ];
  };
}
