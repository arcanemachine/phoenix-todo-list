defmodule TodoListWeb.Accounts.Router do
  # BROWSER #
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
      live("/users/reset-password", UserForgotPasswordLive, :new)
      live("/users/reset-password/:token", UserResetPasswordLive, :edit)
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
      live("/users/profile/confirm-email/:token", UserUpdateEmailLive, :confirm_email)
    end
  end

  # API #
  def accounts_api_logout_required do
    quote do
      resources("/users", Api.AccountsController, only: [:create])
      post("/users/login", Api.AccountsController, :login)
    end
  end

  def accounts_require_api_user_permissions do
    quote do
      resources("/users", Api.AccountsController, only: [:show, :update, :delete])
      get("/users/:id/check-token", Api.AccountsController, :check_token)
    end
  end

  @doc """
  When used, dispatch the appropriate function by calling the desired function name as an atom.

  ## Examples

      use AccountsRouter, :accounts_allow_any_user
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
