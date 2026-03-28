# minimum-iso

Minimal custom NixOS ISO with:

- OpenSSH enabled
- Extra tools: `neovim`, `git`, `nh`, `btop`

## Usage

From the repository root:

```sh
nix build '.#nixosConfigurations."minimum-iso".config.system.build.isoImage'
```

The resulting image is created at:

```sh
result/iso/*.iso
```

To ssh into the machine after booting the ISO:


```sh
ssh -i ~/.ssh/<private_key> root@<machine-ip>
```