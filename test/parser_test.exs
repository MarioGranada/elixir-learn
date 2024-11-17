defmodule ParserTest do
  use ExUnit.Case
  doctest Servy.Parser

  alias Servy.Parser

  test "parsers a list of header fields into a map" do
    # assert Servy.hello() == :world

    header_lines = ["A: 1", "B: 2"]

    headers = Parser.parse_headers(header_lines, %{})

    assert headers === %{"A" => "1", "B" => "2"}
  end
end
