set dotenv-load

# begin NOTES #
# - Prepend a statement with '!' to ignore errors in a line's exit code
# end NOTES #

@_default:
  # list all the commands in this justfile
  just --list


# VARIABLES #
container_image_name := "arcanemachine/phoenix-todo-list"

# colors
color_error := "\\033[91m"
color_info := "\\033[96m"
color_reset := "\\033[39m"


# ALIASES #
# build a release
@build: elixir-release-create
# start a dev server
@start: server-dev-start


# COMMANDS #
# remove stale versions of static assets
@assets-prune:
  echo "Pruning digested assets..."
  mix phx.digest.clean --all

# copy caddyfile, then validate and reload caddy [environment: local | remote]
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

# fetch Elixir dependencies
@elixir-fetch-dependencies:
  echo "Fetching Elixir dependencies..."
  mix deps.get

# get info about an Elixir Hex package
@elixir-package-info package='':
  if [ "{{ package }}" = "" ]; then \
    echo "{{ color_error }}You must specify an Elixir package. Aborting...{{ color_reset }}" && \
    exit 1; \
  fi
  echo "Checking for info about the '{{ package }}' Hex package..."
  ! mix hex.info {{ package }}

# check for Elixir Hex package updates
@elixir-package-update-list:
  echo "Listing Elixir package updates..."
  ! mix hex.outdated

# update a specific Elixir Hex package
@elixir-package-update package='':
  if [ "{{ package }}" = "" ]; then \
    echo "{{ color_error }}You must specify the Elixir Hex package to update. Aborting...{{ color_reset }}" && \
    exit 1; \
  fi
  echo "Updating Elixir Hex package '{{ package }}'..."
  mix deps.update {{ package }}

# update all Elixir dependencies
@elixir-package-update-all:
  echo "Updating all Elixir dependencies..."
  mix deps.update --all

# build a podman image
@docker-image-build image_name='arcanemachine/phoenix-todo-list':
  echo "Building a Docker release image '{{ image_name }}'..."
  docker build -t {{ image_name }} .

# generate environment file (default is '.env', pass '--envrc' for '.envrc')
@dotenv-generate args='':
  echo "Generating new environment file..."
  ./support/scripts/dotenv-generate {{ args }}

# generate an OpenAPI schema [format: json | yaml]
@openapi-schema-generate format='json':
  echo "Generating '{{ format }}' schema..."
  mix openapi.spec.{{ format }} --spec TodoListWeb.ApiSpec

# build a podman image
@podman-image-build image_name='arcanemachine/phoenix-todo-list':
  echo "Building a Podman image: '{{ image_name }}'..."
  podman build -t {{ image_name }} .

# run pre-commit hooks (requires pre-commit.com)
@pre-commit:
  echo "Running pre-commit hooks..."
  pre-commit run --all-files

# create a release
@elixir-release-create:
  echo "Creating a release..."
  ./support/scripts/elixir-release-create

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
