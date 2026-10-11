{
  flake.modules.homeManager."scripts/flatpak-auto-update" = {
    pkgs,
    lib,
    config,
    ...
  }: let
    flatpakBin =
      if config.targets.genericLinux.enable
      then "flatpak"
      else "${pkgs.flatpak}/bin/flatpak";
  in {
    # Systemd User Service
    systemd.user.services.flatpak-auto-update = {
      Unit = {
        Description = "Update flatpaks";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${flatpakBin} update --assumeyes --noninteractive";
      };
    };

    # Systemd User Timer
    systemd.user.timers.flatpak-auto-update = {
      Unit = {
        Description = "Daily flatpak updates";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };
  };
}
