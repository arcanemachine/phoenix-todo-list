defmodule TodoListWeb.UserRegistrationLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Accounts.User

  def render(assigns) do
    ~H"""
    <div :if={@changeset.action == :insert}>
      <.form_error_alert />
    </div>

    <p class="text-center">
      Make a new account and create your own todo list!
    </p>

    <.simple_form
      :let={f}
      class="mt-8"
      id="registration_form"
      for={@changeset}
      phx-submit="save"
      phx-change="validate"
      phx-trigger-action={@trigger_submit}
      action={~p"/users/login?_action=registered"}
      method="post"
      as={:user}
    >
      <.input field={{f, :email}} type="email" label="Email" required />
      <.input
        field={{f, :password}}
        type="password"
        label="Password"
        minlength={TodoList.Accounts.User.password_length_min()}
        required
      />
      <.input
        field={{f, :password_confirmation}}
        type="password"
        minlength={TodoList.Accounts.User.password_length_min()}
        label="Confirm password"
      />

      <:actions>
        <.form_button_cancel />
        <.form_button_submit />
      </:actions>
    </.simple_form>

    <.action_links
      class="mt-16"
      items={[
        %{content: "Login to an existing account", navigate: ~p"/users/login"}
      ]}
    />
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      assign(socket,
        page_title: "Register New Account",
        changeset: changeset,
        trigger_submit: false
      )

    {:ok, socket, temporary_assigns: [changeset: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, assign(socket, trigger_submit: true, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign(socket, changeset: Map.put(changeset, :action, :validate))}
  end
end
