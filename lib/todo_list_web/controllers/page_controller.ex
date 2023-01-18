defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    render(conn, :home, page_title: "Home")
  end

  def show(conn, _params) do
    render(conn, :show, page_title: "Your Profile")
  end
end
