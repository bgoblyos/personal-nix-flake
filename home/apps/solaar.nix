{ config, pkgs, ... }:

{

  home.packages = with pkgs; [ solaar ];
 
  xdg.configFile."autostart/solaar.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Solaar
    Exec=${pkgs.solaar}/bin/solaar --window=hide
    Icon=solaar
    Categories=Utility;
    Terminal=false
    X-KDE-autostart-after=panel
  '';

}
