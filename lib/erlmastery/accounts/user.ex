defmodule Erlmastery.Accounts.User do
  use Erlmastery.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email])
    |> validate_required([:email])
  end
end
