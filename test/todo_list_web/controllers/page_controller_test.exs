defmodule TodoListWeb.PageControllerTest do
  @moduledoc false
  use TodoListWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    # page_title
    assert html_response(conn, 200) =~ "Home"
    # template_content
    assert html_response(conn, 200) =~ "Yet Another Todo List"
  end
end
