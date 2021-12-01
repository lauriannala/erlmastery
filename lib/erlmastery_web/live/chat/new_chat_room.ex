defmodule ErlmasteryWeb.Live.Chat.NewChatRoom do
  use ErlmasteryWeb, :live_view

  alias Erlmastery.Chat.ChatRoom
  import Erlmastery.Chat

  @impl true
  def render(assigns) do
    ~L"""
    <div>
      <%= form_for @changeset, "#", [phx_change: "validate", phx_submit: "save"], fn _ -> %>
      <%= submit "Create a new chatroom" %>
      <% end %>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    socket_with_changeset =
      socket
      |> assign(:changeset, ChatRoom.changeset(%ChatRoom{}, %{}))

    {:ok, socket_with_changeset}
  end

  @impl true
  def handle_event("save", _params, socket) do
    name = :crypto.strong_rand_bytes(8) |> Base.encode64() |> binary_part(0, 8)

    case create_chat_room(name) do
      {:ok, chat_room} ->
        {:noreply,
         socket
         |> push_redirect(
           to: Routes.chat_room_chat_show_chat_room_path(socket, :show, chat_room.name)
         )}

      {:error, _} ->
        socket
        |> put_flash(:error, "Could not save chat room.")
    end
  end
end
