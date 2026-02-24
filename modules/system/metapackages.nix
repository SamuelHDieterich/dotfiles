/*
  This module defines metapackages, which are collections of related packages that can be installed together. It provides a convenient way to manage groups of packages for different purposes, such as development, office work, media, etc.
  The metapackages are defined once and can be used in both NixOS and Home Manager configurations.
*/

{ lib, ... }:
let
  # Define package metapackages once, to be used by both NixOS and home-manager
  mkMetapackages = pkgs: {
    development = with pkgs; [
      vscode # Visual Studio Code
      dbeaver-bin # Database management
      git # Version control
      lazygit # Git TUI
      devenv # Development environment with nix
      direnv # Autoload environment setup
      # Programming languages
      python3 # Python programming language
      uv # Python package manager
      nodejs # Node.js JavaScript runtime
      # Containers
      docker
      podman
      docker-compose # Multi-docker management
      # Kubernetes
      kubectl # Kubernetes CLI
      kubernetes-helm # Kubernetes package manager
      k9s # Kubernetes TUI
      # Infrastructure as code (IaC)
      terraform
      opentofu # Terraform open-source fork
      terragrunt # Terraform wrapper
      ansible # Automation tool
      # Cloud
      awscli2 # AWS CLI
      (google-cloud-sdk.withExtraComponents [ pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin ]) # Google Cloud SDK with GKE auth plugin
      # Text processing
      jq # JSON processor
      yq # YAML processor
      jnv # jq TUI
      jless # JSON viewer
      difftastic # Structural diff tool
    ];

    office = with pkgs; [
      libreoffice # Office suite
      zathura # PDF viewer
      thunderbird # Email client
      obsidian # Note-taking app
      google-fonts # Google Fonts
      qalculate-gtk # Advanced calculator
    ];

    fonts = with pkgs; [
      nerd-fonts.jetbrains-mono
      caladea
    ];

    academic = with pkgs; [
      zotero # Reference manager
      typst # Latex alternative
    ];

    media = with pkgs; [
      vlc # Media player
      mpv # Media player
      spotify # Music streaming
      freetube # YouTube client
    ];

    graphics = with pkgs; [
      gimp # Image editor
      inkscape # Vector graphics editor
    ];

    security = with pkgs; [
      keepassxc # Password manager
    ];

    utilities = with pkgs; [
      tlrc # Straightforward helper (tldr client)
      # System
      fastfetch # System information tool
      mission-center # System information
      powertop # Power consumption monitor
      (btop.override { cudaSupport = true; }) # System monitor
      nvtopPackages.full # GPU monitor
      # Replacements
      eza # ls replacement
      fd # Find replacement
      ripgrep # grep replacement
      bat # Cat replacement
      bat-extras.core # Extras for bat
      # Disk
      dysk # Enhanced df
      dua # Enhanced du
      ncdu # ncurses disk usage analyzer
      # Archive
      p7zip # 7zip
      unzip # unzip command
      ouch # Preview and extract archives
    ];

    network = with pkgs; [
      curl # cURL command-line tool
      wget # File downloader
    ];

    nix = with pkgs; [
      nh # Glorified nixos/home-manager switch
      nvd # Version diff tool
      nix-diff # Nix generation diff tool
      nps # Nix package searcher
      nil # LPS server
      nixfmt # Nix formatter
    ];
  };

  # Shared option definition
  mkPackagesOption =
    metapackages:
    lib.mkOption {
      type = lib.types.listOf (lib.types.enum (builtins.attrNames metapackages));
      default = [ ];
      description = "List of package bundles to install";
      example = [
        "editor"
        "browser"
        "development"
      ];
    };

  # Flatten selected packages
  getSelectedPackages = metapackages: bundles: lib.flatten (map (name: metapackages.${name}) bundles);
in
{
  # NixOS module
  flake.nixosModules.metapackages =
    { config, pkgs, ... }:
    let
      metapackages = mkMetapackages pkgs;
    in
    {
      options.metapackages.bundles = mkPackagesOption metapackages;

      config = lib.mkIf (config.metapackages.bundles != [ ]) {
        environment.systemPackages = getSelectedPackages metapackages config.metapackages.bundles;
      };
    };

  # home-manager module
  flake.homeModules.metapackages =
    { config, pkgs, ... }:
    let
      metapackages = mkMetapackages pkgs;
    in
    {
      options.metapackages.bundles = mkPackagesOption metapackages;

      config = lib.mkIf (config.metapackages.bundles != [ ]) {
        home.packages = getSelectedPackages metapackages config.metapackages.bundles;
      };
    };
}
