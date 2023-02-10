defmodule TodoListWeb.Plug.RequireTodoPermissions do
  alias TodoListWeb.Helpers.Controller

  def init(opts), do: opts

  @doc "Ensure that the requesting user has permissions to access a given Todo."
  def call(conn, _opts) do
    todo = conn.assigns.todo

    case todo.user_id == conn.assigns.current_user.id do
      true ->
        conn

      false ->
        conn |> Controller.http_response_403()
    end
  end
end
