defmodule TodoListWeb.UserResetPasswordLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def render(assigns) do
    ~H"""
    <div :if={@changeset.action == :insert}>
      <.form_error_alert />
    </div>

    <.simple_form
      :let={f}
      for={@changeset}
      id="reset_password_form"
      phx-submit="reset_password"
      phx-change="validate"
    >
      <.input
        field={{f, :password}}
        type="password"
        label="New password"
        minlength={TodoList.Accounts.User.password_length_min()}
        required
      />
      <.input
        field={{f, :password_confirmation}}
        type="password"
        label="Confirm new password"
        required
      />
      <:actions>
        <.form_button_cancel />
        <.form_button_submit />
      </:actions>
    </.simple_form>

    <.action_links
      class="mt-16"
      items={[
        %{content: "Register new account", navigate: ~p"/users/register"},
        %{content: "Login", navigate: ~p"/users/login"}
      ]}
    />
    """
  end

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket, params)

    socket =
      case socket.assigns do
        %{user: user} ->
          assign(socket, :changeset, Accounts.change_user_password(user))

        _ ->
          socket
      end

    {:ok, assign(socket, page_title: "Set a New Password"), temporary_assigns: [changeset: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/login")}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end
end
