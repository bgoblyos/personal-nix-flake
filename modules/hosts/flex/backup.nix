{
  flake.modules.homeManager."flex/backup" = {
    config,
    pkgs,
    ...
  }: let
    home = config.home.homeDirectory;
    stateDir = "${home}/.local/state/borgmatic_hooks";
    lastSuccessFile = "${stateDir}/last_success";

    # Notify-send binary and common options
    notify-send = "${pkgs.libnotify}/bin/notify-send --app-name borgmatic";

    failOnMetered = ''
      # Scan all active NetworkManager connections for a metered flag
      METERED_FOUND=false
      while IFS= read -r conn; do
        [ -z "$conn" ] && continue
        if [ "$(nmcli -g connection.metered connection show "$conn" 2>/dev/null)" = "yes" ]; then
          METERED_FOUND=true
          break
        fi
      done < <(nmcli -t -f NAME connection show --active)

      if [ "$METERED_FOUND" = true ]; then
        echo "Active connection is metered. Skipping backup."
        exit 75
      fi
    '';

    # Success timestamp saving
    saveLastSuccess = ''
      mkdir -p ${stateDir}
      date +%s > ${lastSuccessFile}
      echo "Successful backup timestamp saved."
    '';

    # Overdue backup notifier script
    notifyOverdue = ''
      LAST_SUCCESS=$(cat ${lastSuccessFile} 2>/dev/null || echo 0)
      NOW=$(date +%s)
      HOURS_AGO=$(( (NOW - LAST_SUCCESS) / 3600 ))

      # Set up env vars for notify-send
      export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
      export DISPLAY=:0

      # Alert if backups haven't succeeded in over 72 hours
      if [ "$HOURS_AGO" -gt 72 ]; then
          ${notify-send} --icon state-error -u critical "Backups outdated!" "Last successful backup was $HOURS_AGO hours ago."
      fi
    '';
  in {
    programs.borgmatic = {
      enable = true;
      backups = {
        regular.settings = {
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
            "${home}/Documents"
            "${home}/Archive"
            "${home}/Code"
            "${home}/KeePassXC"
            "${home}/.config"
            "/etc/udev/rules.d"
          ];
          patterns = [
            "- ${home}/Pictures/space-wallpapers*"
            "- ${home}/Pictures/Wallpapers/*"
            "- ${home}/.config/syncthing/index*"
            "- ${home}/.config/borg/*"
            "- ${home}/Code/*/target/*"
            "- ${home}/Code/*/dist-newstyle/*"
            "- ${home}/Code/*/env/*"
            "- ${home}/Documents/*/env/*"
            "- ${home}/Code/*/build/*"
            "- ${home}/.config/sops-nix/*"
          ];
          flags = true;
          exclude_caches = true;
          exclude_if_present = [".nobackup"];
          compression = "zstd";
          archive_name_format = "{hostname}-{now}";

          keep_daily = 14;
          keep_weekly = 6;
          keep_monthly = 12;
          keep_yearly = 500;

          uptime_kuma = {
            push_url = "http://uptime.lan/api/push/D3mG9MKIIO";
            states = [
              "start"
              "finish"
              "fail"
            ];
          };

          commands = [
            {
              before = "repository";
              run = [failOnMetered];
            }
            {
              after = "configuration";
              states = ["finish"];
              run = [saveLastSuccess];
            }

            {
              after = "error";
              run = [notifyOverdue];
            }
          ];

          encryption_passphrase = "{credential file ${config.sops.secrets.borg_passphrase.path}}";
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

    # Pull in secrets
    sops.secrets = {
      "borg_passphrase" = {};
    };
  };
}
