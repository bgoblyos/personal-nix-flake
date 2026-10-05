{
  flake.modules.homeManager."scripts/downloads-cleanup" = {
    pkgs,
    lib,
    config,
    ...
  }: {
    # Systemd User Service
    systemd.user.services.downloads-cleanup = {
      Unit = {
        Description = "Clean up old files in downloads";
      };
      Service = {
        Type = "oneshot";
        ExecStart = [
          "${pkgs.findutils}/bin/find %h/Downloads -mindepth 1 -mtime +30 -delete"
          "${pkgs.findutils}/bin/find %h/Downloads -mindepth 1 -depth -type d -empty -delete"
        ];
      };
    };

    # Systemd User Timer
    systemd.user.timers.downloads-cleanup = {
      Unit = {
        Description = "Daily downloads cleanup";
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
