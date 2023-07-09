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
    # add basic headers for API requests
    conn = put_req_header(conn, "accept", "application/json")

    # authenticate user
    conn = TodoListWeb.ConnCase.register_and_login_api_user(%{conn: conn}) |> Map.get(:conn)

    {:ok, conn: conn}
  end

  defp create_todo(context) do
    conn = context.conn

    # if conn has authenticated user, use them to create todo fixture
    todo =
      case conn.assigns.current_user do
        nil -> todo_fixture()
        _ -> todo_fixture(%{user_id: conn.assigns.current_user.id})
      end

    %{todo: todo}
  end

  # tests
  describe "index todos" do
    # generic tests
    test_requires_authenticated_api_user(todo_index_url())

    test "lists all todos", %{conn: conn} do
      # make request
      conn = get(conn, todo_index_url())

      # response contains expected status code and data
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create todo" do
    # generic tests
    test_requires_authenticated_api_user(todo_index_url(), "post")

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
    setup [:create_todo]

    # generic tests
    test_requires_authenticated_api_user(todo_object_url(123), "put")
    test_requires_authenticated_api_user(todo_object_url(123), "patch")

    test "forbids unpermissioned user (put)", %{conn: conn, todo: todo} do
      forbids_unpermissioned_api_user(conn, todo_object_url(todo.id), "put")
    end

    test "forbids unpermissioned user (patch)", %{conn: conn, todo: todo} do
      forbids_unpermissioned_api_user(conn, todo_object_url(todo.id), "patch")
    end

    # custom tests
    test "renders todo when data is valid", %{conn: conn, todo: %Todo{id: id} = todo} do
      # make request
      conn = put(conn, todo_object_url(todo), todo: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      # returns updated content
      conn = get(conn, todo_object_url(todo.id))

      assert %{
               "id" => ^id,
               "content" => "some updated content",
               "is_completed" => false
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, todo: todo} do
      # make request
      conn = put(conn, todo_object_url(todo.id), todo: @invalid_attrs)

      # response should contain errors
      assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "delete todo" do
    setup [:create_todo]

    # generic tests
    test_requires_authenticated_api_user(todo_object_url(123), "delete")

    @tag example_tag: true
    test "forbids unpermissioned user (delete)", %{conn: conn, todo: todo} do
      forbids_unpermissioned_api_user(conn, todo_object_url(todo.id), "delete")
    end

    # custom tests
    test "deletes chosen todo", %{conn: conn, todo: todo} do
      conn = delete(conn, todo_object_url(todo.id))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, todo_object_url(todo.id))
      end
    end
  end
end
