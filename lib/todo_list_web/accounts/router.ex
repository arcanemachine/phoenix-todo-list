defmodule TodoListWeb.Accounts.Router do
  # browser
  def accounts_allow_any_user do
    quote do
      get("/users", AccountsController, :root)
      delete("/users/logout", UserSessionController, :delete)
    end
  end

  def accounts_allow_any_user_live_session do
    quote do
      live("/users/confirm/:token", UserConfirmationLive, :edit)
      live("/users/confirm", UserConfirmationInstructionsLive, :new)
      live("/users/logout", UserLogoutLive, :new)
    end
  end

  def accounts_logout_required do
    quote do
      post("/users/login", UserSessionController, :create)
    end
  end

  def accounts_logout_required_live_session do
    quote do
      live("/users/register", UserRegistrationLive, :new)
      live("/users/login", UserLoginLive, :new)
      live("/users/reset_password", UserForgotPasswordLive, :new)
      live("/users/reset_password/:token", UserResetPasswordLive, :edit)
    end
  end

  def accounts_login_required do
    quote do
      delete("/users/profile/delete", AccountsController, :delete)
      get("/users/profile", UserSessionController, :show)
      get("/users/profile/update", UserSessionController, :update)
    end
  end

  def accounts_login_required_live_session do
    quote do
      live("/users/profile/delete", UserDeleteLive)
      live("/users/profile/update/email", UserUpdateEmailLive, :edit)
      live("/users/profile/update/password", UserUpdatePasswordLive, :edit)
      live("/users/profile/confirm_email/:token", UserUpdateEmailLive, :confirm_email)
    end
  end

  # api
  def accounts_api_logout_required do
    quote do
      resources "/users", Api.UserSessionController, only: [:create]
    end
  end

  def accounts_api_require_user_permissions do
    quote do
      resources "/users", Api.UserSessionController, only: [:show, :update, :delete]
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
