{
  flake.modules.homeManager."scripts/music-dl" = {pkgs, ...}: {
    home.packages = [
      (pkgs.writeShellApplication {
        name = "music-dl";
        runtimeInputs = with pkgs; [
          yt-dlp
        ];
        text = ''
          yt-dlp --geo-bypass --ignore-errors --extract-audio --audio-quality 0 --restrict-filenames "$@"
        '';
      })
    ];
  };
}
