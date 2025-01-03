defmodule Servy.GenericServer do

  def start(callback_module,  initial_state, name) do
    pid = spawn(__MODULE__, :listen_loop, [initial_state, callback_module])
    Process.register(pid, name)
    pid
  end

  def call(pid, message) do
    send pid, {:call,  self(), message}
    receive do {:response, response} -> response end
  end

  def cast(pid, message) do
    send pid, {:cast, message}
  end

  def listen_loop(state, callback_module) do
    IO.puts "Waiting for a message..."

    receive do
      {:call, sender, message} when is_pid(sender) ->
        {response, new_state} = callback_module.handle_call(message, state)
        send sender, {:response, response}
        listen_loop(new_state, callback_module)
      # :clear ->
      #   listen_loop([])
      {:cast, message} ->
        new_state = callback_module.handle_cast(message, state)
        listen_loop(new_state, callback_module)
      unexpected ->
        IO.puts "Unexpected message: #{inspect unexpected}"
        listen_loop(state, callback_module)
    end
  end
end

defmodule Servy.PledgeServer do
  alias Servy.GenericServer
  @name  :pledge_server


  # def start do
  #   IO.puts "Starting the pledge server..."
  #   pid = spawn(__MODULE__, :listen_loop, [[]])
  #   Process.register(pid, @name)
  #   pid
  # end

  def start do
    IO.puts "Starting the pledge server..."
    GenericServer.start(__MODULE__, [], @name)
  end

  # def listen_loop(state) do
  #   IO.puts "Waiting for a message..."

  #   # receive do
  #   #   {:create_pledge, name, amount} ->
  #   #     {:ok, id} = send_pledge_to_service(name, amount)
  #   #     most_recent_pledges = Enum.take(state, 2)
  #   #     new_state = [{name, amount} | most_recent_pledges]
  #   #     IO.puts "#{name} pledged #{amount}!"
  #   #     IO.puts "New state is #{inspect new_state}"
  #   #     listen_loop(new_state)
  #   #   {sender, :recent_pledges} ->
  #   #       send sender, {:response, state}
  #   #       IO.puts "Sent pledges to #{inspect sender}"
  #   #       listen_loop(state)
  #   # end

  #   receive do
  #     {sender, message} ->
  #       response = handle_call(message, state)
  #       send sender, {:response, response}
  #       listen_loop(state)
  #     {sender, {:create_pledge, name, amount}} ->
  #     # {sender, :create_pledge, name, amount} ->
  #       {:ok, id} = send_pledge_to_service(name, amount)
  #       most_recent_pledges = Enum.take(state, 2)
  #       new_state = [{name, amount} | most_recent_pledges]
  #       IO.puts "#{name} pledged #{amount}!"
  #       IO.puts "New state is #{inspect new_state}"
  #       send sender, {:response, id}
  #       listen_loop(new_state)
  #     {sender, :recent_pledges} ->
  #         send sender, {:response, state}
  #         IO.puts "Sent pledges to #{inspect sender}"
  #         listen_loop(state)
  #     {sender, :total_pledged} ->
  #         total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
  #         send sender, {:response, total}
  #         IO.puts "Sent pledges to #{inspect sender}"
  #         listen_loop(state)
  #     unexpected ->
  #       IO.puts "Unexpected message: #{inspect unexpected}"
  #       listen_loop(state)
  #   end

  # end

  # def listen_loop(state) do
  #   IO.puts "Waiting for a message..."

  #   receive do
  #     {:call, sender, message} when is_pid(sender) ->
  #       {response, new_state} = handle_call(message, state)
  #       send sender, {:response, response}
  #       listen_loop(new_state)
  #     # :clear ->
  #     #   listen_loop([])
  #     {:cast, message} ->
  #       new_state = handle_cast(message, state)
  #       listen_loop(new_state)
  #     unexpected ->
  #       IO.puts "Unexpected message: #{inspect unexpected}"
  #       listen_loop(state)
  #   end

  # end

  # # def create_pledge(pid, name, amount) do
  # def create_pledge(name, amount) do
  #   # Cache the pledge
  #   # {:ok, id} = send_pledge_to_service(name, amount)
  #   # send pid, {self(), :create_pledge, name, amount}
  #   # send :pledge_server, {self(), :create_pledge, name, amount}
  #   send @name, {self(), :create_pledge, name, amount}

  #   receive do {:response, status} -> status end
  # end

  # # def recent_pledges(pid) do
  # def recent_pledges do

  #   # Returns the most recent pledges (cache):
  #   # send pid, {self(), :recent_pledges}
  #   # send :pledge_server, {self(), :recent_pledges}
  #   send @name, {self(), :recent_pledges}
  #   # receive do {:response, pledges} -> IO.inspect pledges end
  #   receive do {:response, pledges} -> pledges end
  # end

  # def total_pledged do
  #   send @name, {self(), :total_pledged}

  #   receive do {:response, total} -> total end
  # end

  def create_pledge(name, amount) do
    GenericServer.call @name, {:create_pledge, name, amount}
  end

  # def recent_pledges(pid) do
  def recent_pledges do
    GenericServer.call @name, :recent_pledges
  end

  def total_pledged do
    GenericServer.call @name, :total_pledged
  end

  def clear do
    GenericServer.cast @name, :clear
  end

  def handle_cast(:clear, _state) do
    []
  end

  def handle_call(:total_pledged, state) do
    total = Enum.map(state, &elem(&1, 1)) |> Enum.sum
    {total, state}
  end

  def handle_call(:recent_pledges, state) do
    {state, state}
  end

  def handle_call({:create_pledge, name, amount}, state) do
    {:ok, id} = send_pledge_to_service(name, amount)
    most_recent_pledges = Enum.take(state, 2)
    new_state = [{name, amount} | most_recent_pledges]
    {id, new_state}
  end


  # def call(pid, message) do
  #   send pid, {:call,  self(), message}
  #   receive do {:response, response} -> response end
  # end

    # def cast(pid, message) do
  #   send pid, {:cast, message}
  # end

  defp send_pledge_to_service(_name, _amount) do
    # Code goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end

end
