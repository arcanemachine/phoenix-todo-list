defmodule TodoListWeb.TodosAuth do
  import Plug.Conn

  alias TodoList.Todos
  alias TodoListWeb.Controller

  @doc """
  Get Todo from parameters.

  Ensure that the user has permission to access it, then add it to `conn`.
  """
  def require_todo_permissions(conn, _opts) do
    todo = Todos.get_todo!(conn.params["id"])

    case todo.user_id == conn.assigns.current_user.id do
      true ->
        conn |> assign(:todo, todo)

      false ->
        conn |> Controller.http_response_403()
    end
  end
end
