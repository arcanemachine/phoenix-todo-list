defmodule TodoListWeb.UserSessionController do
  use TodoListWeb, :controller

  alias TodoList.Accounts
  alias TodoListWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/profile")
    |> create(params, "Password updated successfully")
  end

  def create(conn, params) do
    create(conn, params, "Logged in successfully")
  end

  defp create(conn, %{"user" => user_params}, success_message) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, success_message)
      |> UserAuth.login_user(user, user_params)
    else
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/login")
    end
  end

  def show(conn, _params) do
    render(conn, :show, page_title: "Your Profile")
  end

  def settings(conn, _params) do
    conn |> render(:settings, layout: false, page_title: "Settings")
  end

  def update(conn, _params) do
    conn |> render(:update, page_title: "Manage Your Profile")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully")
    |> UserAuth.logout_user()
  end
end
