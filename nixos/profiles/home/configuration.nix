{
  config,
  lib,
  pkgs,
  ...
}: {
  # Modules
  imports = [
    # Hardware
    ./hardware-configuration.nix
    # Base
    ../../modules/base.nix
    # Hardware
    ../../modules/hardware/audio.nix
    ../../modules/hardware/bluetooth.nix
    ../../modules/hardware/nvidia.nix
    ../../modules/hardware/power.nix
    ../../modules/hardware/printing.nix
    ../../modules/hardware/time.nix
    # Window Manager
    ../../modules/wm/hyprland.nix
  ];

  # Base configuration
  base = {
    nixos = {
      allowUnfree = true;
      version = "24.05";
    };
    # bootloader = "systemd-boot"; # Lanzaboote
    hostname = "nixos";
    username = "samuel";
  };

  # Secure boot
  boot = {
    initrd.systemd.enable = true;
    loader.systemd-boot.enable = lib.mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };

  # Firmware
  services.fwupd.enable = true;

  # Nvidia
  nvidia.prime.busId = {
    nvidia = "PCI:1:0:0";
    intel = "PCI:0:2:0";
  };

  # Packages
  environment.systemPackages = with pkgs; [
    # Editor
    neovim
    vscode
    # Browser
    firefox
    # Development
    git
    lazygit
    docker
    docker-compose
    # Shell
    zsh
    # Terminal
    kitty
    # Office
    libreoffice
    zathura
    thunderbird
    # Media
    vlc
    spotify
    # Graphics
    gimp
    inkscape
    # File Manager
    yazi
    # Password Manager
    keepassxc
    # Utilities
    bat
    fd
    ripgrep
    btop
    nvtopPackages.full
    powertop
    #mission-center
    # Network
    curl
    wget
    # Misc
    emote
    fastfetch
    xdg-user-dirs
    # Nix
    nh
  ];

  # Programs
  programs.nix-ld.enable = true;  # Run unpatched dynamic binaries on NixOS. Needed for compilation (C, Rust).
  programs.steam.enable = true;
}
