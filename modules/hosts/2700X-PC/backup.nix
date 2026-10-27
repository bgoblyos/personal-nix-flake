{
  flake.modules.homeManager."2700X-PC/backup" = {
    config,
    pkgs,
    ...
  }: let
    home = config.home.homeDirectory;

    exclude = [
      # Binary blobs
      "- ${home}/Projects/**/*.o"
      "- ${home}/Projects/**/*.exe"
      "- ${home}/Projects/**/*.jld2*"
      "- ${home}/Projects/**/*.png"

      # Build artifacts and ephemeral envs
      "- ${home}/Projects/**/.git/"
      "- ${home}/Projects/**/target/"
      "- ${home}/Projects/**/dist-newstyle/"
      "- ${home}/Projects/**/env/"
      "- ${home}/Projects/**/.env/"
      "- ${home}/Projects/**/build/"
      "- ${home}/Projects/**/.esphome/"
      "- /etc/nixos/.git/"

      # Stray envs in Documents
      "- ${home}/Documents/**/env/"

      # Unneeded configs
      "- ${home}/.config/borg/"
      "- ${home}/.config/syncthing/index/"

      # Secrets
      "- ${home}/.config/sops-nix/"
    ];

    notifyScript = ''
      export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
      export DISPLAY=:0
      ${pkgs.libnotify}/bin/notify-send --app-name borgmatic --icon state-error --urgency critical 'Backup Failed' 'Borgmatic encountered an error during execution.'
    '';
  in {
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
            "/etc/nixos"
            "${home}/Documents"
            "${home}/.config"
            "${home}/Projects"
            "${home}/KeePassXC"
            "${home}/.ssh/config"
            "${home}/.local/share/Steam/steamapps/compatdata/526870/pfx/drive_c/users/steamuser/Local Settings/Application Data/FactoryGame/Saved/SaveGames" # Satisfactory save
            #"${home}/.local/share/Steam/userdata/317483143/287700/local" # MSGV save
            #"${home}/.local/share/Steam/userdata/317483143/311340/remote" # also MGSV save
          ];

          patterns = exclude;

          exclude_caches = true;
          exclude_if_present = [".nobackup"];
          compression = "zstd";
          archive_name_format = "{hostname}-{now}";

          keep_daily = 14;
          keep_weekly = 6;
          keep_monthly = 12;
          keep_yearly = 500;

          uptime_kuma = {
            push_url = "http://uptime.lan/api/push/p6wWavcEpX";
            states = [
              "start"
              "finish"
              "fail"
            ];
          };

          commands = [
            {
              after = "error";
              run = [notifyScript];
            }
          ];

          encryption_passphrase = "{credential file ${config.sops.secrets.borg_passphrase.path}}";
        };

        append-only.settings = {
          repositories = [
            {
              path = "ssh://borg-virt-append-only/./";
              label = "borg-virt-append-only";
            }
            {
              path = "ssh://borg-rock-append-only/./";
              label = "borg-rock-append-only";
            }
          ];

          source_directories = [
            "/etc/nixos"
            "${home}/Documents"
            "${home}/.config"
            "${home}/Projects"
            "${home}/KeePassXC"
            "${home}/.ssh/config"
          ];

          patterns = exclude;
          exclude_caches = true;
          exclude_if_present = [".nobackup"];
          compression = "zstd";
          archive_name_format = "{hostname}-{now}";

          skip_actions = [
            "compact"
            "prune"
          ];

          encryption_passphrase = "{credential file ${config.sops.secrets.borg_passphrase_append_only.path}}";
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
      "borg_passphrase_append_only" = {};
    };
  };
}
