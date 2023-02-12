defmodule TodoListWeb.Api.UserSessionController do
  use TodoListWeb, :controller

  alias TodoList.Accounts
  alias TodoListWeb.UserAuth

  # def create(conn, %{"_action" => "registered"} = params) do
  #   # create(conn, params, "Account created successfully!")
  # end

  # def create(conn, %{"_action" => "password_updated"} = params) do
  #   conn
  #   |> put_session(:user_return_to, ~p"/users/settings")
  #   |> create(params, "Password updated successfully!")
  # end

  # def create(conn, params) do
  #   create(conn, params, "Welcome back!")
  # end

  # defp create(conn, %{"user" => user_params}, info) do
  @doc "Log in - Confirm authentication credentials and return a session token."
  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn |> UserAuth.api_log_in_user(user)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Invalid email or password"})
    end
  end

  @doc """
  Ensure that session token is valid.

  Will always return `true` since unauthenticated users will be rejected
  further up in the pipeline.
  """
  def show(conn, _params) do
    conn |> json(true)
  end

  @doc "Log out the user by deleting the session token."
  def delete(conn, _params) do
    conn |> UserAuth.api_log_out_user()
  end
end
