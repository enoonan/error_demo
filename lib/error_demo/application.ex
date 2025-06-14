defmodule ErrorDemo.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [ErrorDemo.Repo]

    opts = [strategy: :one_for_one, name: ErrorDemo.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
