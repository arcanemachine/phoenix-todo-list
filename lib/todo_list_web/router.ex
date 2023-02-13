defmodule TodoListWeb.Router do
  use TodoListWeb, :router

  import TodoListWeb.Plug
  import TodoListWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TodoListWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :api_fetch_current_user
  end

  scope "/", TodoListWeb do
    pipe_through(:browser)

    # get "/", PageController, :home
    live "/", HomeLive
    live "/component-showcase", ComponentShowcaseLive
  end

  # forbid authenticated user
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_forbid_authenticated_user])

    resources "/users", Api.UserSessionController, only: [:create]
  end

  # require authenticated user
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user])

    resources "/todos", Api.TodoController, only: [:index, :create]
  end

  # user ID must match todo.user_id
  scope "/api", TodoListWeb do
    pipe_through([
      :api,
      :api_require_authenticated_user,
      :fetch_todo,
      :api_require_todo_permissions
    ])

    resources "/todos", Api.TodoController, except: [:index, :create]
  end

  # user ID must match :id
  scope "/api", TodoListWeb do
    pipe_through([:api, :api_require_authenticated_user, :api_require_user_permissions])

    resources "/users", Api.UserSessionController, only: [:show, :update, :delete]
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todo_list, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through(:browser)

      live_dashboard("/dashboard", metrics: TodoListWeb.Telemetry)
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  # auth
  scope "/", TodoListWeb do
    pipe_through([:browser])

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{TodoListWeb.UserAuth, :mount_current_user}] do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
      live("/users/log_out", UserLogoutLive, :new)
    end
  end

  # auth - logout required
  scope "/", TodoListWeb do
    pipe_through([:browser, :redirect_if_user_is_authenticated])

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TodoListWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/log_in", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end

    post "/users/log_in", UserSessionController, :create
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
      live("/users/settings", UserSettingsLive, :edit)
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
