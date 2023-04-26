# Extra Docker/Podman Deployment Strategies

##### \*\*\* All commands in this document must be run from the `support/containers/` directory. \*\*\*

---

This project has ready-made configurations to easily run the following services as Docker/Podman containers alongside this Phoenix project:

- PostgreSQL
- Traefik

In order to maximize flexibility, the service containers (e.g. Phoenix, PostgreSQL, etc.) do not specify networks. This means that for each service (except Traefik\*), you must specify at least 2 Compose files:

1. A Compose file that specifies the service (located in `support/containers/`).
2. A Compose file that specifies the service's network (located in `support/containers/networks/`).

\*Traefik always uses it's own proxy network, so you don't need to specify a network Compose configuration for Traefik.

Example:

- Launch a Phoenix + Postgres container with host networking (i.e. not isolated to the Docker network):
  - `docker compose -f compose.postgres.yaml -f networks/compose.postgres-host.yaml -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml up`
  - If the environment has not been loaded automatically with `direnv`, you will need to include the `.env` file manually using `--env-file .env` when starting the Docker Compose containers.

## Deploying With Traefik

Because Traefik can require a lot of custom configuration, it has its own directory, which is a submodule of [this repo](https://github.com/arcanemachine/traefik-generic). Its Compose files have been symlinked to the `support/containers/` directory so that the Compose services run without issue. (Using Compose files in other directories can cause issues with relative pathnames, e.g. for Docker volumes.)

To run this project's built-in Traefik container service:

- Run the Traefik-specific setup script:
  - `/traefik/setup`
    - This script configures the Traefik container and creates the `traefik-global-proxy` Docker network.
      - To create the network manuall, run `docker network create traefik-global-proxy`.
- Ensure that you set the required environment variable(s) before running Docker Compose:
  - `TRAEFIK_HOST`: The URL to use for the Traefik dashboard
  - A generic `.env` file can be created using the `support/scripts/env-generate script`
- You will need to include the following Compose files when running this Traefik container Docker Compose:
  - `./compose.traefik.yaml`
    - The Traefik container
  - `./compose.traefik-config-[dev|prod].yaml`
    - The Traefik container's environment-specific config
  - `compose.phoenix.yaml`
    - This project's Phoenix container
  - `networks/compose.phoenix-traefik.yaml`
    - This project's network configuration for Phoenix + Traefik
  - `compose.phoenix-config-traefik-[dev|prod].yaml`
    - This project's environment-specific Traefik configuration
- Example:
  - Traefik + Postgres + Phoenix:
    - `docker compose -f traefik/compose.yaml -f traefik/compose.dev.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-dev.yaml up`

## Resetting the Containers

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
