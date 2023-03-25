# defmodule TodoListWeb.Schemas do
#   @moduledoc "OpenAPI schema definitions."
#
#   require OpenApiSpex
#   alias OpenApiSpex.Schema
#
#   defmodule Todo do
#     @moduledoc "OpenAPI schema definition for the Todo object."
#
#     OpenApiSpex.schema(%{
#       title: "Todo",
#       description: "A todo list item.",
#       type: :object,
#       properties: %{
#         id: %Schema{type: :integer, description: "Todo ID"},
#         content: %Schema{type: :string, description: "Todo content"},
#         is_completed: %Schema{type: :boolean, description: "Todo completion status"}
#       },
#       required: []
#     })
#   end
#
#   # defmodule User do
#   #   @moduledoc "OpenAPI schema definition for the User object."
#   #   OpenApiSpex.schema(%{
#   #     title: "User",
#   #     description: "A user of the app.",
#   #     type: :object,
#   #     properties: %{
#   #       id: %Schema{type: :integer, description: "User ID"},
#   #       email: %Schema{type: :string, description: "Email address", format: :email},
#   #     },
#   #     required: [:id, :email],
#   #     example: %{
#   #       "id" => 123,
#   #       "email" => "user@example.com",
#   #       "password" => "your_password"
#   #     }
#   #   })
#   # end
# end
