defmodule TodoListWeb.ApiSpec do
  @moduledoc "Define the OpenAPI specification generator."

  alias OpenApiSpex.{Components, Info, OpenApi, Paths, SecurityScheme, Server}
  alias TodoListWeb.{Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec() do
    %OpenApi{
      info: %Info{
        title: "Phoenix Todo List",
        version: "0.1.0"
      },
      servers: [%Server{url: "https://phoenix-todo-list.nicholasmoen.com/"}],
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "bearerAuth" => %SecurityScheme{
            type: "http",
            scheme: "bearer",
            in: "header",
            name: "authorization",
            description: "Bearer authentication with required prefix 'Bearer'"
          }
        }
      }
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
