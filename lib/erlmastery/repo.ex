defmodule Erlmastery.Repo do
  use Ecto.Repo,
    otp_app: :erlmastery,
    adapter: Ecto.Adapters.Postgres
end
