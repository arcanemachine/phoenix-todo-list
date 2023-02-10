defmodule TodoListWeb.Plug.FetchTodo do
  import Plug.Conn

  alias TodoList.Todos

  def init(opts), do: opts

  @doc "Get Todo from parameters and add it to `conn`."
  def call(conn, _opts) do
    assign(conn, :todo, Todos.get_todo!(conn.params["id"]))
  end
end
