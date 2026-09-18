{
  flake.modules.homeManager."scripts/winboot" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "winboot";
        text = ''
          run0 efibootmgr -n 3
          systemctl reboot
        '';
      })
    ];
  };
}
