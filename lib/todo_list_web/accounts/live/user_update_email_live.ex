defmodule TodoListWeb.UserUpdateEmailLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email updated successfully")

        :error ->
          put_flash(socket, :error, "Email update link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/profile")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:page_title, "Update Email")
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_changeset, Accounts.change_user_email(user))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      id="email_form"
      for={@email_changeset}
      phx-submit="update_email"
      phx-change="validate_email"
    >
      <.input field={{f, :email}} type="email" label="Email" required />

      <.input
        field={{f, :current_password}}
        name="current_password"
        id="current_password_for_email"
        type="password"
        label="Current password"
        value={@email_form_current_password}
        required
      />
      <:actions>
        <.form_button_cancel phx-disable-with={false} url={~p"/users/profile"} />
        <.form_button_submit />
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    email_changeset = Accounts.change_user_email(socket.assigns.current_user, user_params)

    socket =
      assign(socket,
        email_changeset: Map.put(email_changeset, :action, :validate),
        email_form_current_password: password
      )

    {:noreply, socket}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/profile/confirm-email/#{&1}")
        )

        info = "Almost done! Check your email inbox for a confirmation link."
        {:noreply, put_flash(socket, :info, info)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_changeset, Map.put(changeset, :action, :insert))}
    end
  end
end
