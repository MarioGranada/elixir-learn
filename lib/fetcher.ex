defmodule Servy.Fetcher do
  # alias Servy.VideoCam
  # parent = self()
  # spawn(fn -> send(parent, VideoCam.get_snapshot("cam-1"))  end)
  # snapshot1 = receive do filename -> filename end

  # def async(device) do
  #   parent = self()
  #   spawn(fn -> send(parent, {:result, VideoCam.get_snapshot(device)})  end)
  # end

  # def get_result do
  #   receive do {:result, filename} -> filename end
  # end

  def async(fun) do
    parent = self()
    spawn(fn -> send(parent, {self(), :result, fun.()})  end)
  end

  # def get_result do
  #   receive do {:result, value} -> value end
  # end

  def get_result(pid) do
    receive do {^pid, :result, value} -> value end
  end



end
