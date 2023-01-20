defmodule TodoListWeb.TodoControllerTest do
  use TodoListWeb.ConnCase

  import TodoList.TodosFixtures

  @create_attrs %{content: "some content", is_completed: true}
  @update_attrs %{content: "some updated content", is_completed: false}
  @invalid_attrs %{content: nil, is_completed: nil}

  describe "index" do
    test "lists all todos", %{conn: conn} do
      conn = get(conn, ~p"/todos")
      assert html_response(conn, 200) =~ "Listing Todos"
    end
  end

  describe "new todo" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/todos/new")
      assert html_response(conn, 200) =~ "New Todo"
    end
  end

  describe "create todo" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/todos", todo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/todos/#{id}"

      conn = get(conn, ~p"/todos/#{id}")
      assert html_response(conn, 200) =~ "Todo #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/todos", todo: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Todo"
    end
  end

  describe "edit todo" do
    setup [:create_todo]

    test "renders form for editing chosen todo", %{conn: conn, todo: todo} do
      conn = get(conn, ~p"/todos/#{todo}/edit")
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "update todo" do
    setup [:create_todo]

    test "redirects when data is valid", %{conn: conn, todo: todo} do
      conn = put(conn, ~p"/todos/#{todo}", todo: @update_attrs)
      assert redirected_to(conn) == ~p"/todos/#{todo}"

      conn = get(conn, ~p"/todos/#{todo}")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, ~p"/todos/#{todo}", todo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, ~p"/todos/#{todo}")
      assert redirected_to(conn) == ~p"/todos"

      assert_error_sent 404, fn ->
        get(conn, ~p"/todos/#{todo}")
      end
    end
  end

  defp create_todo(_) do
    todo = todo_fixture()
    %{todo: todo}
  end
end
