defmodule ErlmasteryWeb.Authentication.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :erlmastery,
    error_handler: ErlmasteryWeb.Authentication.ErrorHandler,
    module: ErlmasteryWeb.Authentication

  plug Guardian.Plug.VerifySession, claims: %{"typ" => "access"}

  plug Guardian.Plug.LoadResource, allow_blank: true
end
