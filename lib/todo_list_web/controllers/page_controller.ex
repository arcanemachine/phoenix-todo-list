defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    render(conn, :home, layout: false)
  end
end
