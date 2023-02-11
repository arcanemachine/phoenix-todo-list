defmodule TodoListWeb.UserSessionController do
  use TodoListWeb, :controller

  alias TodoList.Accounts
  alias TodoListWeb.UserAuth

  def create(conn, %{"_action" => "registered"} = params) do
    create(conn, params, "Account created successfully. You are now logged in.")
  end

  def create(conn, %{"_action" => "password_updated"} = params) do
    conn
    |> put_session(:user_return_to, ~p"/users/settings")
    |> create(params, "Password updated successfully!")
  end

  def create(conn, params) do
    create(conn, params, "You are now logged in.")
  end

  defp create(conn, %{"user" => user_params}, info) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn
      |> put_flash(:info, info)
      |> UserAuth.log_in_user(user, user_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      conn
      |> put_flash(:error, "Invalid email or password")
      |> put_flash(:email, String.slice(email, 0, 160))
      |> redirect(to: ~p"/users/log_in")
    end
  end

  def show(conn, _params) do
    render(conn, :show, page_title: "Your Profile")
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You are now logged out.")
    |> UserAuth.log_out_user()
  end
end
