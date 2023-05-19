# Container Helper Scripts

This is a collection of scripts designed to save you from having to type out tedious Compose file names when orchestrating your containers. The script names are (hopefully) self-explanatory.

# Notes

- The first positional argument must be the `docker-compose` action you want to perform, e.g. up, down, restart, etc.
- When running a Traefik container, your will need to specify 'local' or 'remote' (without quotes) as the second positional argument.
  - local - no HTTPS
  - remote - uses HTTPS
- To use Podman instead of Docker, pass the flag '--podman' as the last positional argument.
- Running any of the Traefik containers will attempt to create a `traefik-global-proxy` network before starting the containers.

## Troubleshooting

- If switching between Docker and Podman, you will need to delete the Postgres volume located in: `support/containers/volumes/postgres`
  - e.g. `sudo rm -rf support/containers/volumes/postgres`
  - You can use the `support/scripts/containers/container-volumes-delete` script to automate the process.
