{ ... }:

let
  archiveDevice = "/dev/disk/by-uuid/926312e7-8b91-40b1-b474-b0fd94614ea6";
  tankDevice    = "/dev/disk/by-uuid/589ce516-ee9e-4eb6-ac1f-471e251c5245";
in
{
  # --- Archive Mounts ---
  fileSystems."/mnt/archive-root" = {
    device = archiveDevice;
    fsType = "btrfs";
    options = [ "relatime" "nofail" ];
  };

  # fileSystems."/home/bence/Virt/Archive" = {
  #   device = archiveDevice;
  #   fsType = "btrfs";
  #   options = [ "subvol=virt-disk-archive" "relatime" "nofail" ];
  # };

  fileSystems."/home/bence/Backup" = {
    device = archiveDevice;
    fsType = "btrfs";
    options = [ "subvol=archive-backup" "relatime" "nofail" ];
  };

  fileSystems."/home/bence/Pictures" = {
    device = archiveDevice;
    fsType = "btrfs";
    options = [ "subvol=pictures-archive" "relatime" "nofail" ];
  };

  fileSystems."/home/bence/Archive" = {
    device = archiveDevice;
    fsType = "btrfs";
    options = [ "subvol=archive-archive" "relatime" "nofail" ];
  };

  # --- Tank Mounts ---
  fileSystems."/mnt/tank-root" = {
    device = tankDevice;
    fsType = "btrfs";
    options = [ "compress-force=zstd:5" "noatime" "nofail" ];
  };

  # fileSystems."/home/bence/Virt/ISO" = {
  #   device = tankDevice;
  #   fsType = "btrfs";
  #   options = [ "subvol=iso" "noatime" "nofail" ];
  # };

  # fileSystems."/home/bence/Virt/Tank" = {
  #   device = tankDevice;
  #   fsType = "btrfs";
  #   options = [ "subvol=virt-disk-tank" "noatime" "nofail" ];
  # };

  fileSystems."/home/bence/Games/Tank" = {
    device = tankDevice;
    fsType = "btrfs";
    options = [ "subvol=games-tank" "compress-force=zstd:5" "noatime" "nofail" ];
  };

  # fileSystems."/home/bence/Downloads" = {
  #   device = tankDevice;
  #   fsType = "btrfs";
  #   options = [ "subvol=downloads-tank" "compress-force=zstd:5" "noatime" "nofail" ];
  # };

  fileSystems."/home/bence/Videos" = {
    device = tankDevice;
    fsType = "btrfs";
    options = [ "subvol=videos-tank" "compress-force=zstd:5" "noatime" "nofail" ];
  };
}
