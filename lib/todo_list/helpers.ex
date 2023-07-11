defmodule TodoList.Helpers do
  @moduledoc false

  def generate_random_string(length \\ 32) do
    for _ <- 1..length, into: "", do: <<Enum.random(~c"0123456789abcdef")>>
  end
end
