defmodule TodoListWeb.UserRegistrationLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts
  alias TodoList.Accounts.User

  def render(assigns) do
    ~H"""
    <div :if={@changeset.action == :insert} class="alert alert-error" role="alert">
      To continue, fix the errors in the form.
    </div>

    <section class="template-center">
      <div>
        <.simple_form
          :let={f}
          id="registration_form"
          for={@changeset}
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/login?_action=registered"}
          method="post"
          as={:user}
        >
          <.input field={{f, :email}} type="email" label="Email" required phx-debounce="500" />
          <.input field={{f, :password}} type="password" label="Password" required phx-debounce="500" />

          <:actions>
            <.button phx-disable-with class="mt-2 btn-primary w-full">
              Submit
            </.button>
          </:actions>
        </.simple_form>

        <div class="mt-20">
          Already registered?
          <.link navigate={~p"/users/login"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      assign(socket,
        changeset: changeset,
        trigger_submit: false,
        page_title: "Register New Account"
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
