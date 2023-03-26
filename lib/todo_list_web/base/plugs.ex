defmodule TodoListWeb.Plug do
  @moduledoc """
  This project's custom plugs
  """
  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn, only: [put_status: 2, assign: 3]

  import TodoListWeb.Helpers.Controller, only: [http_response_403: 1]

  alias TodoList.Todos

  @doc """
  Ensure that the requesting user is the creator of this Todo.
  """
  def api_require_todo_permissions(conn, _opts) do
    todo = conn.assigns.todo

    case todo.user_id == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> put_status(:forbidden) |> json(%{message: "Forbidden"})
    end
  end

  @doc """
  Ensure that the ID of the requesting user matches the `id` param.
  """
  def api_require_user_permissions(conn, _opts) do
    case String.to_integer(conn.params["id"]) == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> put_status(:forbidden) |> json(%{message: "Forbidden"})
    end
  end

  @doc """
  Get a Todo by the `id` param and add it to the `conn`.
  """
  def fetch_todo(conn, _opts) do
    assign(conn, :todo, Todos.get_todo!(conn.params["id"]))
  end

  @doc """
  Ensure that the requesting user is the creator of this Todo.
  """
  def require_todo_permissions(conn, _opts) do
    todo = conn.assigns.todo

    case todo.user_id == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> http_response_403()
    end
  end
end
