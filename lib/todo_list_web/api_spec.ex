defmodule TodoListWeb.ApiSpec do
  @moduledoc "Define the OpenAPI specification generator."

  alias OpenApiSpex.{Components, Info, OpenApi, Paths, SecurityScheme, Server}
  alias TodoListWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec() do
    %OpenApi{
      info: %Info{
        title: "TodoList",
        version: "0.0.0"
      },
      servers: [Server.from_endpoint(Endpoint)],
      paths: Paths.from_router(Router),
      components: %Components{
        securitySchemes: %{
          "authorization" => %SecurityScheme{type: "http", scheme: "bearer"}
        }
      },
      security: [
        %{"authorization" => []}
      ]
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
