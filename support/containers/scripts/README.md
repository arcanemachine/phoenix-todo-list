# /support/containers/scripts

This is a hacky collection of scripts designed to save you from having to type out tedious Compose file names when orchestrating your containers. The script names should be self-explanatory.

Notes:

- Running any of the Traefik containers will attempt to create a `traefik-global-proxy` network before starting the containers.
- If switching between Docker and Podman, you will need to delete the PostgreSQL volume, which may be in 1 of 2 locations:
  - When not using a Traefik container: `support/containers/volumes/postgres`
  - When using a Traefik container: `support/containers/traefik/volumes/postgres`
