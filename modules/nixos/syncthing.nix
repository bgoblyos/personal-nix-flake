{
  flake.modules.nixos.syncthing = {pkgs, ...}: {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true; # Open ports in the firewall for Syncthing.
      # TODO: Make these more portable
      user = "bence";
      configDir = "/home/bence/.config/syncthing";
    };
  };
}
