defmodule TodoListWeb.UserUpdatePasswordLiveTest do
  @moduledoc false

  use TodoListWeb.ConnCase

  alias TodoList.Accounts
  import Phoenix.LiveViewTest
  import TodoList.AccountsFixtures

  describe "page" do
    test "renders settings page", %{conn: conn} do
      {:ok, _lv, html} =
        conn
        |> login_user(user_fixture())
        |> live(~p"/users/profile/update/password")

      assert html =~ "Update Password"
    end

    test "redirects if user is not logged in", %{conn: conn} do
      assert {:error, redirect} = live(conn, ~p"/users/profile/update/password")

      assert {:redirect, %{to: path, flash: flash}} = redirect
      assert path == ~p"/users/login"
      assert %{"error" => "You must log in to access this page."} = flash
    end
  end

  describe "update password form" do
    setup %{conn: conn} do
      password = valid_user_password()
      user = user_fixture(%{password: password})
      %{conn: login_user(conn, user), user: user, password: password}
    end

    test "updates the user password", %{conn: conn, user: user, password: password} do
      new_password = valid_user_password()

      {:ok, lv, _html} = live(conn, ~p"/users/profile/update/password")

      form_input = %{
        "current_password" => password,
        "user" => %{
          "email" => user.email,
          "password" => new_password,
          "password_confirmation" => new_password
        }
      }

      form = form(lv, "#password_form", form_input)

      render_submit(form)

      new_password_conn = follow_trigger_action(form, conn)

      assert redirected_to(new_password_conn) == ~p"/users/profile"

      assert get_session(new_password_conn, :user_token) != get_session(conn, :user_token)

      assert Phoenix.Flash.get(new_password_conn.assigns.flash, :info) =~
               "Password updated successfully"

      assert Accounts.get_user_by_email_and_password(user.email, new_password)
    end

    test "renders errors with invalid data (phx-change)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/profile/update/password")

      result =
        lv
        |> element("#password_form")
        |> render_change(%{
          "current_password" => "invalid",
          "user" => %{
            "password" => "2short",
            "password_confirmation" => "does not match"
          }
        })

      # assert result =~ "Update Password"
      assert result =~
               "Must have #{TodoList.Accounts.User.password_length_min()} or more character(s)"

      assert result =~ "The passwords do not match."
    end

    test "renders errors with invalid data (phx-submit)", %{conn: conn} do
      {:ok, lv, _html} = live(conn, ~p"/users/profile/update/password")

      result =
        lv
        |> form("#password_form", %{
          "current_password" => "invalid",
          "user" => %{
            "password" => "2short",
            "password_confirmation" => "does not match"
          }
        })
        |> render_submit()

      # assert result =~ "Update Password"
      assert result =~
               "Must have #{TodoList.Accounts.User.password_length_min()} or more character(s)"

      assert result =~ "The passwords do not match."
    end
  end

  test "redirects if user is not logged in" do
    conn = build_conn()
    {:error, redirect} = live(conn, ~p"/users/profile/update/password")
    assert {:redirect, %{to: path, flash: flash}} = redirect
    assert path == ~p"/users/login"
    assert %{"error" => message} = flash
    assert message == "You must log in to access this page."
  end
end
