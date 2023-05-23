defmodule TodoListWeb.TodoControllerTest do
  use TodoListWeb.ConnCase

  import TodoList.AccountsFixtures
  import TodoList.TodosFixtures

  alias TodoList.Todos.Todo

  setup do
    %{user: user_fixture()}
  end

  @create_attrs %{content: "some content", is_completed: true}
  @update_attrs %{content: "some updated content", is_completed: false}
  @invalid_attrs %{content: nil, is_completed: nil}

  describe "unauthenticated user" do
    setup [:create_fixtures]

    test "cannot view todos :index", %{conn: conn} do
      conn = conn |> get(~p"/todos")
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot make :new todo", %{conn: conn} do
      conn = conn |> get(~p"/todos/new")
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot :create todo", %{conn: conn} do
      conn = conn |> post(~p"/todos", todo: @create_attrs)
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot :show todo", %{conn: conn, todo: todo} do
      conn = conn |> get(~p"/todos/#{todo}")
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot :edit todo", %{conn: conn, todo: todo} do
      conn = conn |> get(~p"/todos/#{todo}/edit")
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot :update todo", %{conn: conn, todo: todo} do
      conn = conn |> put(~p"/todos/#{todo}", todo: @update_attrs)
      assert redirected_to(conn) == ~p"/users/login"
    end

    test "cannot :delete todo", %{conn: conn, todo: todo} do
      conn = conn |> delete(~p"/todos/#{todo}")
      assert redirected_to(conn) == ~p"/users/login"
    end
  end

  describe "unauthorized user" do
    setup [:create_fixtures]

    test "cannot :show another user's todo", %{conn: conn, todo: todo} do
      other_user = user_fixture()

      conn = conn |> login_user(other_user) |> get(~p"/todos/#{todo}")
      assert text_response(conn, 403) =~ "Forbidden"
    end

    test "cannot :edit another user's todo", %{conn: conn, todo: todo} do
      other_user = user_fixture()

      conn = conn |> login_user(other_user) |> get(~p"/todos/#{todo}/edit")
      assert text_response(conn, 403) =~ "Forbidden"
    end

    test "cannot :update another user's todo", %{conn: conn, todo: todo} do
      other_user = user_fixture()

      conn = conn |> login_user(other_user) |> put(~p"/todos/#{todo}", todo: @update_attrs)
      assert text_response(conn, 403) =~ "Forbidden"
    end

    test "cannot :delete another user's todo", %{conn: conn, todo: todo} do
      other_user = user_fixture()

      conn = conn |> login_user(other_user) |> delete(~p"/todos/#{todo}")
      assert text_response(conn, 403) =~ "Forbidden"
    end
  end

  describe "index" do
    test "lists all todos", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> get(~p"/todos")
      assert html_response(conn, 200) =~ "Todo List"
    end

    test "does not show paginator HTML if object count is less than the default_limit", %{
      conn: conn,
      user: user
    } do
      # the test conditions for this test should be satisfied without any effort on our part

      # make request
      conn = conn |> login_user(user) |> get(~p"/todos")

      # template contains expected content
      refute html_response(conn, 200) =~ "nav class=\"pagination\""
    end

    test "shows paginator HTML if object count is greater than the default_limit", %{
      conn: conn,
      user: user
    } do
      # find out how many objects we need to create to satisfy the test conditions
      required_todos_count = Flop.get_option(:default_limit, for: Todo) + 1

      # create the required number of objects to satisfy the test conditions
      for _ <- 1..required_todos_count, do: todo_fixture(%{user_id: user.id})

      # make request
      conn = conn |> login_user(user) |> get(~p"/todos")

      # template contains expected content
      assert html_response(conn, 200) =~ "nav class=\"pagination\""
    end
  end

  describe "new todo" do
    test "renders form", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> get(~p"/todos/new")
      assert html_response(conn, 200) =~ "Create Todo"
    end
  end

  describe "create todo" do
    test "redirects to show when data is valid", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> post(~p"/todos", todo: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/todos/#{id}"

      conn = get(conn, ~p"/todos/#{id}")
      assert html_response(conn, 200) =~ "Todo Info (##{id})"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = conn |> login_user(user) |> post(~p"/todos", todo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Create Todo"
    end
  end

  describe "show todo" do
    setup [:create_fixtures]

    test "allows user to view their todo", %{conn: conn, user: user, todo: todo} do
      conn = conn |> login_user(user) |> get(~p"/todos/#{todo}")
      assert html_response(conn, 200) =~ "Todo Info (##{todo.id})"
    end
  end

  describe "edit todo" do
    setup [:create_fixtures]

    test "renders form for editing chosen todo", %{conn: conn, user: user, todo: todo} do
      conn = conn |> login_user(user) |> get(~p"/todos/#{todo}/edit")
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "update todo" do
    setup [:create_fixtures]

    test "redirects when data is valid", %{conn: conn, user: user, todo: todo} do
      conn = conn |> login_user(user) |> put(~p"/todos/#{todo}", todo: @update_attrs)
      assert redirected_to(conn) == ~p"/todos"

      conn = conn |> get(~p"/todos")
      assert html_response(conn, 200) =~ "some updated content"
    end

    test "renders errors when data is invalid", %{conn: conn, user: user, todo: todo} do
      conn = conn |> login_user(user) |> put(~p"/todos/#{todo}", todo: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Todo"
    end
  end

  describe "delete todo" do
    setup [:create_fixtures]

    test "deletes chosen todo", %{conn: conn, user: user, todo: todo} do
      conn = conn |> login_user(user) |> delete(~p"/todos/#{todo}")
      assert redirected_to(conn) == ~p"/todos"

      assert_error_sent 404, fn ->
        get(conn, ~p"/todos/#{todo}")
      end
    end
  end

  defp create_fixtures(_) do
    user = user_fixture()
    todo = todo_fixture(user_id: user.id)
    %{user: user, todo: todo}
  end
end
