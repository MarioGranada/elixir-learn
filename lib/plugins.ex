defmodule Servy.Plugins do

  # def rewrite_path(%{path: "/bears?id=" <> id} = conv) do
 #   %{ conv | path: "/bears/#{id}" }
 # end

 alias Servy.Conv

 def track(%Conv{status: 404, path: path} = conv) do
  IO.puts "Warning: #{path} is on the loose!"
  conv
 end

 def track(%Conv{} =  conv), do: conv

 def rewrite_path(%Conv{path: path} = conv) do
   regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
   captures = Regex.named_captures(regex, path)
   rewrite_path_captures(conv, captures)
 end

 # def rewrite_path(conv), do: conv

 def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => nil}) do
   %{ conv | path: "/#{thing}" }
 end

 def rewrite_path_captures(%Conv{} = conv, %{"thing" => thing, "id" => id}) do
   %{ conv | path: "/#{thing}/#{id}" }
 end

 def rewrite_path_captures(%Conv{} = conv, nil), do: conv

 @doc "Logs the request"
 def log(%Conv{} =  conv), do: IO.inspect(conv)

end
