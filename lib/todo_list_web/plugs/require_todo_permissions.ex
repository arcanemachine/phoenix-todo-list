defmodule TodoListWeb.Plug.RequireTodoPermissions do
  @moduledoc """
  Ensure that the requesting user is the creator of this Todo.
  """

  alias TodoListWeb.Helpers.Controller

  def init(opts), do: opts

  def call(conn, _opts) do
    todo = conn.assigns.todo

    case todo.user_id == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> Controller.http_response_403()
    end
  end
end
