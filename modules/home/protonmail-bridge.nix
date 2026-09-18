{
  flake.modules.homeManager.protonmail-bridge = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [protonmail-bridge-gui];

    xdg.configFile."autostart/protonmail-bridge.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=ProtonMailBridge
      Exec="${pkgs.protonmail-bridge}/lib/bridge-gui" "--no-window"
      X-GNOME-Autostart-enabled=true
    '';
  };
}
