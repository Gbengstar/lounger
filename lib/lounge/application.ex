defmodule Lounge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LoungeWeb.Telemetry,
      Lounge.Repo,
      {DNSCluster, query: Application.get_env(:lounge, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Lounge.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Lounge.Finch},
      # Start a worker by calling: Lounge.Worker.start_link(arg)
      # {Lounge.Worker, arg},
      # Start to serve requests, typically the last entry
      LoungeWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lounge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LoungeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
