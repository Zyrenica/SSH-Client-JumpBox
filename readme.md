# SSH Client Jumpbox

## Install:

- git copy repository to server in its own folder.
- gpg encrypt the key with a passphrase and name the file `keyfile.gpg`
- Modify config and compose files replacing any <>'d variables and adding extra hosts and IP's as needed.
- Use `nmcli con mod <connection name> +ipv4.addresses "IP/Mask, IP/Mask, etc"` to add interface aliases (Works in Ubuntu 22.04 and should work in any other linux that uses NetworkManager)
- use `docker build -t ssh_jumpbox .` to build image.

## Start Tunnels:

- run `docker compose up <service names>` to bring tunnel up.

## Stop Tunnels:

- run `docker compose down <names>` for individual tunnels.
- run `docker compose -p "*" down` for all tunnels.
