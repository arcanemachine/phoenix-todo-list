set dotenv-load

# colors
color_info := "\\033[96m"
color_reset := "\\033[39m"

# list available just commands
@default:
  just --list

# aliases
@start: server-dev-start


# remove stale versions of static assets
@assets-prune:
  echo "Pruning digested assets..."
  mix phx.digest.clean --all

# create the database with 'mix' and run initial migrations
@db-setup:
  mix ecto.setup

# create the database with 'mix'
@db-create:
  mix ecto.create

# run database migrations with 'mix'
@db-migrate:
  mix ecto.migrate

# drop the database with 'mix'
@db-drop:
  mix ecto.drop

# reset the database with 'mix'
@db-reset:
  mix ecto.drop

# generate a .env file
@dotenv-generate args='':
  ./support/scripts/dotenv-generate {{ args }}

# view the output of the .env file generator
@dotenv-generate-template:
  ./support/scripts/dotenv-generate-template

# generate an OpenAPI schema (format: 'json' | 'yaml')
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
@test-all: test-elixir test-e2e

# run end-to-end (E2E) tests
@test-e2e args='':
  ./support/scripts/test-e2e {{ args }}

# run end-to-end (E2E) tests in watch mode
@test-e2e-watch args='':
  ./support/scripts/test-e2e-watch {{ args }}

# run Elixir tests
@test-elixir:
  ./support/scripts/test-elixir

# run Elixir tests in watch mode
@test-elixir-watch:
  ./support/scripts/test-elixir-watch

# run Javascript unit tests
@test-js-unit:
  cd test/js/ && npm run unit

# run Javascript unit tests in watch mode
@test-js-unit-watch:
  cd test/js/ && npm run unit-watch
