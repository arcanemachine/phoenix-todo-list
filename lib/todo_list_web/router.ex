defmodule TodoListWeb.Router do
  use TodoListWeb, :router

  import TodoListWeb.Plug
  import TodoListWeb.UserAuth

  # API #
  pipeline :api do
    plug :accepts, ["json"]
    plug :api_fetch_current_user
  end

  scope "/", TodoListWeb do
    pipe_through(:browser)

    live "/", HomeLive
    live "/component-showcase", ComponentShowcaseLive
  end

  # api - forbid authenticated user
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_forbid_authenticated_user])

    resources "/users", Api.UserSessionController, only: [:create]
  end

  # api - require authenticated user
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user])

    resources "/todos", Api.TodoController, only: [:index, :create]
  end

  # api - user ID must match todo.user_id
  scope "/api", TodoListWeb do
    pipe_through([
      :api,
      :api_require_authenticated_user,
      :fetch_todo,
      :api_require_todo_permissions
    ])

    resources "/todos", Api.TodoController, except: [:index, :create]
  end

  # api - user ID must match :id parameter
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user, :api_require_user_permissions])

    resources "/users", Api.UserSessionController, only: [:show, :update, :delete]
  end

  # BROWSER #
  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoListWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  if Application.compile_env(:todo_list, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TodoListWeb.Telemetry)
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # no auth requirements
  scope "/", TodoListWeb do
    pipe_through([:browser])

    get("/contact-us", PageController, :contact_us)
    get("/privacy-policy", PageController, :privacy_policy)
    get("/terms-of-use", PageController, :terms_of_use)

    # users
    delete "/users/logout", UserSessionController, :delete
    get "/users/settings", UserSessionController, :settings

    live_session :current_user,
      on_mount: [{TodoListWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
      live("/users/logout", UserLogoutLive, :new)
    end
  end

  # auth - logout required
  scope "/", TodoListWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TodoListWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/login", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post "/users/login", UserSessionController, :create
  end

  # login required
  scope "/", TodoListWeb do
    pipe_through([:browser, :require_authenticated_user])

    # credo:disable-for-next-line
    # todos
    resources("/todos", TodoController, only: [:index, :new, :create])

    # users
    get "/users/profile", UserSessionController, :show

    live_session :require_authenticated_user,
      on_mount: [{TodoListWeb.UserAuth, :ensure_authenticated}] do
      # credo:disable-for-next-line
      # todos
      live "/todos/live", TodosLive

      # users
      live("/users/profile/update", UserSettingsLive, :edit)
      live("/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email)
    end
  end

  # credo:disable-for-next-line
  # todo permissions required
  scope "/", TodoListWeb do
    pipe_through([
      :browser,
      :require_authenticated_user,
      :fetch_todo,
      :require_todo_permissions
    ])

    resources("/todos", TodoController, only: [:show, :edit, :update, :delete])
  end
end
