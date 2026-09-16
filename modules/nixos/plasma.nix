{
  flake.modules.nixos.plasma = {pkgs, ...}: {
    # Enable the X11 windowing system.
    # You can disable this if you're only using the Wayland session.
    services.xserver.enable = true;

    # Enable the KDE Plasma Desktop Environment.
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;

    # Enable KDE Connect
    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.partitionmanager
      kdePackages.plasma-vault
      kdePackages.kate
      kdePackages.elisa
      kdePackages.kcalc
      kdePackages.kcolorchooser
      kdePackages.ksystemlog
      hardinfo2
      wl-clipboard
    ];
  };
}
