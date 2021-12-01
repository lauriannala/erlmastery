defmodule Erlmastery.Chat.Presence do
  use Phoenix.Presence,
    otp_app: :erlmastery,
    pubsub_server: Erlmastery.PubSub
end
