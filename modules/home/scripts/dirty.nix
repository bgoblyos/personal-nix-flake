{
  flake.modules.homeManager."scripts/dirty" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "dirty";
        runtimeInputs = with pkgs; [
          coreutils
          gawk
          bc
        ];
        text = ''
          dirty_kb="$(grep 'Dirty' /proc/meminfo | awk '{print $2}')"
          dirty_bytes="$(echo "$dirty_kb" "* 1000" | bc)"

          numfmt --to=iec-i --suffix=B --unit-separator=" " "$dirty_bytes"
        '';
      })
    ];
  };
}
