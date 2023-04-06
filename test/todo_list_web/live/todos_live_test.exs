defmodule TodoListWeb.TodosLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import Ecto.Query
  import Phoenix.LiveViewTest
  import TodoList.TodosFixtures
  import TodoList.AccountsFixtures

  alias TodoList.Repo
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
      result = form(lv, "#todo-create-form", %{"content" => todo_content}) |> render_submit()

      # object count increased by 1
      final_object_count = TodoList.Repo.Helpers.count(Todo)
      assert final_object_count == initial_object_count + 1

      # new object has been created
      new_todo = Todo |> last(:inserted_at) |> Repo.one()

      # page renders expected object content
      assert result =~ new_todo.content
    end

    @tag fixme: true
    test "updates an existing todo", %{conn: conn, user: user} do
      todo = todo_fixture(%{user_id: user.id})
      updated_todo_content = "updated todo content"

      # get initial object count
      initial_object_count = TodoList.Repo.Helpers.count(Todo)

      # load liveview
      {:ok, lv, _html} = live(conn, test_url())

      # build and submit form
      result =
        form(lv, "#todo-update-form", %{"id" => "#{todo.id}", "content" => updated_todo_content})
        |> render_submit()

      # object count has not changed
      final_object_count = TodoList.Repo.Helpers.count(Todo)
      assert final_object_count == initial_object_count

      # existing object has been updated with expected values
      updated_todo = Todo |> last(:inserted_at) |> Repo.one()
      assert updated_todo.content == updated_todo_content

      # page renders expected object content
      assert result =~ updated_todo_content
    end
  end

  # describe "Todo list" do
  #   test "shows all todos" do
  #   end

  #   test "marks an incomplete todo as completed", %{conn: conn} do
  #   end

  #   test "marks a completed todo as incomplete", %{conn: conn} do
  #   end

  #   test "deletes a todo", %{conn: conn} do
  #   end
  # end

  # describe "Presence" do
  #   test "correctly shows when a single window is displaying the list", %{conn: conn} do
  #   end

  #   test "correctly shows when two windows are displaying the list", %{conn: conn} do
  #   end
  # end

  # describe "PubSub" do
  #   test "shows the correct message when the current window creates a todo", %{conn: conn} do
  #   end

  #   test "shows the correct message when a different window creates a todo", %{conn: conn} do
  #   end

  #   # repeat for update, toggle completion, delete...
  # end
end
