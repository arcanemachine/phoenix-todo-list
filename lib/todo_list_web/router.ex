defmodule TodoListWeb.Router do
  use TodoListWeb, :router

  import TodoListWeb.Plug
  import TodoListWeb.UserAuth

  alias TodoListWeb.Accounts.Router, as: AccountsRouter
  alias TodoListWeb.Todos.Router, as: TodosRouter

  pipeline :api do
    plug :accepts, ["json"]
    plug :api_fetch_current_user
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoListWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  # BROWSER #
  # allow any user
  scope "/", TodoListWeb do
    pipe_through(:browser)

    get("/contact-us", PageController, :contact_us)
    get("/privacy-policy", PageController, :privacy_policy)
    get("/terms-of-use", PageController, :terms_of_use)

    live "/", HomeLive
    live "/component-showcase", ComponentShowcaseLive

    use AccountsRouter, :accounts_allow_any_user

    live_session :current_user,
      on_mount: [{TodoListWeb.UserAuth, :mount_current_user}] do
      use AccountsRouter, :accounts_allow_any_user_live_session
    end
  end

  # logout required
  scope "/", TodoListWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    use AccountsRouter, :accounts_logout_required

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TodoListWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      use AccountsRouter, :accounts_logout_required_live_session
    end
  end

  # login required
  scope "/", TodoListWeb do
    pipe_through([:browser, :require_authenticated_user])

    use AccountsRouter, :accounts_login_required
    use TodosRouter, :todos_login_required

    live_session :require_authenticated_user,
      on_mount: [{TodoListWeb.UserAuth, :ensure_authenticated}] do
      use AccountsRouter, :accounts_login_required_live_session
      use TodosRouter, :todos_login_required_live_session
    end
  end

  # require todo permissions
  scope "/", TodoListWeb do
    pipe_through([
      :browser,
      :require_authenticated_user,
      :fetch_todo,
      :require_todo_permissions
    ])

    use TodosRouter, :todos_require_todo_permissions
  end

  # API #
  # logout required
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_forbid_authenticated_user])

    use AccountsRouter, :accounts_api_logout_required
  end

  # login required
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user])

    use TodosRouter, :todos_api_login_required
  end

  # require user permissions
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user, :api_require_user_permissions])

    use AccountsRouter, :accounts_api_require_user_permissions
  end

  # require todo permissions
  scope "/api", TodoListWeb do
    pipe_through([
      :api,
      :api_require_authenticated_user,
      :fetch_todo,
      :api_require_todo_permissions
    ])

    use TodosRouter, :todos_api_require_todo_permissions
  end

  # DEV #
  if Application.compile_env(:todo_list, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TodoListWeb.Telemetry)
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
