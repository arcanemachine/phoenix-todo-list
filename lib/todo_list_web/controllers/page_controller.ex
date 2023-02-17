defmodule TodoListWeb.PageController do
  use TodoListWeb, :controller

  def home(conn, _params) do
    conn
    |> render(:home, layout: false, page_title: "Yet Another Todo List", page_subtitle: "Home")
  end
end
