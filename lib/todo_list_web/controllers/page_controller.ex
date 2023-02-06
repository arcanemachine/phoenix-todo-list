defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    render(conn, :home, page_title: "Home")
  end
end
