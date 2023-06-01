# Containers

This section contains additional information on working with containers.

**NOTE:** These containers are configured for a production environment.

- You may run into issues if attempting to use containers for development (e.g. database name issues).
- The easiest way to work in a dev environment is to run `just start`.
  - Requires [`just`](https://github.com/casey/just) task runner to be installed

This project has ready-made configurations to easily run the following services as Docker/Podman containers alongside this Phoenix project:

- Postgres
- Traefik

In order to maximize flexibility, the service containers (e.g. Phoenix, Postgres, etc.) do not specify networks. This means that for each service (except Traefik\*), you must specify at least 2 Compose files:

1. A Compose file that specifies the service (located in `support/containers/`).
2. A Compose file that specifies the service's network (located in `support/containers/networks/`).

\*Traefik always uses it's own Docker/Podman proxy network, so you don't need to specify a network Compose configuration for Traefik.

## Compose Examples

- To save on typing, you can use the scripts in the `support/scripts/containers` directory to run the configurations described in this section.
  - If switching between Docker and Podman, you will need to delete the `support/containers/volumes/postgres` directory.
- All commands in this section must be run from the `support/containers/` directory.
- If the environment has not been loaded automatically with `direnv`, you may need to include the `.env` file manually using `--env-file .env` when running one or more Compose files.

### Running a Standalone Phoenix Container

**NOTE:** If the server cannot connect to a Postgres server, the container will stop.

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

NOTE: This configuation uses a small extra Compose file: `compose.phoenix-postgres.yaml`. This file ensures that Phoenix will not start until Postgres is available. The Phoenix container may fail to start if this file is not present. (It should restart automatically, but this ensures that the container composer (e.g. 'docker-compose') will not give up after `n` attempts).

Examples:

- Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`
- Podman: `podman-compose -f compose.phoenix.yaml -f networks/compose.phoenix-host.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-host.yaml up`
- If the environment has not been loaded automatically with `direnv`, you will need to include the `.env` file manually using `--env-file .env` when starting the Docker Compose containers.

### Deploying With Traefik

**Traefik always uses it's own Docker/Podman proxy network, so you don't need to specify a network Compose configuration for Traefik.**

**NOTE:** When running a Traefik container, the volumes will be created in the `support/containers/traefik/volumes` directory instead of `support/containers/volumes`. I am not sure why.

Because Traefik can require a lot of custom configuration, it has its own directory, which is a submodule of [this repo](https://github.com/arcanemachine/traefik-generic). Its Compose files are located in the `support/containers/traefik` directory.

To run this project's built-in Traefik container service:

- Ensure that you set the required environment variable(s) before running Docker Compose:
  - `TRAEFIK_HOST`: The URL to use for the Traefik dashboard
    - e.g. `TRAEFIK_HOST=localhost`
  - A generic `.env` file can be created using the `support/scripts/dotenv-generate script`
- You will need to include the following Compose files when running a Traefik container via `docker-compose`:
  - `compose.traefik.yaml`
    - The Traefik container
  - `compose.traefik-config-[local|remote].yaml` (pick one of `local` or `remote`)
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
    - In a local environment (HTTP only):
      - Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-local.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f compose.traefik.yaml -f compose.traefik-config-local.yaml up`
      - Podman: `docker-compose -H unix:$(podman info --format '{{.Host.RemoteSocket.Path}}') -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-local.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f compose.traefik.yaml -f compose.traefik-config-local.yaml up`
    - In a remote environment (exposed to Internet, uses HTTPS):
      - Docker: `docker compose -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-remote.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f compose.traefik.yaml -f compose.traefik-config-remote.yaml up`
      - Podman: `podman-compose -H unix:$(podman info --format '{{.Host.RemoteSocket.Path}}') -f compose.phoenix.yaml -f networks/compose.phoenix-traefik.yaml -f compose.phoenix-config-traefik-remote.yaml -f compose.phoenix-postgres.yaml -f compose.postgres.yaml -f networks/compose.postgres-traefik.yaml -f compose.traefik.yaml -f compose.traefik-config-remote.yaml up`
    - To avoid running these long commands, use the easy-use scripts in `support/containers/scripts`.
- To access the Traefik dashboard:
  - Using a web browser, navigate to the location of your `$TRAEFIK_HOST`.
    - e.g. `http://localhost/`
- To access the Phoenix web service:
  - Using a web browser, navigate to the location of your `$PHX_HOST`.
    - e.g. `http://phoenix-todo-list.localhost/`

### Resetting the Containers

To reset the containers, run the following commands (for Podman, replace `docker` with `podman`):

- Remove all stopped containers and unused networks
  - Docker: `docker system prune`
  - Podman: `podman system prune`
- If a container is still running:
  - Stop the container: `docker stop [container-name]`
  - Remove the container: `docker rm [container-name]`
- If you are using Traefik:
  - Re-create the Trafik proxy network: `docker network create traefik-global-proxy`
- Start the containers again: `docker-compose [your containers] up`

## Telemetry

**Disclaimer: This section is intended as a _starting point_ to get a telemetry service up and running. Keep in mind that the server's `/metrics` endpoint is publicly available, and should be secured when deploying to the Internet. See `support/deployment/caddy/Caddyfile.prod` for an example of a Caddyfile that uses HTTP basic authentication to secure this endpoint.**

This section describes the process of getting a telemetry frontend service working, powered by [PromEx](https://github.com/akoutmos/prom_ex/) + [Prometheus](https://github.com/prometheus/prometheus) + [Grafana](https://github.com/grafana/grafana).

Note: For the sake of simplification, this document assumes you are working in a dev environment. For example, the `./etc/prometheus.yml` config uses the `http://localhost:4001` endpoint for scraping metrics data. If you are working in a different environment, you will need to modify this config file.

## Overview

- Elixir and Phoenix have powerful built-in telemetry, powered by the [`telemetry`](https://hexdocs.pm/telemetry/readme.html) Elixir library.
- PromEx exposes built-in and custom telemetry data via an HTTP endpoint that can be consumed by Prometheus, which is a "a monitoring system and time-series database".
- The data from Prometheus is displayed using Grafana, which is an "open and composable observability and data visualization platform".

## Setup Instructions

### Setting up PromEx

All commands in this section should be run from the project root directory.

This step has already been completed for this project, but I am leaving this note here as a reminder to my future self and others who have to go through this process:

- When generating the `prom_ex.ex` module with PromEx, use `prometheus` as the name of your data source:
  - `mix prom_ex.gen.config --datasource prometheus`
    - NOTE: The datasource must match the name of your Grafana data source.
      - For consistency, these instructions use all lowercase letters when naming the data source.

### Setting up Prometheus

All commands in this section should be run from the directory `support/containers/`.

- Run `docker compose -f compose.prometheus.yml up` to start a Prometheus container.
  - The `etc/prometheus.yml` file uses the default `http://localhost:4001` URL to access your Phoenix server's metrics
    - If you are using a different URL, modify the `prometheus.yml` file and restart the container after saving your changes.
- After running this script, the Prometheus server should automatically start scraping your Phoenix server's metrics via PromEx.
  - To ensure that Prometheus is working, you can navigate to `http://localhost:9090/targets` in your browser.
    - The `State` of both targets (`prometheus` and `phoenix-todo-list`) should be `UP`
    - The `Last Scrape` for each target should be within the past 5 seconds.
      - If this is not the case, then check to make sure the targets have been configured properly in `etc/prometheus.yml`.

### Setting up Grafana

All commands in this section should be run from the directory `support/containers/` (unless otherwise indicated).

- Run `docker compose -f compose.grafana.yml up` to start a Prometheus container.
- Navigate to `localhost:3000` and login to Grafana.
  - The default username is `admin` and the default password is `admin`.
- Set a new password when prompted.
- Add Prometheus as a new data source:
  - Click the "Add your first data source" item on the homepage
    - Or, `Hamburger Menu` -> Click `Connections` -> `Data Sources` -> `Add new data source`
  - Select `Prometheus`.
  - Name the data source `prometheus`.
    - Use lowercase letters so it matches the PromEx datasource name this project used when setting up PromEx.
  - Enter the URL of our Prometheus server: `http://localhost:9090`
  - If your `/metrics` endpoint requires authentication, configure that field now.
    - If this service is accessible from the Internet, your `/metrics` endpoint should require authentication of some sort.
      - If you do not enable authentication:
        - You may leak sensitive data about the server.
        - You make it easier to DoS your server from strangers requesting data from your `/metrics` endpoint.
  - Click the `Save & test` button at the bottom of the page to save our changes.
- Create a dashboard so we can view the data that Prometheus scraped from our server.
  - `Hamburger Menu` -> Click `Dashboards` -> `New` -> `Import`
- Now we will use `mix` to generate the dashboard with a PromEx `mix`:
  - PromEx has several built-in plugins (e.g. `Application`, `Beam`), each of which comes with a dashboard interface.kkl
    - For this example, we'll generate a dashboard for the Application plugin.
      - NOTE: The `Application` and `Beam` PromEx plugins are enabled by default.
        - To enable other plugins/dashboards (e.g. `Phoenix`), you will need to uncomment the relevant lines in the `plugins` and `dashboards` sections of the `lib/todo_list/prom_ex.ex` module.
    - Use Mix to generate the dashboard:
      - Navigate to the project root directory.
      - `mix prom_ex.dashboard.export --dashboard application.json --stdout`
    - Copy the JSON output to the clipboard.
- Back in Grafana, paste the JSON output into the `Import via panel json` section.
- Press the `Load` button at the bottom of the page.
- Press the `Import` button to finish creating the dashboard.
- Now, the dashboard should be visible. That means we're done.
