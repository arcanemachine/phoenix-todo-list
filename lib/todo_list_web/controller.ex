defmodule TodoListWeb.Controller do
  @moduledoc "Generic controller helper functions."

  import Plug.Conn
  import Phoenix.Controller

  def forbidden(conn) do
    conn
    |> put_status(:forbidden)
    |> text("403 Forbidden")
    |> halt()
  end
end
