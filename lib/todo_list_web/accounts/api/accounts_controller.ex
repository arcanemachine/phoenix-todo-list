defmodule TodoListWeb.Api.AccountsController do
  use TodoListWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias TodoList.Accounts
  alias TodoListWeb.Schemas
  alias TodoListWeb.UserAuth

  tags ["users"]
  # security [%{}, %{"bearerAuth" => []}]

  operation :create,
    summary: "Register new user",
    request_body:
      {"User registration/login request", "application/json", Schemas.UserAuthRequest},
    responses: %{
      201 => {"Created", "application/json", Schemas.UserRegisterResponse201},
      400 => {"Bad Request", "application/json", Schemas.UserRegisterResponse400}
    }

  @doc "Register - Create a new user and return authentication token."
  def create(conn, %{"user" => user_params} = _params) do
    # register the user
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        # return status 201 and user token
        conn
        |> put_resp_header("location", ~p"/api/users/#{user.id}")
        |> login(%{"user" => user_params}, :created)

      {:error, changeset} ->
        # return errors
        json_response = TodoListWeb.Helpers.Ecto.changeset_errors_to_json(changeset)
        conn |> put_status(:bad_request) |> json(%{errors: json_response})
    end
  end

  operation :login,
    summary: "Login user",
    request_body:
      {"User registration/login request", "application/json", Schemas.UserAuthRequest},
    responses: %{
      200 => {"OK", "application/json", Schemas.UserLoginResponse200},
      401 => {"Unauthorized", "application/json", Schemas.UserLoginResponse401}
    }

  @doc "Login - Confirm authentication credentials and return a session token."
  def login(conn, %{"user" => user_params} = _params, status \\ :ok) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn |> UserAuth.api_login_user(user, status)
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
    conn |> UserAuth.api_logout_user()
  end
end
