# /support/containers/

Additional information on working with containers.

**NOTE:** These containers are configured for a production environment. You may run into issues if attempting to use containers for development (e.g. database name issues).

This project has ready-made configurations to easily run the following services as Docker/Podman containers alongside this Phoenix project:

- PostgreSQL
- Traefik

In order to maximize flexibility, the service containers (e.g. Phoenix, PostgreSQL, etc.) do not specify networks. This means that for each service (except Traefik\*), you must specify at least 2 Compose files:

1. A Compose file that specifies the service (located in `support/containers/`).
2. A Compose file that specifies the service's network (located in `support/containers/networks/`).

\*Traefik always uses it's own Docker/Podman proxy network, so you don't need to specify a network Compose configuration for Traefik.

## Compose Examples

- To save on typing, you can use the scripts in the `support/containers/scripts` directory to run the configurations described in this section.
  - If switching between Docker and Podman, you will need to delete the `support/containers/volumes/postgres` directory.
- All commands in this section must be run from the `support/containers/` directory.
- If the environment has not been loaded automatically with `direnv`, you may need to include the `.env` file manually using `--env-file .env` when running one or more Compose files.

### Running a Standalone Phoenix Container

**NOTE:** If the server cannot connect to a PostgreSQL server, the container will stop.

Launch a standalone container with host networking (i.e. not isolated to a Docker network):

Examples:

- Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml up`
- Podman: `podman-compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml up`

### Running a Standalone Postgres Container

Launch a **Postgres** container with host networking (i.e. not isolated to a Docker network):

Examples:

- Docker: `docker compose -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`
- Podman: `podman-compose -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`

### Running Phoenix + Postgres Containers Together

NOTE: This configuation uses a small extra Compose file: `compose.phoenix-postgres.yaml`. This file ensures that Phoenix will not start until Postgres is available. The Phoenix container may fail if this file is not present. (It should restart automatically, but this ensures that the container orchestrator (e.g. 'docker-compose') will not give up after `n` attempts).

Examples:

- Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`
- Podman: `podman-compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`
- If the environment has not been loaded automatically with `direnv`, you will need to include the `.env` file manually using `--env-file .env` when starting the Docker Compose containers.

### Deploying With Traefik

**Traefik always uses it's own Docker/Podman proxy network, so you don't need to specify a network Compose configuration for Traefik.**

**NOTE:** When running a Traefik container, the volumes will be created in the `support/containers/traefik/volumes` directory instead of `support/containers/volumes`. I am not sure why.

Because Traefik can require a lot of custom configuration, it has its own directory, which is a submodule of [this repo](https://github.com/arcanemachine/traefik-generic). Its Compose files are located in the `support/containers/traefik` directory.

To run this project's built-in Traefik container service:

- Run the Traefik container setup script:
  - `/traefik/setup [local|remote]`
    - Must specify `local` or `remote`.
      - `local` is for local dev. It doesn't use HTTPS.
      - `remote` assumes your machine is exposed to the Internet and enables HTTPS.
    - This script configures the Traefik container + config, and creates the `traefik-global-proxy` Docker network.
      - To create the network manually, run `docker network create traefik-global-proxy`.
- Ensure that you set the required environment variable(s) before running Docker Compose:
  - `TRAEFIK_HOST`: The URL to use for the Traefik dashboard
  - A generic `.env` file can be created using the `support/scripts/dotenv-generate script`
- You will need to include the following Compose files when running this Traefik container Docker Compose:
  - `compose.traefik.yaml`
    - The Traefik container
  - `compose.traefik-config-[local|remote].yaml`
    - The Traefik container's environment-specific config
  - `compose.phoenix.yaml`
    - This project's Phoenix container
  - `networks/compose.phoenix-traefik.yaml`
    - This project's network configuration for Phoenix + Traefik
  - `compose.phoenix-config-traefik-[local|remote].yaml`
    - This project's environment-specific Traefik configuration
- Create a Docker network for proxying services through Traefik:
  - Docker: `docker network create traefik-global-proxy`
  - Podman: `podman network create traefik-global-proxy`
  - **NOTE:** The name `traefik-global-proxy` is hardcoded in the Compose files. Do not use a different name for the network!
- Launch the **Postgres + Traefik + Phoenix** container service:
  - Examples:
    - In a local environment (hidden behind NAT, no HTTPS):
      - Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-local.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f traefik/compose.yaml -f traefik/compose.config-local.yaml up`
      - Podman: `podman-compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-local.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f traefik/compose.yaml -f traefik/compose.config-local.yaml up`
    - In a remote environment (exposed to Internet, uses HTTPS):
      - Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-remote.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f traefik/compose.yaml -f traefik/compose.config-remote.yaml up`
      - Podman: `podman-compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-remote.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f traefik/compose.yaml -f traefik/compose.config-remote.yaml up`

### Resetting the Containers

To reset the containers, run the following commands:

- `docker system prune` - Remove all stopped containers and unused networks

- If a container is still running:

  - Stop the container: `docker stop [container-name]`
  - Remove the container: `docker rm [container-name]`

- Re-create the Trafik proxy network: `docker network create traefik-global-proxy`

- Start the containers again: `docker compose [your containers] up`

Notes:

- To use this project with an external Traefik service, the `compose.traefik-config.yaml` Compose file will still be useful.
- To use this project with Podman or rootless Docker, see the [Troubleshooting](https://github.com/arcanemachine/traefik-generic#troubleshooting) section of the [`traefik-generic`](https://github.com/arcanemachine/traefik-generic) README for more info.
