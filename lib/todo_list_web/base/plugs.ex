defmodule TodoListWeb.Plug do
  @moduledoc """
  This project's custom plugs
  """
  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn

  import TodoListWeb.Helpers.Controller, only: [http_response_403: 1]

  alias TodoList.Todos

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

    if todo.user_id == conn.assigns.current_user.id do
      conn
    else
      conn |> http_response_403()
    end
  end

  @doc """
  Ensure that the requesting user is the creator of this Todo.
  """
  def require_api_todo_permissions(conn, _opts) do
    todo = conn.assigns.todo

    if todo.user_id == conn.assigns.current_user.id do
      conn
    else
      conn |> put_status(:forbidden) |> json(%{message: "Forbidden"}) |> halt()
    end
  end

  @doc """
  Ensure that the ID of the requesting user matches the `id` param.
  """
  def require_api_user_permissions(conn, _opts) do
    if String.to_integer(conn.params["id"]) == conn.assigns.current_user.id do
      conn
    else
      conn |> put_status(:forbidden) |> json(%{message: "Forbidden"}) |> halt()
    end
  end
end
