defmodule TodoListWeb.Plug.ApiRequireUserPermissions do
  @moduledoc """
  Ensure that the ID of the requesting user matches the `id` param.
  """

  import Phoenix.Controller, only: [json: 2]
  import Plug.Conn, only: [put_status: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case String.to_integer(conn.params["id"]) == conn.assigns.current_user.id do
      true -> conn
      false -> conn |> put_status(:forbidden) |> json(%{message: "Forbidden"})
    end
  end
end
