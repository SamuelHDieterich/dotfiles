{ config, inputs, ... }:
let
  inherit (config.dotfiles) sshKeys;
  system = "x86_64-linux";
  stateVersion = "26.05";
  username = "samuel";
  hostname = "lovelace";
in
{
  flake.nixosConfigurations.${hostname} = inputs.nixpkgs-stable.lib.nixosSystem {
    modules = [
      inputs.self.nixosModules.${hostname}
      { nixpkgs.hostPlatform = system; }
    ];
  };

  flake.nixosModules.${hostname} =
    { config, pkgs, ... }:
    {
      imports = with inputs.self.nixosModules; [
        # Operating System modules
        base # Base system configuration
        ssh # OpenSSH, key-only; its host key is this machine's sops identity
        tpmUnlock # LUKS unlocked by the TPM, enrolled on first boot
        zfs # ZFS support, scrubs and snapshot templates
        # Hardware modules
        alwaysOn # No sleep, suspend or hibernation
        # Development modules
        tailscale # Tailscale VPN client
      ];

      base = {
        inherit hostname username;
        version = stateVersion; # The release lovelace was installed with. Never bump it.
        shell = "bash";
      };

      keyboard = [
        {
          layout = "br";
          consoleKeyMap = "br-abnt2";
        }
      ];

      # Boot
      ## Editing the kernel command line at the boot menu gives a root shell once the TPM has unlocked the disk.
      boot.loader.systemd-boot.editor = false;

      # Network
      ## ZFS records this in the pool on import and refuses a pool last imported under another hostId.
      ## Four random bytes in hex, generated once. Changing it after the install stops lovelace from booting.
      networking.hostId = "37a73ce4";

      # Users
      sops.secrets.samuel-password = {
        sopsFile = ./secrets/secrets.yaml;
        neededForUsers = true;
      };
      users.users.${username} = {
        hashedPasswordFile = config.sops.secrets.samuel-password.path;
        openssh.authorizedKeys.keys = sshKeys;
      };

      # Recovery
      ## The Intel TCO watchdog resets the machine when systemd stops answering it, so a hang reboots instead of waiting for someone at the console.
      systemd.settings.Manager.RuntimeWatchdogSec = "1min";
      ## Disk health, logged to the journal.
      services.smartd.enable = true;

      # Programs
      programs.tmux.enable = true; # Sessions survive a dropped SSH connection

      # Packages
      environment.systemPackages = with pkgs; [
        git # Version control
        btop # Process viewer
        smartmontools # smartctl, for the disk health smartd watches
        inputs.self.packages.${system}.nvim # Neovim (nixvim)
      ];
    };
}
