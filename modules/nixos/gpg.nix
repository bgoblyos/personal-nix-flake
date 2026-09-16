{
  flake.modules.nixos.gpg = {pkgs, ...}: {
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    services.pcscd.enable = true;
  };
}
