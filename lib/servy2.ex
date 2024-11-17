defmodule Servy2.Handler do
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [file_handler: 2]

  alias Servy.Conv
  alias Servy.BearController

  @page_path Path.expand("../pages/", __DIR__)
  # @page_path Path.expand("../pages/", File.cwd!) # File.cwd! returns current working directory which means the root project folder where the mix.exs and readme files are located.

  @moduledoc "Handles HTTP requests."

  @doc "Transforms the request into a response."
  def handle(request) do
    request
    |> parse
    |> log
    |> rewrite_path
    |> route
    |> track
    |> format_response
  end



  # # def route(conv) do
  # #   # %{conv | resp_body: "Bears, Lions, Tigers"}
  # #   # %{conv | my_test: "Bears, Lions, Tigers"}
  # #   route(conv, conv.method, conv.path)
  # # end

  # def route(conv, "GET",  "/wildthings") do
  #   %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  # end

  # def route(conv, "GET", "/bears") do
  #   %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  # end

  # def route(conv, "GET", "/bears/" <> id) do
  #   %{conv | status: 200, resp_body: "Bear #{id}"}
  # end

  # def route(conv, "DELETE", "/bears/" <> id ) do
  #   %{conv | status: 200, resp_body: "Deleting bear #{id}"}
  # end

  # def route(conv, "DELETE", "/bears/" <> _id) do
  #   %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  # end

  # def route(conv, _method, path) do
  #   %{conv | status: 404, resp_body: "No #{path} here!"}
  # end

  def route(%Conv{ method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{ method: "GET", path: "/bears"} = conv) do
    # %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
    BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id} = conv) do
    params = Map.put(conv.params, "id", id)
    # %{conv | status: 200, resp_body: "Bear #{id}"}
    BearController.show(conv, params)
  end



  def route(%Conv{ method: "GET", path: "/bears/new"} = conv) do
    # %{conv | status: 200, resp_body: ""}
    # Path.expand("../pages/", __DIR__)
    @page_path
    |> Path.join("format.html")
    |> File.read
    |> file_handler(conv)
    # read_file = File.read(file)
    # file_handler(read_file, conv)
  end

  def route(%Conv{ method: "DELETE", path: "/bears/" <> id} = conv) do
    %{conv | status: 200, resp_body: "Deleting bear #{id}"}
  end



  def route(%Conv{ method: "POST", path: "/bears"} = conv) do
    # %{conv | status: 201, resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}\
    IO.inspect(conv)
    IO.inspect(BearController.create(conv, conv.params))
  end

  def route(%Conv{method: "GET", path: "/about"} = conv) do
    #%{conv | status: 200, resp_body: "contents of file "}
    # pages_path = Path.expand("../pages/", __DIR__)
    # IO.puts(pages_path)
    # file = Path.expand("../pages/", __DIR__) |>  Path.join("about.html")
    file = @page_path |>  Path.join("about.html")
    IO.puts(file)

    # case File.read("pages/about.html") do
    case File.read(file) do
      {:ok, content}  -> %{conv | status: 200, resp_body: content}
      {:error, :enoent } -> %{conv | status: 404, resp_body: "File not found"}
      {:error, reason} -> %{conv | status: 500, resp_body: "File error: #{reason}"}
    end

  end

  def route(%Conv{method: "GET", path: "/pages/" <> file_path} = conv)  do
    # Path.expand("../pages/", __DIR__)
    @page_path
    |> Path.join(file_path <> ".html")
    |> File.read
    |> file_handler(conv)
  end

  # def route(%{ method: "GET", path: "/bears/" <> _id} = conv) do
  #   %{ conv | status: 403, resp_body: "Deleting a bear is forbidden!"}
  # end

  def route(%Conv{ path: path} = conv) do
    %{conv | status: 404, resp_body: "No #{path} here!"}
  end

  # defp status_reason(code) do
  #   %{
  #     200 => "OK",
  #     201 => "Created",
  #     401 => "Unauthorized",
  #     403 => "Forbidden",
  #     404 => "Not Found",
  #     500 => "Internal Server Error"
  #   }[code]
  # end

  # def format_response(%Conv{} = conv) do
  #   """
  #   HTTP/1.1 #{conv.status} #{status_reason(conv.status) }
  #   Content-Type: text/html
  #   Content-Length: #{String.length(conv.resp_body)}

  #   #{conv.resp_body}
  #   """
  # end

  def format_response(%Conv{} = conv) do
    IO.inspect(conv)
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: text/html\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end



end
