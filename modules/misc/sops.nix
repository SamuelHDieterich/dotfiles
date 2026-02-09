{ inputs, ... }:
{
  flake.module.sops =
    {
      keyfile,
      config,
      lib,
      pkgs,
      ...
    }:
    {
      sops = {
        defaultSopsFile = ../../secrets/secrets.yaml;
        defaultSopsFormat = "yaml";
        age.keyFile = keyfile;

        # Define secrets here to make them available as environment variables and in templates.
        secrets = {
          GitHubToken = { };
        };

        # Define templates that can be included in configuration files.
        templates = {
          nix-access-token.content = ''
            access-tokens = github.com=${config.sops.secrets.GitHubToken}
          '';
        };
      };
    };

  flake.nixosModules.sops =
    { keyfile, pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
        { _module.args.keyfile = keyfile; }
      ];

      environment.systemPackages = with pkgs; [
        sops
      ];
    };

  flake.homeModules.sops =
    { keyfile, pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.homeModules.sops
        { _module.args.keyfile = keyfile; }
      ];

      home.packages = with pkgs; [
        sops
      ];
    };
}
