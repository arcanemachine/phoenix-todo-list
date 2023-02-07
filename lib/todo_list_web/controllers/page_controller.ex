defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    # |> put_flash(:info, "Hello world!")
    |> render(:home, layout: false)
  end
end
