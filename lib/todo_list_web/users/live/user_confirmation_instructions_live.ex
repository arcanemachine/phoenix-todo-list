defmodule TodoListWeb.UserConfirmationInstructionsLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def render(assigns) do
    ~H"""
    <!-- .header>Resend confirmation instructions</.header -->
    <.simple_form
      :let={f}
      for={%{}}
      as={:user}
      id="resend_confirmation_form"
      phx-submit="send_instructions"
    >
      <.input field={{f, :email}} type="email" label="Email" required />
      <:actions>
        <.button phx-disable-with="Sending...">Resend confirmation instructions</.button>
      </:actions>
    </.simple_form>

    <p>
      <.link href={~p"/users/register"}>Register</.link>
      |
      <.link href={~p"/users/login"}>Log in</.link>
    </p>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Resend Confirmation Instructions")}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
