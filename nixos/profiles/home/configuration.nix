{ lib, pkgs, ... }: {
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
    # Display Manager
    ../../modules/display_manager/greetd.nix
    # Window Manager
    ../../modules/wm/hyprland.nix
    # Development
    ../../modules/dev/virtmanager.nix
  ];

  # Base configuration
  base = {
    hostname = "nixos";
    version = "24.05";
    username = "samuel";
    allowUnfree = true;
  };

  # Boot and kernel
  boot = {
    loader.timeout = 0; # Skip boot menu, press "space" key to show it
    initrd.systemd.enable = true;
    loader.systemd-boot = {
      enable = lib.mkForce false; # Use Lanzaboote
      editor = false; # Prevent editing boot entries
    };
    # Secure boot
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Firmware
  services.fwupd.enable = true;

  # I2C
  hardware.i2c.enable = true;

  # Nvidia
  nvidia = {
    package = "latest";
    open = true;
    powerManagement = true;
    prime = {
      enable = true;
      renderOffload = true;
      busId = {
        nvidia = "PCI:1:0:0";
        intel = "PCI:0:2:0";
      };
    };
  };

  # Display manager
  # services.displayManager.ly.enable = true;

  # Keyring
  services.gnome.gnome-keyring.enable = true;
  # security.pam.services.ly.enableGnomeKeyring = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # Disks
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # Thumbnails
  services.tumbler.enable = true;

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
    xfce.thunar
    # Password Manager
    keepassxc
    # Utilities
    bat
    fd
    ripgrep
    btop
    nvtopPackages.full
    powertop
    ddcutil
    mission-center
    # Printing/Scanning
    system-config-printer
    simple-scan
    # Network
    curl
    wget
    # Misc
    fastfetch
    xdg-user-dirs
    # Nix
    nh
    nil
    nixfmt-classic
  ];

  # Fonts
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ nerd-fonts.jetbrains-mono caladea ];
  };

  # Programs
  programs.nix-ld.enable =
    true; # Run unpatched dynamic binaries on NixOS. Needed for compilation (C, Rust).
  programs.steam.enable = true;
}
