defmodule Erlmastery.Chat do
  alias Erlmastery.Repo
  alias Erlmastery.Chat.ChatRoom

  def get_chat_room(name) do
    case Repo.get_by(ChatRoom, name: name) do
      nil -> {:error, "Not found by name: #{name}"}
      chat_room -> {:ok, chat_room}
    end
  end

  def create_chat_room(name) do
    %ChatRoom{}
    |> ChatRoom.changeset(%{name: name})
    |> Repo.insert()
  end
end
