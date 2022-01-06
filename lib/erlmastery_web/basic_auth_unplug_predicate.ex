defmodule Erlmastery.BasicAuthUnplugPredicate do
  @behaviour Unplug.Predicate
  defp username(), do: Application.fetch_env!(:erlmastery, :telemetry_poller_username)
  defp password(), do: Application.fetch_env!(:erlmastery, :telemetry_poller_password)

  require Logger

  @impl true
  def call(%Plug.Conn{} = conn, _) do
    case Plug.BasicAuth.parse_basic_auth(conn) do
      {actual_username, actual_password} ->
        success = username() == actual_username and password() == actual_password

        if username() != actual_username,
          do: Logger.error("Metrics poller username does not match")

        if password() != actual_password,
          do: Logger.error("Metrics poller password does not match")

        success

      _ ->
        false
    end
  end
end
