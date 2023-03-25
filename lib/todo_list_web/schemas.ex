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
      description: "User registration parameters",
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
        "email" => "user@example.com",
        "password" => "your_password"
      }
    })
  end

  defmodule UserRegisterResponse200 do
    @moduledoc false

    require OpenApiSpex

    OpenApiSpex.schema(%{
      description: "Registration successful",
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
end
