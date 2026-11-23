/*
  Unlocks every LUKS disk with the TPM2, so the host boots unattended.
  Based on https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/

  Each disk unlocks with the first of:
  1. its TPM slot, bound to the PCRs in tpmUnlock.pcrs;
  2. the install's keyfile, while it is on the ESP;
  3. the recovery passphrase, typed at the console.

  tpm-sync runs once per boot and enrolls the TPM on any disk whose slot doesn't match those PCRs.
  On the first boot it uses the keyfile, then removes it; after the PCR set changes in config, it uses the old TPM slot.
  When the measured values change instead, as after a firmware update or turning Secure Boot on, the TPM refuses to unlock and tpm-sync can't tell: a passphrase prompt at boot is the only sign. Type the passphrase, then run `sudo tpm-enroll`.

  Known gap: someone at the machine can swap in a fake disk to make the TPM release the key.
  https://oddlama.org/blog/bypassing-disk-encryption-with-tpm2-unlock/
*/

{
  flake.nixosModules.tpmUnlock =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.tpmUnlock;
      inherit (cfg) keyFile;
      espMount = config.boot.loader.efi.efiSysMountPoint;
      esp = config.fileSystems.${espMount}.device;
      names = lib.attrNames config.boot.initrd.luks.devices;
      devices = map (luks: luks.device) (lib.attrValues config.boot.initrd.luks.devices);
      # Ascending, the order the LUKS token stores them in, so tpm-sync can compare the two as text.
      pcrs = lib.concatMapStringsSep "+" toString (lib.sort lib.lessThan (lib.unique cfg.pcrs));
      enrollFlags = "--wipe-slot=tpm2 --tpm2-device=auto --tpm2-pcrs=${pcrs}";
    in
    {
      options = {
        tpmUnlock.pcrs = lib.mkOption {
          type = lib.types.nonEmptyListOf (lib.types.ints.between 0 23);
          # systemd-boot measures the kernel command line into PCR 12, and NixOS puts the generation's store path in it, so it changes on every rebuild.
          default = [
            0
            2
            7
          ]
          ++ lib.optional (!config.boot.loader.systemd-boot.enable) 12;
          defaultText = lib.literalExpression "[ 0 2 7 ] ++ lib.optional (!config.boot.loader.systemd-boot.enable) 12";
          description = "PCRs the TPM checks before releasing a disk key: firmware code (0, 2), Secure Boot state and keys (7), and kernel command line and credentials (12).";
        };

        tpmUnlock.keyFile = lib.mkOption {
          type = lib.types.str;
          readOnly = true;
          default = "luks.key";
          description = "Name of the install's first-boot keyfile at the root of the ESP";
        };

        # Extends every LUKS device, whatever the disk layout names it.
        boot.initrd.luks.devices = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              # Makes systemd-cryptsetup wait for a TPM whose driver loads late.
              crypttabExtraOpts = [ "tpm2-device=auto" ];
            }
          );
        };
      };

      config = {
        assertions = [
          {
            assertion = devices != [ ];
            message = "tpmUnlock is imported, but the host has no LUKS device.";
          }
          {
            assertion = config.fileSystems ? ${espMount};
            message = "tpmUnlock reads the first-boot keyfile from the ESP, but nothing is mounted at ${espMount}.";
          }
          {
            assertion = !(config.boot.loader.systemd-boot.enable && lib.elem 12 cfg.pcrs);
            message = "tpmUnlock binds PCR 12, which changes on every rebuild under systemd-boot. Drop 12 from tpmUnlock.pcrs until the host boots with lanzaboote.";
          }
        ];

        # Initrd
        boot.initrd = {
          systemd.enable = true;
          supportedFilesystems.vfat = true;
        };

        # First-boot keyfile
        ## systemd-cryptsetup tries a key in /etc/cryptsetup-keys.d after the TPM slot, and the initrd's /etc is gone after switch-root.
        ## Don't set the devices' keyFile: systemd-cryptsetup would read it as a sealed TPM blob and skip the TPM slot.
        boot.initrd.systemd.services.tpm-keyfile = {
          description = "Hand the first-boot LUKS keyfile from the ESP to systemd-cryptsetup";
          wantedBy = [ "cryptsetup.target" ];
          wants = [ "cryptsetup-pre.target" ];
          before = [ "cryptsetup-pre.target" ];
          after = [
            "systemd-modules-load.service"
            "systemd-udev-trigger.service"
          ];
          unitConfig.DefaultDependencies = false;
          serviceConfig.Type = "oneshot";
          script = /* bash */ ''
            # Without the ESP, the TPM or the passphrase unlocks the disks.
            esp=${lib.escapeShellArg esp}
            if ! udevadm wait --timeout=60 "$esp"; then
              echo "$esp didn't show up, so no keyfile for the disks." >&2
              exit 0
            fi
            mkdir -p /run/tpm-unlock-esp
            if ! mount -t vfat -o ro "$esp" /run/tpm-unlock-esp; then
              echo "Couldn't mount $esp, so no keyfile for the disks." >&2
              exit 0
            fi
            if [[ -e /run/tpm-unlock-esp/${keyFile} ]]; then
              mkdir -p -m 0700 /etc/cryptsetup-keys.d
              for name in ${lib.escapeShellArgs names}; do
                install -m 0400 /run/tpm-unlock-esp/${keyFile} "/etc/cryptsetup-keys.d/$name.key"
              done
            fi
            umount /run/tpm-unlock-esp
          '';
        };

        # Manual enrollment
        ## Asks for each disk's passphrase, and binds the TPM to the PCRs as measured on the current boot.
        environment.systemPackages = [
          (pkgs.writeShellApplication {
            name = "tpm-enroll";
            runtimeInputs = [ config.systemd.package ];
            text = /* bash */ ''
              devices=(${lib.escapeShellArgs devices})
              for dev in "''${devices[@]}"; do
                systemd-cryptenroll ${enrollFlags} "$dev"
              done
            '';
          })
        ];

        # Automatic enrollment
        systemd.services.tpm-sync = {
          wantedBy = [ "multi-user.target" ];
          after = [ "tpm2.target" ];
          # Enrolling binds the PCRs of the current boot, so this runs once per boot and never on a switch.
          ## A switch starts the unit again through multi-user.target, even after it failed, and the marker in /run stops that.
          unitConfig = {
            RequiresMountsFor = espMount;
            ConditionPathExists = "!/run/tpm-sync.ran";
          };
          serviceConfig.Type = "oneshot";
          restartIfChanged = false;
          path = [
            pkgs.cryptsetup
            pkgs.jq
            config.systemd.package
          ];
          script = /* bash */ ''
            set -uo pipefail
            touch /run/tpm-sync.ran
            key=${espMount}/${keyFile}
            devices=(${lib.escapeShellArgs devices})
            failed=0

            # Returns early on any error: set -e doesn't apply inside a function called from an if.
            sync_disk() {
              local dev=$1 enrolled has_key=false
              enrolled=$(cryptsetup luksDump --dump-json-metadata "$dev" \
                | jq -r '[.tokens[] | select(.type == "systemd-tpm2") | ."tpm2-pcrs" | join("+")] | first // "none"') \
                || return 1
              if [[ -e $key ]] && cryptsetup open --test-passphrase --key-file="$key" "$dev"; then
                has_key=true
              fi

              if [[ $enrolled != "${pcrs}" ]]; then
                if $has_key; then
                  systemd-cryptenroll --unlock-key-file="$key" ${enrollFlags} "$dev" || return 1
                elif [[ $enrolled != none ]]; then
                  # Refuses when the PCRs no longer match the slot.
                  systemd-cryptenroll --unlock-tpm2-device=auto ${enrollFlags} "$dev" || return 1
                else
                  return 1
                fi
              fi

              if $has_key; then
                cryptsetup luksRemoveKey --batch-mode "$dev" "$key" || return 1
              fi
            }

            for dev in "''${devices[@]}"; do
              if ! sync_disk "$dev"; then
                echo "$dev: couldn't sync the TPM slot to PCRs ${pcrs}. Type the passphrase at the next boot, then run tpm-enroll." >&2
                failed=1
              fi
            done

            # A disk that failed still needs the keyfile on the next boot.
            if [[ $failed == 0 ]]; then
              rm -f "$key"
            fi
            exit "$failed"
          '';
        };
      };
    };
}
