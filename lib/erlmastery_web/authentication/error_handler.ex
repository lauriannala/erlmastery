defmodule ErlmasteryWeb.Authentication.ErrorHandler do
  use ErlmasteryWeb, :controller

  require Logger

  @behaviour Guardian.Plug.ErrorHandler

  @impl Guardian.Plug.ErrorHandler
  def auth_error(conn, {type, reason}, _opts) do
    Logger.warn(
      "auth error, type: #{inspect(type)}, reason: #{inspect(reason)}, redirecting to identity provider."
    )

    conn
    |> redirect(to: Routes.auth_path(conn, :request, :discord))
  end
end
