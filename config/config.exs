# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :todo_list,
  ecto_repos: [TodoList.Repo]

# Configures the endpoint
config :todo_list, TodoListWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [html: TodoListWeb.ErrorHTML, json: TodoListWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: TodoList.PubSub,
  live_view: [signing_salt: "fhzPBZom"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
# config :todo_list, TodoList.Mailer, adapter: Swoosh.Adapters.Local
config :todo_list, TodoList.Mailer,
  adapter: Swoosh.Adapters.AmazonSES,
  region: System.get_env("AWS_REGION"),
  access_key: System.get_env("AWS_ACCESS_KEY"),
  secret: System.get_env("AWS_SECRET")

config(:swoosh, api_client: Swoosh.ApiClient.Finch, finch_name: TodoList.Finch)

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.41",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ],
  extra: [
    args:
      ~w(js/init.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.2.4",
  default: [
    args: ~w(
      --config=tailwind.config.cjs
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
