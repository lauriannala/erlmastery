# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :erlmastery,
  ecto_repos: [Erlmastery.Repo]

# Configures the endpoint
config :erlmastery, ErlmasteryWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ErlmasteryWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Erlmastery.PubSub,
  live_view: [signing_salt: "gCGgGpDF5ey1N4wpsF0IrgPzLAXCwYRQGRVgLI+VDhQFxZlw5+oQ3R92zewPTIp2"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :erlmastery, Erlmastery.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    discord: {Ueberauth.Strategy.Discord, [default_scope: "identify email"]}
  ]

config :erlmastery, ErlmasteryWeb.Authentication, issuer: "erlmastery"

config :phoenix, :template_engines, md: PhoenixMarkdown.Engine

config :erlmastery, Erlmastery.PromEx,
  disabled: false,
  manual_metrics_start_delay: :no_delay,
  drop_metrics_groups: [],
  grafana: :disabled,
  metrics_server: :disabled

config :erlmastery, :environment, config_env()
config :erlmastery, :telemetry_poller_username, "username"
config :erlmastery, :telemetry_poller_password, "password"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
