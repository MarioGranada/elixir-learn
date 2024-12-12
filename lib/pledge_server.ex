defmodule Servy.PledgeServer do
  @name  :pledge_server

  def start do
    IO.puts "Starting the pledge server..."
    pid = spawn(__MODULE__, :listen_loop, [[]])
    Process.register(pid, @name)
    pid
  end

  def listen_loop(state) do
    IO.puts "Waiting for a message..."

    # receive do
    #   {:create_pledge, name, amount} ->
    #     {:ok, id} = send_pledge_to_service(name, amount)
    #     most_recent_pledges = Enum.take(state, 2)
    #     new_state = [{name, amount} | most_recent_pledges]
    #     IO.puts "#{name} pledged #{amount}!"
    #     IO.puts "New state is #{inspect new_state}"
    #     listen_loop(new_state)
    #   {sender, :recent_pledges} ->
    #       send sender, {:response, state}
    #       IO.puts "Sent pledges to #{inspect sender}"
    #       listen_loop(state)
    # end

    receive do
      {sender, :create_pledge, name, amount} ->
        {:ok, id} = send_pledge_to_service(name, amount)
        most_recent_pledges = Enum.take(state, 2)
        new_state = [{name, amount} | most_recent_pledges]
        IO.puts "#{name} pledged #{amount}!"
        IO.puts "New state is #{inspect new_state}"
        send sender, {:response, id}
        listen_loop(new_state)
      {sender, :recent_pledges} ->
          send sender, {:response, state}
          IO.puts "Sent pledges to #{inspect sender}"
          listen_loop(state)
      {sender, :total_pledged} ->
          total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
          send sender, {:response, total}
          IO.puts "Sent pledges to #{inspect sender}"
          listen_loop(state)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state)
    end

  end

  # def create_pledge(pid, name, amount) do
  def create_pledge(name, amount) do
    # Cache the pledge
    # {:ok, id} = send_pledge_to_service(name, amount)
    # send pid, {self(), :create_pledge, name, amount}
    # send :pledge_server, {self(), :create_pledge, name, amount}
    send @name, {self(), :create_pledge, name, amount}

    receive do {:response, status} -> status end
  end

  # def recent_pledges(pid) do
  def recent_pledges do

    # Returns the most recent pledges (cache):
    # send pid, {self(), :recent_pledges}
    # send :pledge_server, {self(), :recent_pledges}
    send @name, {self(), :recent_pledges}
    # receive do {:response, pledges} -> IO.inspect pledges end
    receive do {:response, pledges} -> pledges end
  end

  def total_pledged do
    send @name, {self(), :total_pledged}

    receive do {:response, total} -> total end
  end

  defp send_pledge_to_service(_name, _amount) do
    # Code goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
