{ inputs, ... }:
{
  flake.nixosModules.lovelace = {
    imports = [ inputs.disko.nixosModules.disko ];

    disko.devices.disk.main = {
      type = "disk";
      # By PCI path: probe order can't change it, and it carries no serial. Only the install reads it.
      device = "/dev/disk/by-path/pci-0000:01:00.0-nvme-1";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            type = "EF00";
            size = "1G";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              # vfat has no permissions of its own, and the first-boot keyfile sits here, so only root may read it.
              mountOptions = [ "umask=0077" ];
            };
          };
          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "crypted";
              # The install copies both onto the target before disko runs: the recovery passphrase from sops, and a keyfile made for this install only.
              passwordFile = "/tmp/luks-passphrase";
              additionalKeyFiles = [ "/tmp/luks.key" ];
              # Lets TRIM reach the SSD through LUKS.
              settings.allowDiscards = true;
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };

    disko.devices.zpool.zroot = {
      type = "zpool";
      options = {
        # 4 KiB blocks, native to flash even when the drive reports 512-byte sectors. Fixed once the pool exists.
        ashift = "12";
        autotrim = "on";
      };
      # Set on the top dataset so every dataset inherits them.
      rootFsOptions = {
        compression = "lz4";
        # Extended attributes in the inode, which saves a lookup on every ACL check.
        xattr = "sa";
        # journald grants read access to its files through POSIX ACLs.
        acltype = "posixacl";
        relatime = "on";
        # Lets xattr=sa's attributes fit without spilling into another block.
        dnodesize = "auto";
        # The top dataset only carries inherited properties.
        mountpoint = "none";
        canmount = "off";
      };
      mountpoint = null;
      # An empty root to roll back to, if root ever becomes impermanent.
      # The guard keeps a second disko run from failing on the existing snapshot.
      postCreateHook = "zfs list -t snapshot -H -o name | grep -E '^zroot/root@blank$' || zfs snapshot zroot/root@blank";

      # atime is off wherever nothing reads access times.
      datasets = {
        root = {
          type = "zfs_fs";
          mountpoint = "/";
        };
        nix = {
          type = "zfs_fs";
          mountpoint = "/nix";
          options.atime = "off";
        };
        log = {
          type = "zfs_fs";
          mountpoint = "/var/log";
          options.atime = "off";
        };
        home = {
          type = "zfs_fs";
          mountpoint = "/home";
        };
        srv = {
          type = "zfs_fs";
          mountpoint = "/srv";
        };
      };
    };

    # nix and log can be rebuilt or churn.
    services.sanoid.datasets = {
      "zroot/root".useTemplate = [ "standard" ];
      "zroot/home".useTemplate = [ "standard" ];
      "zroot/srv".useTemplate = [ "standard" ];
    };
  };
}
