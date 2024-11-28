defmodule Servy2.Handler do
  import Servy.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [file_handler: 2]

  alias Servy.Conv
  alias Servy.BearController
  alias Servy.VideoCam

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

  def route(%Conv{ method: "GET", path: "/snapshots" } = conv) do
    parent = self()
    # snapshot1 = VideoCam.get_snapshot("cam-1")
    # snapshot2 = VideoCam.get_snapshot("cam-2")
    # snapshot3 = VideoCam.get_snapshot("cam-3")

    # spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    # # snapshot1 = spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    # # snapshot2 = spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
    # # snapshot3 = spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-3")}) end)

    # snapshot1 = receive do {:result, filename} -> filename end

    # **** Blocking code example

    # # spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    # # snapshot1 = receive do {:result, filename} -> filename end

    # # spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
    # # snapshot2 = receive do {:result, filename} -> filename end

    # # spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-3")}) end)
    # # snapshot3 = receive do {:result, filename} -> filename end

    # **** End of Blocking code example


    # **** Non-blocking code example

    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-1")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-2")}) end)
    spawn(fn -> send(parent, {:result, VideoCam.get_snapshot("cam-3")}) end)

    snapshot1 = receive do {:result, filename} -> filename end
    snapshot2 = receive do {:result, filename} -> filename end
    snapshot3 = receive do {:result, filename} -> filename end

    snapshots = [snapshot1, snapshot2, snapshot3]

    %{ conv | status: 200, resp_body: inspect snapshots}
    # %{ conv | status: 200, resp_body: inspect snapshot1}
  end

  def route(%Conv{ method: "GET", path: "/hibernate/" <> time } = conv) do
    time |> String.to_integer |> :timer.sleep

    %{ conv | status: 200, resp_body: "Awake!" }
  end

  def route(%Conv{ method: "GET", path: "/kaboom" } = conv) do
    IO.inspect conv
    raise "Kaboom!"
  end

  def route(%Conv{ method: "GET", path: "/wildthings"} = conv) do
    %{conv | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(%Conv{ method: "GET", path: "/api/bears"} = conv) do
    # %{conv | status: 200, resp_body: "Teddy, Smokey, Paddington"}
    Servy.Api.BearController.index(conv)
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
    # IO.inspect(conv)
    BearController.create(conv, conv.params)
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
    # """
    # HTTP/1.1 #{Conv.full_status(conv)}\r
    # Content-Type: text/html\r
    # Content-Length: #{String.length(conv.resp_body)}\r
    # \r
    # #{conv.resp_body}
    # """

    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end



end
