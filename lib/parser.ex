defmodule Servy.Parser do
  # alias Servy.Conv, as: Conv
  alias Servy.Conv

  def parse(request) do
    # [method, path, _] =
    # request
    # |> String.split("\n")
    # |> List.first
    # |> String.split(" ")

    [top, params_string] = String.split(request, "\r\n\r\n")
    # [method, path, _]  =
    #   top
    #   |> String.split("\n")
    #   |> List.first
    #   |> String.split(" ")

    [request_line | header_lines] = String.split(top, "\r\n")
    [method, path, _]  =  String.split(request_line, " ")
    # params = parse_params(params_string)


    headers = parse_headers(header_lines, %{})
    params = parse_params(headers["Content-Type"], params_string)


    # %{method: method,  path: path, resp_body: "", status: nil} # -> Using simple map
    # %Servy.Conv{ method: method, path: path} # -> Using struct
    %Conv{ method: method, path: path, params: params, headers: headers} # -> Using struct along with alias
  end

  # def parse_params(params_string) do
  #   params_string |> String.trim |> URI.decode_query
  # end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  # def parse_headers([]), do: IO.puts("Done!")
  def parse_headers([], headers), do: headers

  def parse_headers([head | tail], headers) do
    [key, value] = String.split(head, ": ")

    # headers = Map.put(%{}, key, value)
    headers = Map.put(headers, key, value)

    parse_headers(tail, headers)
  end


end
