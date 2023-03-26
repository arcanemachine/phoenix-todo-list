defmodule TodoListWeb.Schemas do
  @moduledoc "OpenAPI schema definitions."

  require OpenApiSpex
  alias OpenApiSpex.Schema

  # defmodule Todo do
  #   @moduledoc "OpenAPI schema definition for the Todo object."

  #   OpenApiSpex.schema(%{
  #     title: "Todo",
  #     description: "A todo list item.",
  #     type: :object,
  #     properties: %{
  #       id: %Schema{type: :integer, description: "Todo ID"},
  #       content: %Schema{type: :string, description: "Todo content"},
  #       is_completed: %Schema{type: :boolean, description: "Todo completion status"}
  #     },
  #     required: []
  #   })
  # end

  # ACCOUNTS #
  # register/login
  defmodule UserAuthRequestUser do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "'user' parameters required when registering or logging in a new User.",
      type: :object,
      properties: %{
        email: %Schema{type: :string, description: "Email address", format: :email},
        password: %Schema{
          type: :string,
          description: "Password",
          format: :password,
          minLength: TodoList.Accounts.User.password_length_min()
        }
      },
      required: [:email, :password]
    })
  end

  defmodule UserAuthResponseUser do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "User registration/authentication response",
      type: :object,
      properties: %{
        id: %Schema{type: :integer, description: "User ID"},
        token: %Schema{type: :string, description: "User auth token"}
      }
    })
  end

  defmodule UserAuth do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Request body properties for new user registration",
      type: :object,
      properties: %{user: %Schema{type: :object, items: UserAuthRequestUser}},
      required: [:user]
    })
  end

  defmodule UserAuthRequest do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User registration/login request",
      type: :object,
      properties: %{user: %Schema{type: :object, items: UserAuthRequestUser}},
      required: [:user],
      example: %{
        "user" => %{
          "email" => "user@example.com",
          "password" => "your_password"
        }
      }
    })
  end

  defmodule UserRegisterResponse201 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Created",
      type: :object,
      headers: %{"location" => "/api/users/{id}"},
      properties: %{user: %Schema{type: :object, description: "User ID and token"}},
      example: %{
        "user" => %{"id" => 123, "token" => "1234567890abcdefghijklmnopqABCDEFGHIJKLMNOP="}
      }
    })
  end

  defmodule UserRegisterResponse400 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Bad Request",
      type: :object,
      properties: %{
        errors: %Schema{type: :object, description: "Errors"}
      },
      example: %{
        errors: %{
          email: ["This is not a valid email address.", "has already been taken"],
          password: ["should be at least 8 character(s)"]
        }
      }
    })
  end

  defmodule UserLoginResponse200 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{user: %Schema{type: :object, description: "User ID and token"}},
      example: %{
        "user" => %{
          "id" => 123,
          "token" => "1234567890abcdefghijklmnopqABCDEFGHIJKLMNOP="
        }
      }
    })
  end

  defmodule UserLoginResponse401 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Unauthorized",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "Invalid email or password"}
    })
  end

  # check_token
  defmodule UserCheckTokenRequest do
    @moduledoc false

    require OpenApiSpex

    # TO-DO: fix when open_api_spex enables null request body example
    OpenApiSpex.schema(%{
      description: "User check token request (REQUEST BODY MUST BE EMPTY)"
      # description: "User check token request"
      # type: :null,
      # allowEmptyValue: true,
      # nullable: true,
      # default: "",
      # example: ""
    })
  end

  defmodule UserCheckTokenResponse200 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "OK",
      type: :boolean,
      example: true
    })
  end

  defmodule UserCheckTokenResponse401 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Unauthorized",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "This endpoint is only accessible to authenticated users."}
    })
  end

  defmodule UserCheckTokenResponse403 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Forbidden",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "Forbidden"}
    })
  end
end
