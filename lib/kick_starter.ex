defmodule Servy.KickStarter do
  use GenServer

  # Without Supervisor
  # def start do
  #   IO.puts "Starting the kick starter..."
  #   GenServer.start(__MODULE__, :ok, name: __MODULE__)
  # end

  # With Supervisor
  def start_link(_arg) do
    IO.puts "Starting the kick starter..."
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  # Exit all processes on exit only one
  # def init(:ok) do
  #   IO.puts "Starting the HTTP server..."
  #   server_pid = spawn(Servy.HttpServer, :start, [4000])
  #   Process.link(server_pid)
  #   Process.register(server_pid, :http_server)
  #   {:ok, server_pid}
  # end

  # # Don't Exit all processes on exit only one. Trap exit. Handle info not yet handled
  # def init(:ok) do
  #   Process.flag(:trap_exit, true)
  #   IO.puts "Starting the HTTP server..."
  #   server_pid = spawn(Servy.HttpServer, :start, [4000])
  #   Process.link(server_pid)
  #   Process.register(server_pid, :http_server)
  #   {:ok, server_pid}
  # end

  # Init with start_server function
  def init(:ok) do
    Process.flag(:trap_exit, true)
    server_pid = start_server()
    {:ok, server_pid}
  end

  def handle_info( {:EXIT, _pid, reason}, _state) do
    IO.puts "Http server exited (#{inspect reason})"
    server_pid = start_server()
    {:noreply, server_pid}
  end

  # start_server without spawn_link
  # defp start_server do
  #   IO.puts "Starting the HTTP server..."
  #   server_pid = spawn(Servy.HttpServer, :start, [4000])
  #   Process.link(server_pid)
  #   Process.register(server_pid, :http_server)
  #   server_pid
  # end

  # start_server with spawn_link
  defp start_server do
    IO.puts "Starting the HTTP server..."
    server_pid = spawn_link(Servy.HttpServer, :start, [4000])
    # server_pid = spawn(Servy.HttpServer, :start, [4000])
    # Process.link(server_pid)
    Process.register(server_pid, :http_server)
    server_pid
  end

end
