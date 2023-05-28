# phoenix-todo-list

[View Live Demo](https://phoenix-todo-list.nicholasmoen.com/)

---

**All commands in this document should be performed from the project root directory.**

---

Yet another todo list. Made using the [Phoenix web framework](https://www.phoenixframework.org/).

Features:

- Basic CRUD
- LiveView CRUD
- REST API
- OpenAPI spec available in [JSON](https://phoenix-todo-list.nicholasmoen.com/static/openapi.json) and [YAML](https://phoenix-todo-list.nicholasmoen.com/static/openapi.yaml)
- [Insomnia](https://insomnia.rest/) spec for easy HTTP/API endpoint debugging
- Elixir tests (ExUnit)
- Javascript-based unit tests (Vitest)
- Javascript-based E2E tests (Playwright)
- GitHub Actions CI
- Releases (vanilla/Docker/fly.io)
  - Supports `x86_64` + `aarch64` (`ARM64v8`) Docker images
- Supports a variety of container-based environments using Docker/Podman
- EditorConfig (standardizes file formatting: spaces per line, etc.)
- Enforces standardized commit messages with [`git-conventional-commits`](https://github.com/qoomon/git-conventional-commits)
- Uses [`just`](https://github.com/casey/just) task runner
- Uses [PromEx](https://github.com/akoutmos/prom_ex/) to generate metrics data for use with [Prometheus](https://github.com/prometheus/prometheus) + [Grafana](https://github.com/grafana/grafana) dashboards
- Uses [Sentry](https://sentry.io/) for error monitoring

## Getting Started

### Working in a `dev` Environment

Before you work in a `dev` environment, ensure that your environment variables are set correctly:

- You can set custom/private environment variables in `.env` so that they will not be accidentally committed to source control
  - Use the `support/scripts/dotenv-generate` script to generate a `.env` file to get you started.
  - It is recommended to use `direnv` to easily load your environment when navigating within this project's directories.
- Setup Postgres:
  - For easy Postgres setup, run `just postgres`. (must have [`just`](https://github.com/casey/just) task runner installed)
- Setup and run the server:
  - The easy way (must have `just` installed): `just dev`
  - The manual way:
    - Run `mix deps.get` to fetch the dependencies.
    - Setup the database: `mix ecto.setup`
    - Start a dev server:
      - `mix phx.server` - The regular method of starting a dev server
      - Or, `iex -S mix phx.server` - Starts a dev server in an `IEx` session. Useful for debugging.
- Your server should now be accessible on `localhost:4001`.
  - This project's ports are set by configuring the `PORT` environment variable (e.g. in the `.env` file).
    - Production: The default port is `PORT` (e.g. 4000)
    - Development: The default port is `PORT + 1` (e.g. 4001)
    - Testing: The default port is `PORT + 2` (e.g. 4002)

### Testing

Before running any tests, use the instructions above to ensure that:

- The required environment variables have been set.
  - Use the instructions in the previous step to create a basic `.env` file in the project root directory.
- A Postgres server is up and running.
  - To easily create a Postgres server container, run `just postgres`.
  - You may need to create a test database: `MIX_ENV=test mix ecto.create`
  - If any errors occur during the tests, try resetting the test database: `MIX_ENV=test mix ecto.reset`
    - For example, the E2E test scripts reset the database between test runs. However, if the script is aborted, the database may not be reset, which can effect the results of `mix test`.

#### Elixir-Based Tests

Run the Elixir-based tests using any of these commands:

- `mix test` - The regular method of running the tests.
- `support/scripts/test-elixir` - A convenience script for running the Elixir tests.
  - This script clears the test database before running the tests. This prevents any issues that may be caused when the test database is not cleared, e.g. during failed E2E test run.
- `support/scripts/test-elixir-watch` - A convenience script for running the Elixir-based tests in watch mode.

#### Javascript-Based Tests

Before running any Javascript-based tests:

- Ensure that `npm` is installed and working on your system.
- Navigate to the `test/js/` directory and run `npm install`

Then, navigate back to the project root directory and continue reading for instructions on how to run this project's Javascript-based tests.

##### JS Unit Tests (Vitest)

Run the Javascript-based unit tests using any of these commands:

- `support/scripts/test-js` - A convenience script for running the Vitest unit tests.
- `support/scripts/test-js-watch` - A convenience script for running the Vitest unit tests in watch mode.
- `cd assets && npx playwright test` - Navigate to the JS test root directory and run the JS E2E tests directly.

##### End-To-End Tests (Playwright)

Run the Javascript-based end-to-end (E2E) Playwright tests using any of these commands:

- `support/scripts/test-e2e` - A convenience script for running the Playwright E2E tests.
- `support/scripts/test-e2e-watch` - A convenience script for running the Playwright E2E tests in watch mode.
- `cd assets && npm run test-e2e` - Navigate to the JS test root directory and run the JS unit tests directly.

### Releases

Releases can be created for either a vanilla/bare metal deployment, or for a Docker-based deployment.

#### Creating a Release

##### First Steps

Before you create a release, ensure that your environment variables are set correctly. You can use `direnv` to easily load your environment when navigating within this project's directories.

Navigate to the project root directory and set up your environment variables:

- You can set custom/private environment variables in `.env` so that they will not be accidentally committed to source control
  - Use the environment generator script to generate a `.env` file in the project root directory. You can modify this `.env` file as needed.
    - To run the script:
      - `support/scripts/dotenv-generate`
      - Or, `just dotenv-generate`

##### Vanilla/Bare Metal Deployment

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `support/scripts/elixir-release-create`
- Make sure that Postgres is running:
  - Use `pg_isready`:
    - e.g. `pg_isready` or `pg_isready -h localhost` or `pg_isready -h your-postgres-ip-address-or-domain`
- Set up the database in Postgres:
  - Spawn a shell as the `postgres` user:
    - `sudo -iu postgres`
  - Open the Postgres terminal:
    - `psql -U postgres`
  - Create a new database user:
    - `CREATE USER your_postgres_user WITH PASSWORD 'your_postgres_password';`
  - Create the database and grant privileges to the new user:
    - `CREATE DATABASE todo_list;`
    - `GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;`
  - TODO: Configure Postgres settings like in a Django project?
    - (e.g. `client_encoding`, `default_transaction_isolation`, `timezone`, etc.)
  - Exit the Postgres prompt:
    - `\q`
- Set up the Phoenix server:
  - Run migrations:
    - `MIX_ENV=prod ./_build/prod/rel/todo_list/bin/migrate`
  - Start the server:
    - `MIX_ENV=prod PHX_SERVER=true ./_build/prod/rel/todo_list/bin/server`

##### Docker/Podman Deployment

NOTE: When using Podman, you may have issues using `podman-compose` to orchestrate containers (e.g. on `aarch64` systems).

- I have found that `docker-compose` works well as a drop-in replacement for `podman-compose`.
  - The only difference is that `docker-compose` must be configured (instructions below) to use the Podman socket instead of the default Docker socket.
- As a bonus, `docker-compose` has a nicer UI (in my opinion) than `podman-compose`, e.g. containers are color-coded so it's easier to read the logs when viewing the compose logs.
- Many instructions in these documentation pages use `podman-compose` for Podman example commands, but you should be able to use `docker-compose` as needed by following the instructions below.

###### Using `docker-compose` With Podman

- Install `docker-compose` v.1.29.2:
  - There are several ways to install this package, but I have found installation via Python's `pip` to be the most versatile, namely because it works well with `x86_64` and `aarch64` systems.
    - Install via [`pipx`](https://pypa.github.io/pipx/) (recommended):
      - `pipx install docker-compose`
    - Install via `pip`:
      - `pip install docker-compose`
- Set the socket path when running `docker-compose` commands:
  - With an environment variable: `DOCKER_HOST="unix:$(podman info --format '{{.Host.RemoteSocket.Path}}')" docker-compose up`
  - Or, with the `-H` flag: `docker-compose -H "unix:$(podman info --format '{{.Host.RemoteSocket.Path}}')" up`

###### Building a Release as a Docker Image

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `support/scripts/elixir-release-create`
  - Or, `just release`
- Build a container image:
  - Docker: `docker build -t phoenix-todo-list .`
  - Podman: `podman build -t phoenix-todo-list .`

To push an image to Docker Hub:

- Ensure that you have built an image using the instructions above.
- Login to your Docker Hub account:
  - Examples:
    - Docker: `docker login`
    - Podman: `podman login docker.io`
  - If you have 2FA enabled, you may need to login using an [Access Token](https://hub.docker.com/settings/security) instead of a password.
    - Docker will notify you when attempting to login with a password, but Podman will fail silently.
- Push the image to Docker Hub:
  - Docker: `docker push arcanemachine/phoenix-todo-list`
  - Podman: `podman push arcanemachine/phoenix-todo-list`

###### Building an `aarch64` Image

To build an `aarch64` (a.k.a `ARM64`/`armv8`/`arm64v8`) image, follow the instructions in the previous section, but do so from an `aarch64` machine. This will produce an `aarch64`-compatible image.

`aarch64` images are tagged with the `aarch64` tag, e.g. `docker.io/arcanemachine/phoenix-todo-list:aarch64`.

When generating a dotenv file, the generator script will detect your CPU architecture (`x86_64` or `aarch64`) so you automatically pull the proper image when using the deployment scripts in `support/scripts/`.

###### Running a Basic Phoenix Container

**Using a Locally-Built Image**

A basic `compose.yaml` file can be found in the project root directory. It exposes a plain Phoenix container.

To run this barebones container, run the following commands from the project root directory:

- First, ensure that you have a Postgres server running locally.
- [Build the Docker image](#building-a-release-as-a-docker-image).
- Run the Compose file:
  - Docker: `docker-compose up`
  - Podman: `podman-compose up`

**Using the Docker Hub Image**

Run the following command from the project root directory:

- Docker: `docker compose -f support/containers/compose.phoenix.yaml up`
- Podman: `podman-compose -f support/containers/compose.phoenix.yaml up`

**Running an `aarch64` Container**

This project supports the creation and use of containers for the `x86_64` and `aarch64` CPU architectures.

- The default container image tag on Docker Hub (`latest`) supports the `x86_64` architecture.
- The `aarch64` image tag for this project on Docker Hub supports the `aarch64` architecture.
  - e.g. `docker.io/arcanemachine/phoenix-todo-list:aarch64`
- To use the `aarch64` container with this project's compose files (located in `support/containers/`), ensure the `IMAGE_TAG` environment variable is set to `aarch64`:
  - Examples:
    - Docker: `IMAGE_TAG=aarch64 docker compose -f support/containers/compose.phoenix.yaml up`
    - Podman: `IMAGE_TAG=aarch64 podman-compose -f support/containers/compose.phoenix.yaml up`
  - NOTE: The generated `.env` file (created by running `just dotenv-generate`) should have the proper CPU architecture for your machine in the `IMAGE_TAG` variable.

###### Other Docker/Podman Deployment Procedures

For other Docker/Podman container procedures, see `/support/containers/README.md`.

### Remote Deployment

#### Fly.io

Before continuing, ensure that [`flyctl`](https://fly.io/docs/hands-on/install-flyctl/) is installed.

To deploy via fly.io, you must use the Dockerfile in the `support/` directory. The Dockerfile in the project root directory is just a symlink, so you can safely delete it and symlink the Fly Dockerfile there instead:

- `rm ./Dockerfile && ln -s support/containers/Dockerfile.fly Dockerfile`

The `fly.io` Dockerfile is essentially the same as the default Dockerfile generated by Phoenix, but has a few additions to make it work with `fly.io`. These additions are created when creating the project with `flyctl`.

- NOTE: The default Dockerfile generated by `flyctl` may have some issues with Tailwind and other NPM dependencies. The modified Dockerfiles used in this project have a few modifications designed to mitigate this.

This project has a `fly.toml` file. To create a new one, run `fly launch` and follow the prompt.

To deploy the project, run `flyctl deploy`.

### Locations of Dependencies

There are several types of dependencies throughout this project that should be kept up to date:

- Elixir:
  - `mix.exs`
  - `config/config.exs`: `esbuild`, `tailwind`
- Javascript (npm):
  - `assets/js/`
- Containers (Docker/Podman):
  - `support/containers/compose.*.yaml`
  - `support/containers/Dockerfile.*`
  - `support/scripts/loadtest-k6`
