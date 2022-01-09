defmodule Erlmastery.Workers.BroadcastLiveDisconnect do
  use Oban.Worker, queue: :broadcast_live_disconnect

  import Ecto.Query, only: [from: 2]

  require Logger

  alias Erlmastery.Repo
  alias Erlmastery.Accounts.User

  @impl Oban.Worker
  def perform(_) do
    Logger.info("Broadcasting live disconnect.")
    query = from u in User, select: u.id
    user_ids = Repo.all(query)

    user_ids
    |> Enum.each(fn user_id ->
      ErlmasteryWeb.Endpoint.broadcast("users_socket:#{user_id}", "disconnect", %{})
    end)

    :ok
  end
end
