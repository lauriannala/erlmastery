defmodule ErlmasteryWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :erlmastery

  @env Application.fetch_env!(:erlmastery, :environment)

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_erlmastery_key",
    signing_salt: "4zOEeYpb"
  ]

  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :erlmastery,
    gzip: false,
    only: ~w(assets fonts images well-known favicon.ico robots.txt)

  # security.txt and public key.
  plug Plug.Static,
    at: "/.well-known",
    from: {:erlmastery, "priv/static/well-known"},
    gzip: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
    plug Phoenix.LiveReloader
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :erlmastery
  end

  plug Phoenix.LiveDashboard.RequestLogger,
    param_key: "request_logger",
    cookie_key: "request_logger"

  if @env == :prod do
    username = Application.fetch_env!(:erlmastery, :telemetry_poller_username)
    password = Application.fetch_env!(:erlmastery, :telemetry_poller_password)

    plug Unplug,
      if: {Erlmastery.UnplugPredicates.BasicAuth, username: username, password: password},
      do: {PromEx.Plug, prom_ex_module: Erlmastery.PromEx}
  else
    plug PromEx.Plug, prom_ex_module: Erlmastery.PromEx
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug ErlmasteryWeb.Router
end

defmodule Erlmastery.UnplugPredicates.BasicAuth do
  @behaviour Unplug.Predicate

  @impl true
  def call(%Plug.Conn{} = conn, username: expected_username, password: expected_password) do
    case Plug.BasicAuth.parse_basic_auth(conn) do
      {actual_username, actual_password} ->
        expected_username == actual_username and expected_password == actual_password

      _ ->
        false
    end
  end
end
