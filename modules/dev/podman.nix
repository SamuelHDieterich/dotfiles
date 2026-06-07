{
  flake.nixosModules.podman =
    { pkgs, ... }:
    {
      virtualisation = {
        # Enable common container config files in /etc/containers
        containers.enable = true;
        podman = {
          enable = true;

          # Create a `docker` alias for podman, to use it as a drop-in replacement
          dockerCompat = true;

          # Make podman socket available in place of docker socket
          dockerSocket.enable = true;

          # Required for containers under podman-compose to be able to talk to each other.
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      # Useful other development tools
      environment.systemPackages = with pkgs; [
        dive # look into docker image layers
        podman-tui # status of containers in the terminal
        docker-compose # start group of containers for dev
        podman-compose # start group of containers for dev
      ];
    };
}
