{
  flake-file.inputs = {
    claude-code-nix = {
      url = "github:sadjow/claude-code-nix"; # Native claude-code build, updated hourly
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-plugins-official = {
      url = "github:anthropics/claude-plugins-official"; # Official plugin marketplace
      flake = false;
    };
    superpowers = {
      url = "github:obra/superpowers"; # Brainstorming, TDD, systematic debugging
      flake = false;
    };
    prompt-master = {
      url = "github:nidhinjs/prompt-master"; # Prompt engineering for other AI tools
      flake = false;
    };
    terraform-skill = {
      url = "github:antonbabenko/terraform-skill"; # OpenTofu/Terraform practices
      flake = false;
    };
    tokenline = {
      url = "github:inbrace-tech/tokenline"; # Cache-aware statusline
      flake = false;
    };
    caveman = {
      url = "github:JuliusBrussee/caveman"; # Ultra-compressed output mode
      flake = false;
    };
  };
}
