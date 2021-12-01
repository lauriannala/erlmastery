defmodule ErlmasteryWeb.Live.Chat.ShowChatRoom do
  use ErlmasteryWeb, :live_view

  import Erlmastery.Chat
  alias Erlmastery.Chat.User
  alias Erlmastery.Chat.Presence
  alias Phoenix.Socket.Broadcast

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @chat_room.name %></h1>
    <h3>Users in this chat room:</h3>
    <ul>
      <%= for uuid <- @users do %>
        <li><%= uuid %></li>
      <% end %>
    </ul>
    """
  end

  defp create_user() do
    %User{uuid: Ecto.UUID.generate()}
  end

  @impl true
  def mount(%{"name" => name}, _session, socket) do
    user = create_user()
    chat_room_presence = chat_room_presence_name(name)
    Phoenix.PubSub.subscribe(Erlmastery.PubSub, chat_room_presence)
    {:ok, _} = Presence.track(self(), chat_room_presence, user.uuid, %{})

    case get_chat_room(name) do
      {:error, _} ->
        socket
        |> put_flash(:error, "Chat room does not exist.")
        |> push_redirect(to: Routes.chat_room_chat_new_chat_room_path(socket, :new))

      {:ok, chat_room} ->
        {:ok,
         socket
         |> assign(:chat_room, chat_room)
         |> assign(:user, user)
         |> assign(:chat_name, name)
         |> assign(:users, [])}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    chat_room_presence = chat_room_presence_name(socket.assigns.chat_name)
    users = Presence.list(chat_room_presence) |> Enum.map(fn {key, _} -> key end)
    {:noreply, socket |> assign(:users, users)}
  end

  defp chat_room_presence_name(name), do: "chat_room:#{name}"
end
