defmodule ErlmasteryWeb.Live.Chat.ShowChatRoom do
  use ErlmasteryWeb, :live_view

  import Erlmastery.Chat
  alias Erlmastery.Chat.User
  alias Erlmastery.Chat.Presence
  alias Erlmastery.Chat.ChatMessage
  alias Phoenix.Socket.Broadcast

  @impl true
  def render(assigns) do
    ~L"""
    <h1><%= @chat_room.name %></h1>
    <h3>Users in this chat room:</h3>
    <ul>
      <%= for uuid <- @users do %>
        <%= if uuid == @user.uuid do %>
          <li><%= uuid %> <- You</li>
        <% else %>
          <li><%= uuid %></li>
        <% end %>
      <% end %>
    </ul>
    <%= if length(@messages) > 0 do %>
      <h4>Messages:</h4>
    <% end %>
    <ul>
      <%= for message <- @messages do %>
        <li>
          <%= message.content %> - <%= message.user %>
        </li>
      <% end %>
    </ul>
    <div class="form-group">
      <%= form_for @message, "#", [phx_submit: "message"], fn f -> %>
      <%= text_input f, :content, value: @message.changes[:content], placeholder: "write your message here..." %>
      <%= hidden_input f, :user, value: @user.uuid %>
      <%= submit "submit" %>
      <% end %>
    </div>
    """
  end

  defp create_user() do
    %User{uuid: Ecto.UUID.generate()}
  end

  @impl true
  def mount(%{"name" => name}, _session, socket) do
    user = create_user()
    chat_room_presence = chat_room_presence_name(name)
    chat_message_presence = chat_messages_presence_name(name)
    Phoenix.PubSub.subscribe(Erlmastery.PubSub, chat_room_presence)
    Phoenix.PubSub.subscribe(Erlmastery.PubSub, chat_message_presence)
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
         |> assign(:users, [])
         |> assign(:messages, [])
         |> assign(:message, ChatMessage.changeset(%ChatMessage{}, %{}))}
    end
  end

  @impl true
  def handle_info(%Broadcast{event: "presence_diff"}, socket) do
    chat_room_presence = chat_room_presence_name(socket.assigns.chat_name)
    users = Presence.list(chat_room_presence) |> Enum.map(fn {key, _} -> key end)
    {:noreply, socket |> assign(:users, users)}
  end

  def handle_info(%{"content" => content, "user" => user}, socket) do
    messages = socket.assigns.messages

    {:noreply,
     socket
     |> assign(:messages, messages ++ [%{content: content, user: user}])}
  end

  @impl true
  def handle_event("message", %{"chat_message" => message}, socket) do
    messages = socket.assigns.messages
    %{"content" => content, "user" => user} = message
    chat_message_presence = chat_messages_presence_name(socket.assigns.chat_name)
    Phoenix.PubSub.broadcast_from(Erlmastery.PubSub, self(), chat_message_presence, message)

    {:noreply,
     socket
     |> assign(:messages, messages ++ [%{content: content, user: user}])}
  end

  defp chat_room_presence_name(name), do: "chat_room:#{name}"

  defp chat_messages_presence_name(name), do: "chat_room:#{name}:messages"
end
