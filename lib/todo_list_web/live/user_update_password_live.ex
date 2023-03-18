defmodule TodoListWeb.UserUpdatePasswordLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user

    socket =
      socket
      |> assign(:page_title, "Update Password")
      |> assign(:email, user.email)
      |> assign(:current_password, nil)
      |> assign(:password_changeset, Accounts.change_user_password(user))
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      for={@password_changeset}
      id="password_form"
      action={~p"/users/login?_action=password_updated"}
      method="post"
      phx-change="validate_password"
      phx-submit="update_password"
      phx-trigger-action={@trigger_submit}
    >
      <.input field={{f, :email}} type="hidden" value={@email} />

      <.input
        field={{f, :current_password}}
        name="current_password"
        type="password"
        label="Current password"
        id="current_password_for_password"
        value={@current_password}
        required
      />
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
        minlength={TodoList.Accounts.User.password_length_min()}
        label="Confirm new password"
      />
      <:actions>
        <.form_button_cancel phx-disable-with={false} url={~p"/users/profile"} />
        <.form_button_submit />
      </:actions>
    </.simple_form>
    """
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    password_changeset = Accounts.change_user_password(socket.assigns.current_user, user_params)

    {:noreply,
     socket
     |> assign(:password_changeset, Map.put(password_changeset, :action, :validate))
     |> assign(:current_password, password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        socket =
          socket
          |> assign(:trigger_submit, true)
          |> assign(:password_changeset, Accounts.change_user_password(user, user_params))

        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :password_changeset, changeset)}
    end
  end
end
