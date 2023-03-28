defmodule TodoListWeb.Schemas do
  @moduledoc "OpenAPI schema definitions."

  require OpenApiSpex
  alias OpenApiSpex.Schema

  alias TodoListWeb.Schemas

  # MISC #
  # responses
  defmodule GenericResponses do
    @moduledoc "Miscellaneous responses that are used more than once."

    def response_400(),
      do: {"Bad Request", "application/json", Schemas.Response400}

    def response_401_authentication_required(),
      do:
        {"Unauthorized: Authentication required", "application/json",
         Schemas.Response401AuthenticationRequired}

    def response_403(),
      do: {"Forbidden", "application/json", Schemas.Response403}
  end

  defmodule Response400 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Bad Request",
      type: :object,
      properties: %{errors: %Schema{type: :object}},
      example: %{errors: %{detail: "Bad Request"}}
    })
  end

  defmodule Response401AuthenticationRequired do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Unauthorized: Authentication required",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "This endpoint is only accessible to authenticated users."}
    })
  end

  defmodule Response403 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Forbidden",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "Forbidden"}
    })
  end

  # ACCOUNTS #
  # register/login
  defmodule UserAuthSchema do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "The parameters required when registering or logging in a user.",
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
      description: "New user registration",
      type: :object,
      properties: %{user: %Schema{type: :object, items: UserAuthSchema}},
      required: [:user]
    })
  end

  defmodule UserAuthRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "User registration/login request",
      type: :object,
      properties: %{user: %Schema{type: :object, items: UserAuthSchema}},
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

    OpenApiSpex.schema(%{
      description: "Created",
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

  defmodule UserRegisterResponse400 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Bad Request",
      type: :object,
      properties: %{
        errors: %Schema{type: :object, description: "Errors"}
      },
      example: %{
        errors: %{
          email: ["This is not a valid email address.", "has already been taken"],
          password: [
            "should be at least #{TodoList.Accounts.User.password_length_min()} character(s)"
          ]
        }
      }
    })
  end

  defmodule UserLoginResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{user: %Schema{type: :object, description: "User ID and token"}},
      example: %{
        "user" => %{"id" => 123, "token" => "1234567890abcdefghijklmnopqABCDEFGHIJKLMNOP="}
      }
    })
  end

  defmodule UserLoginResponse401 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Unauthorized: Invalid credentials",
      type: :object,
      properties: %{message: %Schema{type: :string}},
      example: %{message: "Invalid email or password"}
    })
  end

  # check_token
  defmodule UserCheckTokenResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :boolean,
      example: true
    })
  end

  # show
  defmodule UserShowResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{
        data: %Schema{type: :object, description: "User data"}
      },
      example: %{data: %{email: "user@example.com", id: 123}}
    })
  end

  # update
  defmodule UserUpdateRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "User update request",
      type: :object,
      properties: %{
        current_password: %Schema{
          type: :string,
          description: "Current password",
          format: :password
        },
        password: %Schema{
          type: :string,
          description: "New password",
          format: :password,
          minLength: TodoList.Accounts.User.password_length_min()
        }
      },
      example: %{
        data: %{current_password: "password", password: "new_password"}
      }
    })
  end

  defmodule UserUpdateResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{
        message: %Schema{type: :string}
      },
      example: %{
        message: "Password changed successfully. All sessions for this user have been logged out."
      }
    })
  end

  defmodule UserUpdateResponse400 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "Bad Request",
      type: :object,
      properties: %{
        errors: %Schema{type: :object, description: "Errors"}
      },
      example: %{
        errors: %{
          password: [
            "should be at least #{TodoList.Accounts.User.password_length_min()} character(s)",
            "This is not your current password."
          ]
        }
      }
    })
  end

  # logout
  defmodule UserLogoutResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{
        message: %Schema{type: :string}
      },
      example: %{
        message: "Logged out successfully"
      }
    })
  end

  # credo:disable-for-next-line
  # TODOS #
  defmodule TodoSchema do
    @moduledoc false

    OpenApiSpex.schema(%{
      type: :object,
      properties: %{
        content: %Schema{type: :string},
        id: %Schema{type: :integer},
        is_completed: %Schema{type: :boolean}
      }
    })
  end

  # index
  defmodule TodoListResponse200 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{
        data: %Schema{type: :list, items: TodoSchema}
      },
      example: %{
        data: [
          %{
            content: "First todo item",
            id: 123,
            is_completed: true
          },
          %{
            content: "Second todo item",
            id: 456,
            is_completed: false
          }
        ]
      }
    })
  end

  # create
  defmodule TodoCreateRequest do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "The parameters required when creating a new todo item.",
      type: :object,
      properties: %{
        todo: %Schema{type: :object, items: TodoSchema}
      },
      required: [:content],
      example: %{
        todo: %{

        content: "Todo item content",
        is_completed: false
      }
      }
    })
  end

  defmodule TodoCreateResponse201 do
    @moduledoc false

    OpenApiSpex.schema(%{
      description: "OK",
      type: :object,
      properties: %{
        data: %Schema{type: :object, items: TodoSchema}
      },
      example: %{
        data: %{
          content: "Todo item content",
          id: 123,
          is_completed: false
        }
      }
    })
  end
end
