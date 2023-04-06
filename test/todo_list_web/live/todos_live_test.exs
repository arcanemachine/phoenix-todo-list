defmodule TodoListWeb.TodosLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import Ecto.Query
  import Phoenix.LiveViewTest
  import TodoList.TodosFixtures
  import TodoList.AccountsFixtures

  alias TodoList.Repo
  alias TodoList.Todos
  alias TodoList.Todos.Todo

  def test_url, do: ~p"/todos/live"

  # setup
  setup %{conn: conn} do
    # create and login a user
    user = user_fixture()
    conn = login_user(conn, user)

    {:ok, conn: conn, user: user}
  end

  # tests
  describe "Page" do
    test "renders expected template", %{conn: conn} do
      # make request
      {:ok, _lv, html} = conn |> live(test_url())

      # response contains expected text
      assert html =~ "Live Todo List"
    end

    test "redirects unauthenticated user to login page", %{conn: conn} do
      # ensure that the user is not authenticated
      conn = logout_user(conn)

      # make request
      assert {:error, redirect} = live(conn, ~p"/todos/live")

      # redirects to expected path and has expected flash message
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/login"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "Todo form" do
    test "creates a new todo", %{conn: conn} do
      todo_content = valid_todo_content()

      # get initial object count
      initial_object_count = TodoList.Repo.Helpers.count(Todo)

      # load liveview
      {:ok, lv, _html} = live(conn, test_url())

      # build and submit form
      result = form(lv, "#todo-create-test-form", %{"content" => todo_content}) |> render_submit()

      # object count has increased by 1
      final_object_count = TodoList.Repo.Helpers.count(Todo)
      assert final_object_count == initial_object_count + 1

      # new object has been created
      new_todo = Todo |> last(:inserted_at) |> Repo.one()

      # page renders expected object content
      assert result =~ new_todo.content
    end

    test "updates an existing todo", %{conn: conn, user: user} do
      todo = todo_fixture(%{user_id: user.id})
      updated_todo_content = "updated todo content"

      # get initial object count
      initial_object_count = TodoList.Repo.Helpers.count(Todo)

      # load liveview
      {:ok, lv, _html} = live(conn, test_url())

      # build and submit form
      html =
        form(lv, "#todo-update-test-form", %{
          "id" => "#{todo.id}",
          "content" => updated_todo_content
        })
        |> render_submit()

      # object count has not changed
      final_object_count = TodoList.Repo.Helpers.count(Todo)
      assert final_object_count == initial_object_count

      # existing object has been updated with expected values
      updated_todo = Todo |> last(:inserted_at) |> Repo.one()
      assert updated_todo.content == updated_todo_content

      # page renders expected object content
      assert html =~ updated_todo_content
    end
  end

  describe "Todo list" do
    setup %{user: user} do
      # create todos for user
      {:ok, incomplete_todo} =
        Todos.create_todo(%{user_id: user.id, content: "Incomplete Todo", is_completed: false})

      {:ok, completed_todo} =
        Todos.create_todo(%{user_id: user.id, content: "Completed Todo", is_completed: true})

      %{todos: [incomplete_todo, completed_todo]}
    end

    test "shows all todos belonging to the user", %{conn: conn, todos: todos} do
      # load liveview
      {:ok, _lv, html} = live(conn, test_url())

      # page contains content of all todos
      Enum.map(todos, fn todo -> assert html =~ todo.content end)
    end

    test "does not show todos belonging to another user", %{conn: conn} do
      # create other user
      other_user = user_fixture()

      # create todo for other user
      {:ok, other_todo} = Todos.create_todo(%{content: "Other Todo", user_id: other_user.id})

      # load liveview
      {:ok, _lv, html} = live(conn, test_url())

      # page does not contain content belonging to other user
      refute html =~ other_todo.content
    end

    test "marks an incomplete todo as completed", %{conn: conn, todos: todos} do
      # get incomplete todo
      incomplete_todo =
        Enum.filter(todos, fn todo -> todo.is_completed == false end) |> Enum.at(0)

      # load liveview
      {:ok, lv, _html} = live(conn, test_url())

      # select and click the checkbox for the incomplete todo
      lv |> element("#is-completed-checkbox-#{incomplete_todo.id}") |> render_click()

      # re-fetch todo from the database
      now_completed_todo = Todos.get_todo!(incomplete_todo.id)

      # the todo is now completed
      assert now_completed_todo.is_completed
    end

    test "marks a completed todo as incomplete", %{conn: conn, todos: todos} do
      # get incomplete todo
      completed_todo = Enum.filter(todos, fn todo -> todo.is_completed == true end) |> Enum.at(0)

      # load liveview
      {:ok, lv, _html} = live(conn, test_url())

      # select and click the checkbox for the completed todo
      lv |> element("#is-completed-checkbox-#{completed_todo.id}") |> render_click()

      # re-fetch todo from the database
      now_incomplete_todo = Todos.get_todo!(completed_todo.id)

      # the todo is now completed
      refute now_incomplete_todo.is_completed
    end

    test "deletes a todo", %{conn: conn, todos: todos} do
      # randomly select one of the todos to delete
      random_index = (:rand.uniform() > 0.5 && 1) || 0
      todo_to_delete = todos |> Enum.at(random_index)

      # get initial object count
      initial_object_count = TodoList.Repo.Helpers.count(Todo)

      # load liveview
      {:ok, lv, html} = live(conn, test_url())

      # html contains expected content
      assert html =~ todo_to_delete.content

      # trigger the expected event
      html = form(lv, "#todo-delete-test-form", %{"id" => todo_to_delete.id}) |> render_submit()

      # html no longer contains deleted content
      refute html =~ todo_to_delete.content

      # object count has decreased by 1
      final_object_count = TodoList.Repo.Helpers.count(Todo)
      assert final_object_count == initial_object_count - 1

      # object no longer exists in the database
      assert_raise Ecto.NoResultsError, fn ->
        Todos.get_todo!(todo_to_delete.id)
      end
    end
  end
end
