defmodule TodoListWeb.Api.TodoControllerTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import TodoList.TodosFixtures
  import TodoListWeb.Test.GenericTests

  alias TodoList.Todos.Todo

  @create_attrs %{content: "some content", is_completed: true}
  @update_attrs %{content: "some updated content", is_completed: false}
  @invalid_attrs %{content: nil, is_completed: nil}

  # urls
  def todo_index_url(), do: ~p"/api/todos"
  def todo_object_url(id), do: ~p"/api/todos/#{id}"

  # setup functions
  setup %{conn: conn} do
    {:ok, user: nil, conn: put_req_header(conn, "accept", "application/json")}
    # {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp authenticate_user(context) do
    context |> TodoListWeb.ConnCase.setup_authenticate_api_user()
  end

  defp create_todo(_context) do
    todo = todo_fixture()
    %{todo: todo}
  end

  # tests
  describe "index todos" do
    setup [:authenticate_user]

    # generic tests
    requires_authenticated_api_user(todo_index_url())

    test "lists all todos", %{conn: conn} do
      # make request
      conn = get(conn, todo_index_url())

      # response contains expected status code and data
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    setup [:authenticate_user]

    # generic tests
    requires_authenticated_api_user(todo_index_url(), "post")

    test "creates and renders todo when data is valid", %{conn: conn} do
      # make request
      conn = post(conn, todo_index_url(), todo: @create_attrs)

      # response contains expected status code and data
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, todo_object_url(id))

      assert %{
               "id" => ^id,
               "content" => "some content",
               "is_completed" => true
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # make request
      conn = post(conn, todo_index_url(), todo: @invalid_attrs)

      # response contains expected status code and data
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "update todo" do
    # setup [:authenticate_user, :create_todo]
    setup [:create_todo]

    # generic tests
    # requires_authenticated_api_user(todo_object_url(123), "put")
    # requires_authenticated_api_user(todo_object_url(123), "patch")

    @tag fixme: true
    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      dbg()
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/todos/#{id}")

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "is_completed" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      conn = put(conn, ~p"/api/todos/#{todo}", todo: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    # def test_url, do: todo_object_url(todo)

    # # generic tests
    # test_requires_authenticated_api_user(test_url)

    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, ~p"/api/todos/#{todo}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/todos/#{todo}")
      end
    end
  end
end
