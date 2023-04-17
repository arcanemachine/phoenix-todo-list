defmodule TodoListWeb.UserRegistrationLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  import Phoenix.LiveViewTest
  import TodoList.AccountsFixtures

  describe "Registration page" do
    test "renders registration page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/users/register")

      assert html =~ "Register"
      assert html =~ "Log in"
    end

    test "redirects if already logged in", %{conn: conn} do
      result =
        conn
        |> login_user(user_fixture())
        |> live(~p"/users/register")
        |> follow_redirect(conn, "/todos/live")

      assert {:ok, _conn} = result
    end

    test "renders errors for invalid data", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      result =
        lv
        |> element("#registration_form")
        |> render_change(
          user: %{
            "email" => "with spaces",
            "password" => "2short",
            "password_confirmation" => "2short"
          }
        )

      assert result =~ "This is not a valid email address."

      assert result =~
               "Must have #{TodoList.Accounts.User.password_length_min()} or more character(s)"
    end
  end

  describe "register user" do
    test "creates account and logs the user in", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      email = unique_user_email()

      form =
        form(lv, "#registration_form",
          user:
            valid_user_attributes(
              email: email,
              password_confirmation: valid_user_password()
            )
        )

      render_submit(form)
      conn = follow_trigger_action(form, conn)

      assert redirected_to(conn) == ~p"/todos/live"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ "Your profile"
      assert response =~ "Log out"
    end

    test "renders errors for duplicated email", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      user = user_fixture(%{email: "test@email.com"})

      result =
        lv
        |> form("#registration_form",
          user: %{
            "email" => user.email,
            "password" => "valid_password",
            "password_confirmation" => "valid_password"
          }
        )
        |> render_submit()

      assert result =~ "This email address is already in use."
    end
  end

  describe "registration navigation" do
    test "redirects to login page when the 'login' link is clicked", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/register")

      {:ok, conn} =
        lv
        |> element(~s|a:fl-contains("Login to an existing account")|)
        |> render_click()
        |> follow_redirect(conn, ~p"/users/login")

      assert conn.resp_body =~ "Login"
    end
  end
end
