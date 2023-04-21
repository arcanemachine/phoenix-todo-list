import Config

# Only in tests, remove the complexity from the password hashing algorithm
config :bcrypt_elixir, :log_rounds, 1

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :todo_list, TodoList.Repo,
  database: Path.expand("../priv/db_test.sqlite3", Path.dirname(__ENV__.file)),
  pool_size: 1,
  pool: Ecto.Adapters.SQL.Sandbox

host = System.get_env("PHX_HOST") || "localhost"
port = String.to_integer(System.get_env("PORT") || "4000") + 2

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :todo_list, TodoListWeb.Endpoint,
  http: [ip: {0, 0, 0, 0}, port: port],
  check_origin: ["http://#{host}:#{port}"],
  secret_key_base: "Ygp6edO5FTklaUFXjkSnuF7y8alcXyb/cU/J1BZH34cvOANEO/U+37Q7hpGR+3ff",
  server: true

# In test we don't send emails.
config :todo_list, TodoList.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# enable sandbox for concurrent E2E tests
config :todo_list, sql_sandbox: true

# HACK: enable dummy forms for testing live views
config :todo_list, hack_test_lv_dummy_forms_enabled: true
