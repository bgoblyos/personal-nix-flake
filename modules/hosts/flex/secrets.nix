{
  flake.modules.homeManager."flex/secrets" = {
    config,
    pkgs,
    inputs,
    ...
  }: {
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    home.packages = with pkgs; [
      age
      sops
    ];

    sops = {
      age.keyFile = "${config.home.homeDirectory}/.age/keys.txt";
      defaultSopsFile = ./secrets.yaml;

      secrets."borg_passphrase" = {};
    };
  };
}
