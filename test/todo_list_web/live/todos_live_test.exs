defmodule TodoListWeb.TodosLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import Phoenix.LiveViewTest
  import TodoList.TodosFixtures
  import TodoList.AccountsFixtures

  def test_url, do: ~p"/todos/live"

  describe "Page" do
    test "renders expected template", %{conn: conn} do
      # login user and make request
      {:ok, _lv, html} = conn |> login_user(user_fixture()) |> live(test_url())

      # response contains expected text
      assert html =~ "Live Todo List"
    end

    test "redirects unauthenticated user to login page", %{conn: conn} do
      # make request
      assert {:error, redirect} = live(conn, ~p"/todos/live")

      # redirects to expected path and has expected flash message
      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/login"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "Todo form" do
    test "creates a new todo" do
    end

    test "updates an existing todo" do
    end
  end

  describe "Todo list" do
    test "shows all todos" do
    end

    test "marks an incomplete todo as completed" do
    end

    test "marks a completed todo as incomplete" do
    end

    test "deletes a todo" do
    end
  end

  describe "Presence" do
    test "correctly shows when a single window is displaying the list" do
    end

    test "correctly shows when two windows are displaying the list" do
    end
  end

  describe "PubSub" do
    test "shows the correct message when the current window creates a todo" do
    end

    test "shows the correct message when a different window creates a todo" do
    end

    # repeat for update, toggle completion, delete...
  end
end
