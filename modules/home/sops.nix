{
  flake.modules.homeManager.sops = {
    config,
    lib,
    pkgs,
    inputs,
    ...
  }: let
    ageFile = "${config.home.homeDirectory}/.age/keys.txt";
  in {
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
        age.keyFile = ageFile;

        # Set the secrets path from the host-provided option
        defaultSopsFile = config.local.secretsFile;
      };

      # Help sops find the age key
      home.sessionVariables.SOPS_AGE_KEY_FILE = ageFile;
    };
  };
}
