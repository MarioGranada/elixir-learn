defmodule Servy.FileHandler do
  def file_handler({:ok, content}, conv) do
    %{conv | status: 200, resp_body: content}
  end

  def file_handler({:error, :enoent }, conv) do
    %{conv | status: 404, resp_body: "File not found"}
  end

  def file_handler({:error, reason}, conv) do
    %{conv | status: 500, resp_body: "File error: #{reason}" }
  end
end
