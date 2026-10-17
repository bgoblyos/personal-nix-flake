{
  flake.modules.homeManager.sops = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: {
    # Pull in sops-nix without needing it in the host modules list
    imports = [
      inputs.sops-nix.homeManagerModules.sops
    ];

    options.local.secretsFile = lib.mkOption {
      type = lib.types.path;
      description = "Path to the host-specific sops-nix secrets file.";
    };

    config = {
      # Install sops and age CLI tools for secret editing/management
      home.packages = with pkgs; [
        sops
        age
      ];

      sops = {
        # Set the standardized age key path
        age.keyFile = "${config.home.homeDirectory}/.age/keys.txt";

        # Set the secrets path from the host-provided option
        defaultSopsFile = config.local.secretsFile;
      };
    };
  };
}
