# phoenix-todo-list

[View Live Demo](https://arcanemachine-phoenix-todo.fly.dev/)

---

**All commands in this document should be performed from the project root directory.**

NOTE: This project uses Git submodules. There are a couple caveats to keep in mind when working with submodules:

- To clone this repo:
  - `git clone --recurse-submodules https://github.com/arcanemachine/phoenix-todo-list`
- If you have already cloned the repo, but didn't clone the submodules using the command above:
  - Run `git submodule update --init`.
- To update the submodule(s) to the latest commit/revision, perform either of these steps:
  - Run `git submodule foreach git pull`.
  - Navigate to the submodule (`support/containers/traefik`) and run `git pull`.

---

Yet another todo list. Made using the Phoenix web framework.

Features:

- Basic CRUD
- LiveView CRUD
- REST API
- OpenAPI spec
- Javascript-based unit tests (Vitest)
- Javascript-based E2E tests (Playwright)
- GitHub Actions CI
- Releases (vanilla/Docker/fly.io)
- Supports a variety of container-based environments
- EditorConfig (standardizes file formatting: spaces per line, etc.)
- Enforces sane commit messages with [`git-conventional-commits`](https://github.com/qoomon/git-conventional-commits)
- Uses [`just`](https://github.com/casey/just) task runner

## Getting Started

### Working in a `dev` Environment

Before you work in a `dev` environment, ensure that your environment variables are set correctly.

It is recommended to use `direnv` to easily load your environment when navigating within this project's directories.

- You can set custom/private environment variables in `.env` so that they will not be accidentally committed to source control
  - Copy the example template in `support/.env.example` to `.env` and fill in your desired values.
- Run `mix deps.get` to fetch the dependencies
- Setup PostgreSQL:
  - For easy PostgreSQL setup, you can use my [`container-postgres`](https://github.com/arcanemachine/container-postgres) repo for a Dockerized version that can be easily removed when you no longer need it.
- Once the PostgreSQL server is running, set up the `dev` environment:
  - `mix ecto.setup`
- Use any of these commands to start a dev server:
  - `just start` - Uses the `just` task runner to start a dev server
  - `mix phx.server` - The vanilla-Elixir method of starting a dev server
  - `iex -S mix phx.server` - Starts a dev server in an `IEx` session. Useful for debugging.
  - `support/scripts/start` - A convenience script for starting a dev server in an `IEx` shell.

### Testing

Before running any tests, use the instructions above to ensure that:

- The required environment variables have been set.
- A PostgreSQL server is up and running.
  - You may need to create a test database:
    - `MIX_ENV=test mix ecto.create`

#### Elixir-Based Tests (`mix test`)

Run the Elixir-based tests using any of these commands:

- `mix test` - The regular method of running the tests.
- `support/scripts/test-elixir` - A convenience script for running the Elixir tests.
  - This script clears the test database before running the tests. This prevents any issues that may be caused when the test database is not cleared, e.g. during failed E2E test run.
- `support/scripts/test-elixir-watch` - A convenience script for running the Elixir-based tests in watch mode.

#### Javascript-Based Tests

Before running any Javascript-based tests:

- Ensure that `npm` is installed and working on your system.
- Navigate to the `test/js/` directory and run `npm install`

Then, navigate back to the project root directory for instructions on how to run the Javascript-based tests.

##### JS Unit Tests (Vitest)

Run the Javascript-based unit tests using any of these commands:

- `support/scripts/test-unit` - A convenience script for running the Vitest unit tests.
- `support/scripts/test-unit-watch` - A convenience script for running the Vitest unit tests in watch mode.
- `cd test/js/ && npx playwright test` - Navigate to the JS test root directory and run the JS E2E tests directly.

##### JS End-To-End Tests (Playwright)

Run the Javascript-based end-to-end (E2E) Playwright tests using any of these commands:

- `support/scripts/test-e2e` - A convenience script for running the Playwright E2E tests.
- `support/scripts/test-e2e-watch` - A convenience script for running the Playwright E2E tests in watch mode.
- `cd test/js/ && npm run unit` - Navigate to the JS test root directory and run the JS unit tests directly.

### Releases

Releases can be created for either a vanilla/bare metal deployment, or for a Docker-based deployment.

#### Creating a Release

##### First Steps

Before you create a release, ensure that your environment variables are set correctly. You can use `direnv` to easily load your environment when navigating within this project's directories.

Navigate to the project root directory and set up your environment variables:

- You can set custom/private environment variables in `.env` so that they will not be accidentally committed to source control
  - Use the environment generator script (`just dotenv-generate` or `support/scripts/dotenv-generate`) to generate an example `.env` file in the project root directory. You can modify this `.env` file as needed.

##### Vanilla/Bare Metal Deployment

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `support/scripts/release-create`
- Make sure that PostgreSQL is running.
  - e.g. `pg_isready` or `pg_isready -h localhost` or `pg_isready -h your-postgres-ip-address-or-domain`
- Set up the database in PostgreSQL:
  - Spawn a shell as the `postgres` user:
    - `sudo -iu postgres`
  - Open the PostgreSQL terminal:
    - `psql -U postgres`
  - Create a new database user:
    - `CREATE USER your_postgres_user WITH PASSWORD 'your_postgres_password';`
  - Create the database and grant privileges to the new user:
    - `CREATE DATABASE todo_list;`
    - `GRANT ALL PRIVILEGES ON DATABASE myproject TO myprojectuser;`
  - TODO: Configure PostgreSQL settings like in a Django project?
    - (e.g. `client_encoding`, `default_transaction_isolation`, `timezone`, etc.)
  - Exit the PostgreSQL prompt:
    - `\q`
  - Run migrations:
    - `MIX_ENV=prod ./_build/prod/rel/todo_list/bin/migrate`
  - Start the server:
    - `MIX_ENV=prod PHX_SERVER=true ./_build/prod/rel/todo_list/bin/server`

##### Docker/Podman Deployment

###### Building a Release as a Docker Container

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `support/scripts/release-create`
- Build a Docker/Podman image:
  - Docker: `docker build -t phoenix-todo-list .`
  - Podman: `podman build -t phoenix-todo-list .`

###### Running a Basic Phoenix Container

**Using a Locally-Built Image**

A basic `compose.yaml` file can be found in the project root directory. It exposes a plain Phoenix container.

To run this barebones container, run the following commands from the project root directory:

- First, ensure that you have a PostgreSQL server running locally.
- [Build the Docker image](#building-a-release-as-a-docker-container).
- Run the Compose file:
  - Docker: `docker-compose up`
  - Podman: `podman-compose up`

**Using the Docker Hub Image**

Run the following command from the project root directory:

- Docker: `docker compose -f support/containers/compose.phoenix.yaml up`
- Podman: `podman-compose -f support/containers/compose.phoenix.yaml up`

###### Other Docker/Podman Deployment Procedures

For other Docker/Podman container procedures, see `/support/containers/README.md`.

### Remote Deployment

#### Fly.io

Before continuing, ensure that [`flyctl`](https://fly.io/docs/hands-on/install-flyctl/) is installed.

To deploy via fly.io, you must use the Dockerfile in the `support/` directory. The Dockerfile in the project root directory is just a symlink, so you can safely delete it and symlink the Fly Dockerfile there instead:

- `rm ./Dockerfile && ln -s support/Dockerfile.fly Dockerfile`

This project has a `fly.toml` file. To create a new one, run `fly launch` and follow the prompt.

To deploy the project, run `flyctl deploy`.
