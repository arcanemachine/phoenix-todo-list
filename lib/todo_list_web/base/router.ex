defmodule TodoListWeb.Base.Router do
  # BROWSER #
  def base_allow_any_user do
    quote do
      get("/contact-us", PageController, :contact_us)
      get("/privacy-policy", PageController, :privacy_policy)
      get("/terms-of-use", PageController, :terms_of_use)

      live("/", HomeLive)
      live("/component-showcase", ComponentShowcaseLive)
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
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
