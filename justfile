set dotenv-load

@_default:
  # list all the commands in this justfile
  just --list


# VARIABLES #
container_image_name := "arcanemachine/phoenix-todo-list"

# colors
color_info := "\\033[96m"
color_reset := "\\033[39m"


# ALIASES #
# start a dev server
@start: server-dev-start


# COMMANDS #
# remove stale versions of static assets
@assets-prune:
  echo "Pruning digested assets..."
  mix phx.digest.clean --all

# copy caddyfile, then validate and reload caddy [format: local | remote]
@caddyfile-copy-validate-reload environment='':
  echo "Copying the Caddyfile, then validating and reloading Caddy..."
  ./support/scripts/caddyfile-copy-validate-reload {{ environment }}

# create the database with 'mix' and run initial migrations
@db-setup:
  echo "Setting up the database..."
  mix ecto.setup

# create the database with 'mix'
@db-create:
  echo "Creating the database..."
  mix ecto.create

# run database migrations with 'mix'
@db-migrate:
  echo "Running database migrations..."
  mix ecto.migrate

# drop the database with 'mix'
@db-drop:
  echo "Dropping the database..."
  mix ecto.drop

# reset the database with 'mix'
@db-reset:
  echo "Resetting the database..."
  mix ecto.reset

# build a docker release
@docker-image-build:
  echo "Building a Docker release image..."
  docker build -t {{ container_image_name }} .

# generate environment file (default is '.env', pass '--envrc' for '.envrc')
@dotenv-generate args='':
  echo "Generating new environment file..."
  ./support/scripts/dotenv-generate {{ args }}

# view the output of the environment file generator
@dotenv-generate--template args='':
  ./support/scripts/dotenv-generate--template

# generate an OpenAPI schema [format: json | yaml]
@openapi-schema-generate format='json':
  echo "Generating '{{ format }}' schema..."
  mix openapi.spec.{{ format }} --spec TodoListWeb.ApiSpec

# run pre-commit hooks (requires pre-commit.com)
@pre-commit:
  echo "Running pre-commit hooks..."
  pre-commit run --all-files

# create a release
@release-create:
  echo "Creating a release..."
  ./support/scripts/release-create

# start a dev server
@server-dev-start:
  echo "Starting a dev server..."
  iex -S mix phx.server

# run migrations on the prod server
@server-prod-migrate:
  echo "Running migrations on the prod server..."
  # ./_build/prod/rel/todo_list/bin/todo_list eval TodoList.Release.migrate
  ./_build/prod/rel/todo_list/bin/migrate

# run migrations and start the prod server
@server-prod-migrate-start:
  echo "Running and starting the prod server..."
  ./support/scripts/server-prod-migrate-start

# start the prod server
@server-prod-start:
  echo "Starting prod server..."
  ./_build/prod/rel/todo_list/bin/server

# stop the prod server
@server-prod-stop:
  echo "Stopping prod server..."
  ./_build/prod/rel/todo_list/bin/todo_list stop

# spawn an IEx shell
@shell:
  echo "Spawning IEx shell..."
  if [ "${MIX_ENV:-''}" != "test" ]; then echo "{{ color_info }}\
    NOTE: If 'recompile()' is not working properly, set MIX_ENV=test and try again.\
  {{ color_reset }}"; fi
  iex -S mix phx.server

# run all tests
@test-all: test-elixir test-js-unit test-e2e

# run end-to-end (E2E) tests
@test-e2e args='':
  echo "Running E2E tests..."
  ./support/scripts/test-e2e {{ args }}

# run end-to-end (E2E) tests in watch mode
@test-e2e-watch args='':
  echo "Running E2E tests in watch mode..."
  ./support/scripts/test-e2e-watch {{ args }}

# run Elixir tests
@test-elixir:
  echo "Running Elixir tests in watch mode..."
  ./support/scripts/test-elixir

# run Elixir tests in watch mode
@test-elixir-watch:
  echo "Running Elixir tests in watch mode..."
  ./support/scripts/test-elixir-watch

# run Javascript unit tests
@test-js-unit:
  echo "Running Javascript unit tests..."
  cd test/js/ && npm run unit

# run Javascript unit tests in watch mode
@test-js-unit-watch:
  echo "Running Javascript unit tests in watch mode..."
  cd test/js/ && npm run unit-watch
