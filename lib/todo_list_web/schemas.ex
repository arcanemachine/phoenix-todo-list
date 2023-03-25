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
      title: "User",
      description: "A user of the app.",
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

  defmodule UserRegisterResponse do
    @moduledoc "OpenAPI schema definition for the UserResponse object."

    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "UserResponse",
      description: "Response schema for single User",
      type: :object,
      properties: %{
        data: UserRegisterRequest
      },
      example: %{
        "data" => %{
          "id" => 123,
          email: "user@example.com"
        }
      }
    })
  end
end
