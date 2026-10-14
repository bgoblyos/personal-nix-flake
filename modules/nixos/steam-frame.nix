{
  flake.modules.nixos.steam-frame = {pkgs, ...}: {
    # Set the iwd backed for networkmanager
    networking.networkmanager.wifi.backend = "iwd";

    # Redistributables for realtek driver
    hardware.enableRedistributableFirmware = true;

    # Wireless regulatory domain
    hardware.wirelessRegulatoryDatabase = true;
    boot.extraModprobeConfig = ''
      options cfg80211 ieee80211_regdom="HU"
    '';

    # Disable power saving
    networking.networkmanager.wifi.powersave = false;

    # Enable Steam hardware udev rules
    hardware.steam-hardware.enable = true;

    # Open firewall
    programs.steam = {
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
}
