defmodule WindowGame.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      WindowGameWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:window_game, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: WindowGame.PubSub},
      # Start a worker by calling: WindowGame.Worker.start_link(arg)
      # {WindowGame.Worker, arg},
      # Start to serve requests, typically the last entry
      WindowGameWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: WindowGame.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    WindowGameWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
