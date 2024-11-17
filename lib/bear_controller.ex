defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear
  alias Servy.BearView

  # @templates_path Path.expand("../templates/", __DIR__)

  # defp bear_item(bear) do
  #   "<li>#{bear.name} - #{bear.type} </li>"
  # end

  # defp render(conv, template, bindings \\ []) do
  #   content = @templates_path |> Path.join(template) |> EEx.eval_file(bindings)
  #   %{conv | status: 200, resp_body: content}
  # end


  def index(conv) do
    # items =
    #   Wildthings.list_bears()
    #   |> Enum.filter(fn(b) -> Bear.is_grizzly(b) end)
    #   |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1,b2) end)
    #   |> Enum.map(fn(b) -> bear_item(b) end)
    #   |> Enum.join

    # items =
    #   Wildthings.list_bears()
    #   |> Enum.filter(&Bear.is_grizzly(&1))
    #   |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
    #   |> Enum.map(&bear_item(&1))
    #   |> Enum.join

    # bears = Wildthings.list_bears()

    bears = Wildthings.list_bears() |> Enum.sort(&Bear.order_asc_by_name/2)

    # items =
    #   bears
    #   |> Enum.filter(&Bear.is_grizzly/1)
    #   |> Enum.sort(&Bear.order_asc_by_name/2)
    #   |> Enum.map(&bear_item/1)
    #   |> Enum.join

    # content = @templates_path |> Path.join("index.eex") |> EEx.eval_file(bears: bears)

    # # %{conv | status: 200, resp_body: "<ul>#{items}</ul>"}
    # %{conv | status: 200, resp_body: content}

    # render(conv, "index.eex", bears: bears)

    %{conv | status: 200, resp_body: BearView.index(bears)}
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    # content = @templates_path |> Path.join("show.eex") |> EEx.eval_file(bear: bear)

    # # %{conv | status: 200, resp_body: "<h1>Bear #{id}: #{bear.name} </h1>"}
    # %{conv | status: 200, resp_body: content}

    # render(conv, "show.eex", bear: bear)

    %{conv | status: 200, resp_body: BearView.show(bear)}
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    IO.inspect(params)
    # %{conv | status: 201, resp_body: "Created a #{conv.params["type"]} bear named #{conv.params["name"]}!"}
    %{conv | status: 201, resp_body: "Created a #{type} bear named #{name}!"}
  end

  def create(conv, %{}), do: conv
end
