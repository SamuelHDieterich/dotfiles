{
  flake.nixosModules.zfs =
    {
      config,
      lib,
      utils,
      ...
    }:
    let
      # The pools under filesystems the initrd mounts, found the way nixpkgs' ZFS module finds them.
      rootPools = lib.unique (
        map (fs: lib.head (lib.splitString "/" fs.device)) (
          lib.filter (fs: fs.fsType == "zfs" && utils.fsNeededForBoot fs) (lib.attrValues config.fileSystems)
        )
      );
    in
    {
      # Filesystem
      boot = {
        supportedFilesystems.zfs = true;
        # Refuse a root pool last imported by another hostId, instead of forcing it.
        zfs.forceImportRoot = false;
      };

      # Import
      ## The initrd's import polls for its pool for a minute from early boot, without waiting for LUKS, so a slow passphrase entry outlasts it.
      ## https://github.com/NixOS/nixpkgs/issues/31258
      boot.initrd.systemd.services = lib.genAttrs (map (pool: "zfs-import-${pool}") rootPools) (_: {
        after = [ "cryptsetup.target" ];
        wants = [ "cryptsetup.target" ];
      });

      services = {
        # Integrity
        zfs.autoScrub = {
          enable = true;
          interval = "monthly";
        };

        # Snapshots
        ## Hosts pick the datasets with services.sanoid.datasets.
        ## Not named `default`: sanoid applies a template by that name to every dataset, whatever useTemplate says.
        sanoid = {
          enable = true;
          templates.standard = {
            hourly = 24;
            daily = 14;
            monthly = 3;
            autosnap = true;
            autoprune = true;
          };
        };
      };
    };
}
