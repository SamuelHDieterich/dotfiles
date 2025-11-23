# dotfiles

Personal dotfiles. Forever working in progress.

## Installation

### NixOS

1. Clone the repository

   ```sh
   git clone https://github.com/SamuelHDieterich/dotfiles ~/.dotfiles
   ```

2. Run the `disko` setup command

    ```sh
    sudo nix --experimental-features "nix-command flakes" \
      run github:nix-community/disko/latest -- \
        --mode destroy,format,mount \
        ~/.dotfiles/nixos/profiles/<your-machine>/disk-configuration.nix
    ```

3. First time setup

    ```sh
    sudo nixos-rebuild switch --extra-experimental-features "nix-command flakes" --flake ~/.dotfiles/#<your-machine>
    ```

### Non-NixOS

1. Install `nix` (Recommended: multi-user installation)
   
   ```sh
   sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
   ```

2. Clone the repository

   ```sh
   git clone https://github.com/SamuelHDieterich/dotfiles ~/.dotfiles
   ```

3. Run the `home-manager` installation script or execute the commands manually

    ```sh
    bash ~/.dotfiles/install.sh
    # Type your desired channel (unstable, 25.05, etc.)
    ```

## Usage

```sh
nh os switch <path> -H <config>   # NixOS
nh home switch <path> -c <config> # Non-NixOS
```

## Roadmap

- WM
  - Improve Hyprland
    - Window Rules
    - Hypridle
    - Hyprlock
  - Explore MangoWM 
- Visuals
  - Explore QuickShell
    - Bar
    - Menu
  - Color scheme
- Performance
  - Nvidia
    - Offload
    - Specialization
  - TLP 