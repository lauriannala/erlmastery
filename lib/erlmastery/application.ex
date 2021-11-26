defmodule Erlmastery.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Erlmastery.Repo,
      # Start the Telemetry supervisor
      ErlmasteryWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Erlmastery.PubSub},
      # Start the Endpoint (http/https)
      ErlmasteryWeb.Endpoint
      # Start a worker by calling: Erlmastery.Worker.start_link(arg)
      # {Erlmastery.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
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
end
