{
  flake.modules.homeManager."scripts/journal" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "journal";
        text = ''
          TODAY=$(date +%Y-%m-%d)
          FNAME="$HOME/Documents/Log/$TODAY.md"

          if ! [ -e "$FNAME" ]; then
            printf '# %s\n' "$TODAY" >> "$FNAME"
          fi

          $EDITOR "$FNAME"
        '';
      })
    ];
  };
}
