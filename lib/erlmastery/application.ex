defmodule Erlmastery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Erlmastery.PromEx,
      Erlmastery.Repo,
      ErlmasteryWeb.Telemetry,
      {Phoenix.PubSub, name: Erlmastery.PubSub},
      Erlmastery.Chat.Presence,
      ErlmasteryWeb.Endpoint,
      {Oban, oban_config()}
    ]

    opts = [strategy: :one_for_one, name: Erlmastery.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ErlmasteryWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:erlmastery, Oban)
  end
end
