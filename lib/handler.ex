defmodule ServyHandler do
  alias Servy2.Handler
  def handle do
    request = """
    GET /wildthings HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request))
    IO.puts(Handler.handle(request))

    request2 = """
    GET /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request2))
    IO.puts(Handler.handle(request2))

    request3 = "GET /sdfgsdfg HTTP/1.1\r\nHost: example.com\r\nUser-Agent: ExampleBrowser/1.0\r\nAccept: */*\r\n\r\n"
    # IO.puts(Servy2.handle(request3))
    IO.puts(Handler.handle(request3))
    request4 = "GET /bears/1 HTTP/1.1\r\nHost: example.com\r\nUser-Agent: ExampleBrowser/1.0\r\nAccept: */*\r\n\r\n"
    # IO.puts(Servy2.handle(request4))
    IO.puts(Handler.handle(request4))
    request5 = """
    DELETE /bears/1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request5))
    IO.puts(Handler.handle(request5))
    request6 = """
    DELETE /bears?id=1 HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request6))
    IO.puts(Handler.handle(request6))

    request7 = """
    GET /about HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request7))
    IO.puts(Handler.handle(request7))

    # request8 = """
    # GET /about HTTP/1.1\r
    # Host: example.com\r
    # User-Agent: ExampleBrowser/1.0\r
    # Accept: */*\r
    # """
    # IO.puts(Servy2.handle (request8))

    # request8 = """
    # GET /bears/new HTTP/1.1\r
    # Host: example.com\r
    # User-Agent: ExampleBrowser/1.0\r
    # Accept: */*\r

    # """
    # IO.puts(Servy2.handle (request8))


    request9 = """
    GET /pages/contact HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request9))
    IO.puts(Handler.handle(request9))

    request10 = """
    GET /pages/faq HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request10))
    IO.puts(Handler.handle(request10))

    request11 = """
    GET /pages/another HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    \r
    """
    # IO.puts(Servy2.handle(request11))
    IO.puts(Handler.handle(request11))

    request12 = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: application/x-www-form-urlencoded\r
    Content-Length: 21\r\n\r\nname=Baloo&type=Brown\r
    """
    # IO.puts(Servy2.handle(request12))
    IO.puts(Handler.handle(request12))

    request13 = """
    POST /bears HTTP/1.1\r
    Host: example.com\r
    User-Agent: ExampleBrowser/1.0\r
    Accept: */*\r
    Content-Type: multipart/form-data\r
    Content-Length: 21\r
    \r
    """
    # IO.puts(Servy2.handle(request13))
    IO.puts(Handler.handle(request13))



  end
end
