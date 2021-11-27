defmodule ErlmasteryWeb.Live.Chat.ShowChatRoom do
  use ErlmasteryWeb, :live_view

  import Erlmastery.Chat

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @chat_room.name %></h1>
    """
  end

  @impl true
  def mount(%{"name" => name}, _session, socket) do
    case get_chat_room(name) do
      {:error, _} ->
        socket
        |> put_flash(:error, "Chat room does not exist.")
        |> push_redirect(to: Routes.chat_room_chat_new_chat_room_path(socket, :new))

      {:ok, chat_room} ->
        {:ok, socket |> assign(:chat_room, chat_room)}
    end
  end
end
