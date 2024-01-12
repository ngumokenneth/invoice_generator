defmodule InvoiceGenerator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      InvoiceGeneratorWeb.Telemetry,
      # Start the Ecto repository
      InvoiceGenerator.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: InvoiceGenerator.PubSub},
      # Start Finch
      {Finch, name: InvoiceGenerator.Finch},
      # Start the Endpoint (http/https)
      InvoiceGeneratorWeb.Endpoint
      # Start a worker by calling: InvoiceGenerator.Worker.start_link(arg)
      # {InvoiceGenerator.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: InvoiceGenerator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvoiceGeneratorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
