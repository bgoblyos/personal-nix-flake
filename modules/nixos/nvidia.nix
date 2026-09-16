{
  flake.modules.nixos.nvidia = {
    pkgs,
    config,
    lib,
    ...
  }: {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = true; # see the note above
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

    # Decoding support
    environment.variables.LIBVA_DRIVER_NAME = "nvidia";

    # If used with Firefox
    # environment.variables.MOZ_DISABLE_RDD_SANDBOX = "1";

    environment.systemPackages = [pkgs.libva-utils];

    programs.firefox.preferences = let
      ffVersion = config.programs.firefox.package.version;
    in
      lib.mkIf (config.programs.firefox.enable) {
        "media.ffmpeg.vaapi.enabled" = lib.versionOlder ffVersion "137.0.0";
        "media.hardware-video-decoding.force-enabled" = lib.versionAtLeast ffVersion "137.0.0";
        "media.rdd-ffmpeg.enabled" = lib.versionOlder ffVersion "97.0.0";

        "gfx.x11-egl.force-enabled" = true;
        "widget.dmabuf.force-enabled" = true;

        "media.av1.enabled" = true;
      };
  };
}
