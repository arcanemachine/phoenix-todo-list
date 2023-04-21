# phoenix-todo-list

Yet another todo list. Made using the Phoenix web framework.

Features:

- Basic CRUD
- LiveView CRUD
- REST API
- OpenAPI spec
- E2E tests (Playwright)
- GitHub Actions CI
- Releases (via Docker + fly.io)

## Releases

Releases can be created for either a vanilla/bare metal deployment, or for a Docker-based deployment.

### Creating a Release

#### First Steps

Before you create a release, ensure that your environment variables are set correctly. You can use `direnv` to easily load your environment when navigating within this project's directories.

Navigate to the project root directory and set up your environment variables:

- You can set custom/private environment variables in `./.env.override` so that they will not be accidentally committed to source control
  - Copy the example template in `support/.env.override.example` to `./.env.override` and fill in your desired values.
  - If you do not want to leave plaintext secrets on the filesystem, the example template is still useful as a reference as to which environment variables you will need to start and run the server.

#### Vanilla/Bare Metal Deployment

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `./support/scripts/release-create`
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

#### Docker Deployment

Run the following commands from the project root directory:

- Create a release using the helper script:
  - `./support/scripts/release-create`
- Build a Docker image:
  - `docker build -t arcanemachine/phoenix-todo-list .`
- Run the Docker image with Docker Compose or just plain Docker:
  - `docker-compose up`, or
  - `docker run --name phoenix-todo-list --network='host' --env-file=.env.override -e SECRET_KEY_BASE=$SECRET_KEY_BASE -e DATABASE_URL=$DATABASE_URL arcanemachine/phoenix-todo-list`
