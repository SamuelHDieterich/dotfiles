/*
  This module provides a nix implementation of sops, a tool for managing secrets. This module allows you to define secrets in a structured way, and then use them in your NixOS and Home Manager configurations.
  >> github.com/Mic92/sops-nix
*/

{ inputs, ... }:
{
  flake.modules.generic.sops =
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
        # config.templates.placeholder.<secret>: Access the content of a secret.
        templates = {
          nix-access-token.content = ''
            access-tokens = github.com=${config.sops.placeholder.GitHubToken}
          '';
        };
      };
    };

  flake.nixosModules.sops =
    { pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.nixosModules.sops
        inputs.self.modules.generic.sops
      ];

      environment.systemPackages = with pkgs; [
        sops
      ];
    };

  flake.homeModules.sops =
    { pkgs, ... }:
    {
      imports = [
        inputs.sops-nix.homeModules.sops
        inputs.self.modules.generic.sops
      ];

      home.packages = with pkgs; [
        sops
      ];
    };
}
