defmodule Erlmastery.Accounts do
  alias Erlmastery.Repo
  alias Erlmastery.Accounts.User

  def create_user(attrs) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end
end
