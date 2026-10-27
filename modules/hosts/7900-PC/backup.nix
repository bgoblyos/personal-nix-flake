{
  flake.modules.homeManager."7900-PC/backup" = {
    config,
    pkgs,
    ...
  }: {
    programs.borgmatic = {
      enable = true;
      backups = {
        local.settings = {
          repositories = [
            {
              path = "ssh://borg-virt/./";
              label = "borg-virt";
            }
            {
              path = "ssh://borg-rock/./";
              label = "borg-rock";
            }
          ];
          source_directories = [
            "/home/bence/KeePassXC"
            "/home/bence/Pictures"
            "/home/bence/Documents"
            "/home/bence/Sync"
            "/home/bence/Code"
            "/home/bence/.config"
            "/home/bence/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/526870/pfx/drive_c/users/steamuser/AppData/Local/FactoryGame/Saved/SaveGames" # Satisfactory saves
            "/home/bence/.var/app/com.valvesoftware.Steam/data/Steam/userdata/317483143/311340/remote" # MGSV saves
            "/home/bence/.var/app/com.valvesoftware.Steam/data/Steam/userdata/317483143/287700/local/" # Also MGSV saves
            "/home/bence/.var/app/com.valvesoftware.Steam/.local/share/Steam/steamapps/compatdata/359320/pfx/drive_c/users/steamuser/Saved Games/Frontier Developments/Elite Dangerous" # E:D journals
            "/etc/portage"
            "/etc/fstab"
          ];
          patterns = [
            "- /home/bence/Pictures/space-wallpapers*"
            "- /home/bence/Pictures/Wallpapers/*"
            "- /home/bence/.config/syncthing/index*"
            "- /home/bence/.config/borg/*"
            "- /home/bence/Code/*/target/*"
            "- /home/bence/Code/*/dist-newstyle/*"
            "- /home/bence/Code/*/env/*"
            "- /home/bence/Documents/*/env/*"
            "- /home/bence/Code/*/build/*"
            "- /home/bence/.config/sops-nix/*"
          ];
          exclude_caches = true;
          exclude_if_present = [".nobackup"];
          compression = "zstd";
          archive_name_format = "{hostname}-{now}";

          keep_daily = 14;
          keep_weekly = 6;
          keep_monthly = 12;
          keep_yearly = 500;

          uptime_kuma = {
            push_url = "http://uptime.lan/api/push/3mb1OuFElG";
            states = [
              "start"
              "finish"
              "fail"
            ];
          };

          commands = [
            {
              after = "error";
              run = [
                "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus DISPLAY=:0 notify-send --app-name borgmatic --icon state-error --urgency critical 'Backup Failed' 'Borgmatic encountered an error during execution.'"
              ];
            }
          ];

          encryption_passphrase = "{credential file ${config.sops.secrets.borg_passphrase.path}}";
        };

        satisfactory.settings = {
          source_directories = ["/home/bence/.var/app/com.valvesoftware.Steam/.steam/steam/steamapps/compatdata/526870/pfx/drive_c/users/steamuser/AppData/Local/FactoryGame/Saved/SaveGames"];
          repositories = [
            {
              path = "ssh://borg-virt-satisfactory/./";
              label = "borg-virt-satisfactory";
            }
            {
              path = "ssh://borg-wjsz-satisfactory/./";
              label = "borg-wjsz-satisfactory";
            }
          ];

          skip_actions = [
            "compact"
            "prune"
          ];

          encryption_passphrase = "{credential file ${config.sops.secrets.borg_passphrase_satisfactory.path}}";
        };
      };
    };

    # Systemd User Service
    systemd.user.services.borgmatic = {
      Unit = {
        Description = "Run borgmatic backup";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.borgmatic}/bin/borgmatic";
        Restart = "on-failure";
        RestartSec = "15min";
      };
    };

    # Systemd User Timer
    systemd.user.timers.borgmatic = {
      Unit = {
        Description = "Daily borgmatic backup";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
      };
      Install = {
        WantedBy = ["timers.target"];
      };
    };

    # Pull in secrets
    sops.secrets = {
      "borg_passphrase" = {};
      "borg_passphrase_satisfactory" = {};
    };
  };
}
