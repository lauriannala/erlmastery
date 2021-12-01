defmodule Erlmastery.Chat.ChatMessage do
  use Ecto.Schema

  import Ecto.Changeset

  embedded_schema do
    field :content, :string
    field :user, :string
  end

  def changeset(chat_message, attrs) do
    chat_message
    |> cast(attrs, [:content, :user])
    |> validate_required([:content, :user])
  end
end
