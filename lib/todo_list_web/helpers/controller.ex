defmodule TodoListWeb.Helpers.Controller do
  @moduledoc "Generic controller helper functions."

  import Plug.Conn
  import Phoenix.Controller

  def http_response_403(conn) do
    conn
    |> put_status(403)
    |> text("403 Forbidden")
    |> halt()
  end
end
