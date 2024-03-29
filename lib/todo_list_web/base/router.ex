defmodule TodoListWeb.Base.Router do
  # BROWSER #
  def base_allow_any_user do
    quote do
      get("/debug", BaseController, :debug)
      get("/contact-us", BaseController, :contact_us)
      get("/privacy-policy", BaseController, :privacy_policy)
      get("/terms-of-use", BaseController, :terms_of_use)

      live("/", HomeLive)
      live("/component-showcase", ComponentShowcaseLive)
    end
  end

  # API #
  def base_api_openapi do
    quote do
      get("/", OpenApiSpex.Plug.RenderSpec, [])
      get("/swagger-ui", OpenApiSpex.Plug.SwaggerUI, path: "/api")
    end
  end

  # DEV #
  def base_dev do
    quote do
      if Application.compile_env(:todo_list, :dev_routes) do
        import Phoenix.LiveDashboard.Router

        scope "/dev" do
          pipe_through(:browser)

          live_dashboard("/dashboard", metrics: TodoListWeb.Telemetry)
          forward "/mailbox", Plug.Swoosh.MailboxPreview
        end
      end
    end
  end

  @doc """
  When used, dispatch the appropriate function by calling the desired function name as an atom.

  ## Examples

      use BaseRouter, :base_allow_any_user
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
