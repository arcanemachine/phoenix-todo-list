defmodule TodoListWeb.Api.UserSessionController do
  use TodoListWeb, :controller

  alias TodoList.Accounts
  alias TodoListWeb.UserAuth

  @doc "Register - Create a new user and return authentication token."
  def create(conn, %{"_action" => "registered", "user" => user_params} = _params) do
    # register the user
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # return status 201 and user token
        conn
        |> put_resp_header("location", ~p"/api/users/#{user}")
        |> create(%{"user" => user_params}, :created)

      {:error, changeset} ->
        # return errors
        json_response = TodoListWeb.Helpers.Ecto.changeset_errors_to_json(changeset)
        conn |> put_status(:bad_request) |> json(%{errors: json_response})
    end
  end

  @doc "Login - Confirm authentication credentials and return a session token."
  def create(conn, %{"user" => user_params} = _params, status \\ :ok) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn |> UserAuth.api_log_in_user(user, status)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Invalid email or password"})
    end
  end

  @doc """
  Check token - Ensure that session token is valid.

  Will always return `true` since unauthenticated users should be rejected
  further up in the pipeline.
  """
  def show(conn, %{"_action" => "check_token"} = _params) do
    conn |> json(true)
  end

  def show(conn, _params) do
    render(conn, :show, user: conn.assigns.current_user)
  end

  @doc "Update - Change user password"
  def update(
        conn,
        %{"current_password" => current_password, "password" => password} = _params
      ) do
    case Accounts.update_user_password(conn.assigns.current_user, current_password, %{
           password: password
         }) do
      {:ok, _user} ->
        conn
        |> json(%{
          message:
            "Password changed successfully. All sessions for this user have been logged out."
        })

      {:error, changeset} ->
        # parse and return errors
        json_response = TodoListWeb.Helpers.Ecto.changeset_errors_to_json(changeset)
        conn |> put_status(:bad_request) |> json(%{errors: json_response})
    end
  end

  @doc "Logout - Delete user session token."
  def delete(conn, _params) do
    conn |> UserAuth.api_log_out_user()
  end
end
