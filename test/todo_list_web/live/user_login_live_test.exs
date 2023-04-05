defmodule TodoListWeb.UserLoginLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import Phoenix.LiveViewTest
  import TodoList.AccountsFixtures

  describe "Log in page" do
    test "renders log in page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/login")

      assert html =~ "Log in"
      assert html =~ "Register"
      assert html =~ "Forgot your password?"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> login_user(user_fixture())
        |> live(~p"/users/login")
        |> follow_redirect(conn, "/todos/live")

      assert {:ok, _conn} = result
    end
  end

  describe "user login" do
    test "redirects if user login with valid credentials", %{conn: conn} do
      password = "123456789abcd"
      user = user_fixture(%{password: password})

      {:ok, lv, _html} = live(conn, ~p"/users/login")

      form =
        form(lv, "#login_form", user: %{email: user.email, password: password, remember_me: true})

      conn = submit_form(form, conn)

      assert redirected_to(conn) == ~p"/todos/live"
    end

    test "redirects to login page with a flash error if there are no valid credentials", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/users/login")

      form =
        form(lv, "#login_form",
          user: %{email: "test@email.com", password: "123456", remember_me: true}
        )

      conn = submit_form(form, conn)

      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "Invalid email or password"

      assert redirected_to(conn) == "/users/login"
    end
  end

  describe "login navigation" do
    test "redirects to registration page when the Register button is clicked", %{conn: conn} do
      # load live view
      {:ok, lv, _html} = live(conn, ~p"/users/login")

      # click on selected link
      {:ok, conn} =
        lv
        |> element(~s|a:fl-contains("Register new account")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/users/register")

      # response contains expected text
      assert conn.resp_body =~ "Register New Account"
    end

    test "redirects to forgot password page when the Forgot Password button is clicked", %{
      conn: conn
    } do
      {:ok, lv, _html} = live(conn, ~p"/users/login")

      {:ok, conn} =
        lv
        |> element(~s{a:fl-contains('Forgot your password?')})
        |> render_click()
        |> follow_redirect(conn, ~p"/users/reset-password")

      assert conn.resp_body =~ "Forgot Your Password?"
    end
  end
end
