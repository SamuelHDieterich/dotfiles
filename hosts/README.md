# Hosts

The hostnames are named after famous scientists and inventors.

- [**tesla**](https://en.wikipedia.org/wiki/Nikola_Tesla): Personal laptop with NixOS (main device).
- [**turing**](https://en.wikipedia.org/wiki/Alan_Turing): Work laptop with Home-Manager (company device).
- [**lovelace**](https://en.wikipedia.org/wiki/Ada_Lovelace): (WIP) Homelab server with NixOS.

## Adding a headless host

A headless host imports `ssh`; its SSH host key is its sops identity. Generate the key once, here, so reinstalls keep it.

1. Hardware report and disk name, from the target's current OS:

   ```bash
   nixos-anywhere --flake .#<host> --target-host <target> --phases kexec \
     --no-use-machine-substituters \
     --generate-hardware-config nixos-facter hosts/<host>/facter.json
   ssh root@<ip> 'ls -l /dev/disk/by-path/ /dev/disk/by-id/'
   ```

   Name disks in disko by `by-path`: no serial in the repo, and only the install reads it.

2. Host key and its age recipient:

   ```bash
   tmp=$(mktemp -d)
   ssh-keygen -t ed25519 -N "" -C "root@<host>" -f "$tmp/key"
   ssh-to-age < "$tmp/key.pub"     # → age1…
   ```

3. In `.sops.yaml`, add the recipient as `&<host>`, a rule for `^hosts/<host>/secrets/secrets\.yaml$` with `*primary` and `*<host>` above the shared rule, and `*<host>` to the shared rule. Then:

   ```bash
   mkdir -p hosts/<host>/secrets
   sops encrypt --filename-override hosts/<host>/secrets/ssh_host_ed25519_key \
     --input-type binary --output-type binary "$tmp/key" > hosts/<host>/secrets/ssh_host_ed25519_key
   sops updatekeys secrets/secrets.yaml
   sops edit hosts/<host>/secrets/secrets.yaml
   git add --intent-to-add hosts/<host>/secrets hosts/<host>/facter.json
   ```

   Prove the host can decrypt before installing; a host that can't decrypt its user's password locks you out:

   ```bash
   export SOPS_AGE_KEY=$(ssh-to-age -private-key -i "$tmp/key")
   sops decrypt hosts/<host>/secrets/secrets.yaml >/dev/null && sops decrypt secrets/secrets.yaml >/dev/null && echo ok
   unset SOPS_AGE_KEY
   rm -r "$tmp"
   ```

4. Install, seeding the key through `--extra-files`:

   ```bash
   root=$(mktemp -d)
   install -d -m 755 "$root/etc/ssh"
   sops decrypt --input-type binary --output-type binary hosts/<host>/secrets/ssh_host_ed25519_key > "$root/etc/ssh/ssh_host_ed25519_key"
   chmod 600 "$root/etc/ssh/ssh_host_ed25519_key"
   nixos-anywhere --flake .#<host> --target-host <target> --extra-files "$root"
   rm -r "$root"
   ```

Hosts with an encrypted disk add `--disk-encryption-keys`; see the host's own README.
