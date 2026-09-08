{ pkgs, ... }:

{
  # AMD Nested Virtualization
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
  '';

  # Libvirt Daemon & QEMU Integration
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true;  # Software TPM (required for Windows 11 guests)
    };
  };

  # Virt-Manager GUI Application
  programs.virt-manager.enable = true;

  # User Group Access (replace 'bence' with your primary user account)
  users.users.bence.extraGroups = [ "libvirtd" ];

  # Ensure Default Bridge Network (`virbr0`) Autostarts
  systemd.services.libvirtd-default-network = {
    description = "Autostart libvirt default network";
    after = [ "libvirtd.service" ];
    requires = [ "libvirtd.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "ensure-libvirt-default-network" ''
        # Check if 'default' network is in the list of currently active networks
        if ! ${pkgs.libvirt}/bin/virsh net-list --name | grep -qx "default"; then
          ${pkgs.libvirt}/bin/virsh net-start default
        fi

        # Ensure the autostart flag is enabled
        ${pkgs.libvirt}/bin/virsh net-autostart default
      '';
      RemainAfterExit = true;
    };
  };
}
