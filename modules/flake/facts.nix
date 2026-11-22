{ lib, ... }:
{
  # Facts shared by several hosts, read through the flake-level config.
  options.dotfiles.sshKeys = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "SSH public keys allowed to log in as Samuel or root on hosts that accept SSH";
  };

  config.dotfiles.sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIANBmVVJXeQrw57e3t0JX+dbPz6rYUAVT0z6IurSoLqS samuel@tesla"
  ];
}
