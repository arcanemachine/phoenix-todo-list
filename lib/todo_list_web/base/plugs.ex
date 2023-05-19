defmodule TodoListWeb.Plug do
  @moduledoc """
  This project's custom plugs
  """
  import Plug.Conn

  alias TodoList.Todos
  alias TodoListWeb.Helpers.Controller, as: ControllerHelpers

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
      conn |> ControllerHelpers.http_response_403()
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
      conn |> ControllerHelpers.json_response_403()
    end
  end

  @doc """
  Ensure that the ID of the requesting user matches the `id` param.
  """
  def require_api_user_permissions(conn, _opts) do
    try do
      user_id = String.to_integer(conn.params["id"])

      if user_id == conn.assigns.current_user.id do
        conn
      else
        conn |> ControllerHelpers.json_response_403()
      end
    rescue
      _err in ArgumentError ->
        conn |> ControllerHelpers.json_response_400("Invalid user ID detected")
    end
  end
end
