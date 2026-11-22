# installer

USB installer image based on `installation-cd-minimal.nix`, with OpenSSH, Wi-Fi via wpa_supplicant and `neovim`, `git`, `nh`, `btop`, `nixos-facter`, `tmux`.

## Build

From the repository root:

```sh
nix build .#installer-iso
```

The image lands in `result/iso/`.

## Write to a stick

```sh
sudo dd if=result/iso/*.iso of=/dev/sdX bs=4M status=progress conv=fsync
```

## Use

SSH in as root with a key listed in `modules/flake/facts.nix`:

```sh
ssh root@<machine-ip>
```

For a new host's hardware report:

```sh
nixos-facter > facter.json
```

A machine that already runs Linux can skip the stick: nixos-anywhere kexecs into its own installer (see `hosts/README.md`).
