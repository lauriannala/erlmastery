defmodule Erlmastery.Accounts do
  alias Erlmastery.Repo
  alias Erlmastery.Accounts.User

  require Logger

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def find(%Ueberauth.Auth{info: %Ueberauth.Auth.Info{email: email}}) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, "User: #{email} not found."}

      user ->
        Logger.info("Successfully authenticated user: #{user.email}")
        {:ok, user}
    end
  end
end
