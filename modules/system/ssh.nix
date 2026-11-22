{
  flake.nixosModules.ssh = {
    services.openssh = {
      enable = true;
      # sops-nix derives the host's age identity from this key, so it must be seeded at install, never regenerated.
      hostKeys = [
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
      };
    };
  };
}
