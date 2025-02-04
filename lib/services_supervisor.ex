defmodule Servy.ServicesSupervisor do
  use Supervisor

  def start_link(_arg) do
    IO.puts "Starting the services supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      Servy.PledgeServerWithGenServer,
      # Servy.SensorServer
      {Servy.SensorServer, 60} # Call start_link with arguments. Arguments can be anything. The syntax is a tuple as {Module, Argument}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
