# Container Helper Scripts

This is a hacky collection of scripts designed to save you from having to type out tedious Compose file names when orchestrating your containers. The script names should be self-explanatory.

# Notes

- The first positional argument must be the `docker-compose` action you want to perform, e.g. up, down, restart, etc.
- When running a Traefik container, your will need to specify 'local' or 'remote' (without quotes) as the second positional argument.
  - local - no HTTPS
  - remote - uses HTTPS
- To use Podman instead of Docker, pass the flag '--podman' as the last positional argument.

- Running any of the Traefik containers will attempt to create a `traefik-global-proxy` network before starting the containers.

## Troubleshooting

- If switching between Docker and Podman, you will need to delete the Postgres volume, which may be in 1 of 2 locations:
  - When not using a Traefik container: `support/containers/volumes/postgres`
  - When using a Traefik container: `support/containers/traefik/volumes/postgres`
