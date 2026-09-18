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
    ];
  };

  flake.modules.homeManager."suites/common" = {...}: {
    imports = getHM [
      "suites/cli"
      "fonts"
      "nvim"
      "scripts/nix-sync"
    ];
  };

  flake.modules.homeManager."suites/julia" = {...}: {
    imports = getHM [
      "julia"
      "scripts/pluto"
    ];
  };
}
