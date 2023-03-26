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

  defmodule UserRegisterRequest do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "User registration request",
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
      required: [:email, :password],
      example: %{
        "user" => %{
          "email" => "user@example.com",
          "password" => "your_password"
        },
        "_action" => "registered"
      }
    })
  end

  defmodule UserRegisterResponse201 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      # description: "Created",
      type: :object,
      properties: %{
        user: %Schema{type: :object, description: "User ID and token"}
      },
      example: %{
        user: %{
          id: 123,
          token: "1234567890abcdefghijklmnopqABCDEFGHIJKLMNOP="
        }
      }
    })
  end

  defmodule UserRegisterResponse400 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      # description: "Bad Request",
      type: :object,
      properties: %{
        errors: %Schema{type: :object, description: "Errors"}
      },
      example: %{
        errors: %{
          email: ["has already been taken"],
          password: ["should be at least 8 character(s)"]
        }
      }
    })
  end
end
