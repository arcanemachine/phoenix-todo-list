defmodule TodoListWeb.Api.AccountsController do
  use TodoListWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias TodoList.Accounts
  alias TodoListWeb.Schemas
  alias TodoListWeb.Schemas.GenericResponses
  alias TodoListWeb.UserAuth

  tags ["users"]

  operation :create,
    summary: "Register new user",
    request_body:
      {"User registration/login request", "application/json", Schemas.UserAuthRequest},
    responses: %{
      201 =>
        {"Created", "application/json", Schemas.UserRegisterResponse201,
         headers: %{
           "location" => %OpenApiSpex.Header{
             schema: %{
               type: :string,
               description: "The location of the user's profile data.",
               example: "/users/:id/detail"
             }
           }
         }},
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
      401 =>
        {"Unauthorized: Invalid credentials", "application/json", Schemas.UserLoginResponse401}
    }

  @doc "Login - Confirm authentication credentials and return a session token."
  def login(
        conn,
        %{"user" => %{"email" => email, "password" => password}} = _params,
        status \\ :ok
      ) do
    if user = Accounts.get_user_by_email_and_password(email, password) do
      conn |> UserAuth.login_api_user(user, status)
    else
      conn
      |> put_status(:unauthorized)
      |> json(%{message: "Invalid email or password"})
    end
  end

  operation :check_token,
    summary: "Check if user token is valid",
    security: [%{"bearerAuth" => []}],
    parameters: [
      id: [in: :path, description: "User ID", type: :integer, example: 123]
    ],
    responses: %{
      200 => {"OK", "application/json", Schemas.UserCheckTokenResponse200},
      401 => GenericResponses.response_401_authentication_required(),
      403 => GenericResponses.response_403()
    }

  @doc """
  Ensure that a user is using a valid session token.

  Will always return `true` since unauthorized users should be rejected further up
  in the pipeline.
  """
  def check_token(conn, _params) do
    conn |> json(true)
  end

  operation :show,
    summary: "Show user detail",
    security: [%{"bearerAuth" => []}],
    parameters: [
      id: [in: :path, description: "User ID", type: :integer, example: 123]
    ],
    responses: %{
      200 => {"OK", "application/json", Schemas.UserShowResponse200},
      401 => GenericResponses.response_401_authentication_required(),
      403 => GenericResponses.response_403()
    }

  @doc "Show user detail"
  def show(conn, _params) do
    render(conn, :show, user: conn.assigns.current_user)
  end

  operation :update,
    summary: "Change user password",
    security: [%{"bearerAuth" => []}],
    parameters: [
      id: [in: :path, description: "User ID", type: :integer, example: 123]
    ],
    request_body: {"Change user password request", "application/json", Schemas.UserUpdateRequest},
    responses: %{
      200 => {"OK", "application/json", Schemas.UserUpdateResponse200},
      400 => {"Bad Request", "application/json", Schemas.UserUpdateResponse400},
      401 => GenericResponses.response_401_authentication_required(),
      403 => GenericResponses.response_403()
    }

  @doc "Change user password"
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

  operation :delete,
    summary: "User logout",
    security: [%{"bearerAuth" => []}],
    parameters: [
      id: [in: :path, description: "User ID", type: :integer, example: 123]
    ],
    responses: %{
      200 => {"OK", "application/json", Schemas.UserLogoutResponse200},
      401 => GenericResponses.response_401_authentication_required(),
      403 => GenericResponses.response_403()
    }

  @doc "Logout - Delete user session token."
  def delete(conn, _params) do
    conn |> UserAuth.logout_api_user()
  end
end
