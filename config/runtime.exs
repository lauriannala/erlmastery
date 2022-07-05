import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.
if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :erlmastery, Erlmastery.Repo,
    ssl: true,
    # socket_options: [:inet6],
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :erlmastery, ErlmasteryWeb.Endpoint,
    http: [
      # Enable IPv6 and bind on all interfaces.
      # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
      # See the documentation on https://hexdocs.pm/plug_cowboy/Plug.Cowboy.html
      # for details about using IPv6 vs IPv4 and loopback vs public addresses.
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ],
    secret_key_base: secret_key_base,
    url: [host: System.fetch_env!("HOST_URL")],
    live_view: [signing_salt: System.fetch_env!("LIVE_VIEW_SALT")]

  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :erlmastery, ErlmasteryWeb.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :erlmastery, Erlmastery.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.
  config :ueberauth, Ueberauth.Strategy.Discord.OAuth,
    client_id: System.fetch_env!("DISCORD_CLIENT_ID"),
    client_secret: System.fetch_env!("DISCORD_CLIENT_SECRET")

  config :erlmastery, ErlmasteryWeb.Authentication,
    secret_key: System.fetch_env!("GUARDIAN_SECRET_KEY")

  config :erlmastery, :telemetry_poller_username, System.fetch_env!("TELEMETRY_POLLER_USERNAME")
  config :erlmastery, :telemetry_poller_password, System.fetch_env!("TELEMETRY_POLLER_PASSWORD")

  config :erlmastery, Erlmastery.PromEx,
    grafana: [
      host: System.fetch_env!("GRAFANA_HOST"),
      auth_token: System.fetch_env!("GRAFANA_AUTH_TOKEN"),
      # This is an optional setting and will default to `true`
      upload_dashboards_on_start: true
    ]

  config :logger,
    backends: [:console, LokiLogger]

  config :logger, :loki_logger,
    level: :info,
    format: "$metadata level=$level $levelpad$message",
    metadata: :all,
    max_buffer: 1,
    loki_labels: %{application: "erlmastery_prod", elixir_node: "node"},
    loki_host: System.fetch_env!("LOKI_HOST"),
    basic_auth_user: System.fetch_env!("LOKI_USER"),
    basic_auth_password: System.fetch_env!("LOKI_PASSWORD")
end
