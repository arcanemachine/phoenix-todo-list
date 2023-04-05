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
end
