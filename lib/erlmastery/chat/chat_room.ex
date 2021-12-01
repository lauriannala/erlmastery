defmodule Erlmastery.Chat.ChatRoom do
  use Erlmastery.Schema

  import Ecto.Changeset

  schema "chat_rooms" do
    field :name, :string

    timestamps()
  end

  def changeset(chat_room, attrs) do
    chat_room
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
