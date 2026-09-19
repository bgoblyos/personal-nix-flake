{
  flake.modules.homeManager."scripts/glsa-notify" = {
    pkgs,
    lib,
    ...
  }: let
    glsaNotify = pkgs.writers.writePython3Bin "glsa-notify" {} ''
      import subprocess


      def sendNotification(body, icon="security-low-symbolic", urgent=True):
          command = [
              "notify-send",
              "--app-name",
              "Automated GLSA alerts",
              "--urgency",
              "critical" if urgent else "normal",
              "--icon",
              icon,
              body,
          ]

          notification = subprocess.run(command, capture_output=True)

          response = notification.stdout.decode("UTF-8").strip()

          if response.isdigit():
              return int(response)
          else:
              return None


      glsa = subprocess.run(["glsa-check", "-t", "affected"], capture_output=True)

      if glsa.returncode != 0:
          output = glsa.stdout.decode("UTF-8").strip()
          print(output)
          n = len(output.split("\n"))
          if n == 1:
              s = "The system is affected by 1 GLSA"
          else:
              s = f"The system is affected by {n} GLSAs"
          sendNotification(s)
    '';
  in {
    # Make script available on CLI for manual execution
    home.packages = [glsaNotify];

    # Systemd User Service
    systemd.user.services.glsa-check-notify = {
      Unit = {
        Description = "Check for Gentoo Security Advisories (GLSAs)";
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${glsaNotify}/bin/glsa-notify";
        # Environment path guarantees libnotify from Nix and glsa-check from Gentoo host
        Environment = "PATH=${lib.makeBinPath [pkgs.libnotify]}:/usr/bin:/usr/sbin:/bin";
      };
    };

    # Systemd User Timer
    systemd.user.timers.glsa-check-notify = {
      Unit = {
        Description = "Daily GLSA Check Timer";
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
