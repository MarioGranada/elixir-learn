defmodule ServyTest do
  use ExUnit.Case
  # doctest Servy

  test "the truth" do
    # assert Servy.hello() == :world
    assert 1 + 1 == 2
    refute 1 + 1 == 3
  end
end
