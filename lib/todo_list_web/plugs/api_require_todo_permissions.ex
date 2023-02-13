defmodule TodoListWeb.Plug.ApiRequireTodoPermissions do
  @moduledoc """
  Ensure that the requesting user is the creator of this Todo.
  """

  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn, only: [put_status: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    todo = conn.assigns.todo

    case todo.user_id == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> put_status(:forbidden) |> json(%{message: "Forbidden"})
    end
  end
end
