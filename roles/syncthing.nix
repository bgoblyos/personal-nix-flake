{config, pkgs, ...}:

{
  services.syncthing = {
    enable = true;
    openDefaultPorts = true; # Open ports in the firewall for Syncthing. (NOTE: this will not open syncthing gui port)
    user = "bence";
    configDir = "/home/bence/.config/syncthing";
  };
}
