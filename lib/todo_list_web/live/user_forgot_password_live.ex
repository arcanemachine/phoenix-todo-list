defmodule TodoListWeb.UserForgotPasswordLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def render(assigns) do
    ~H"""
    <section class="template-center">
      <div class="max-w-sm">
        <.header class="text-center">
          Forgot your password?
          <:subtitle>We'll send a password reset link to your inbox</:subtitle>
        </.header>

        <.simple_form :let={f} id="reset_password_form" for={:user} phx-submit="send_email">
          <.input field={{f, :email}} type="email" placeholder="Your email" required />
          <:actions>
            <.button phx-disable-with="Sending..." class="mt-2 btn-primary w-full">
              Submit
            </.button>
          </:actions>
        </.simple_form>
        <p class="text-center mt-6">
          <.link href={~p"/users/register"}>Register</.link>
          <span class="inline-block w-8">|</span>
          <.link href={~p"/users/log_in"}>Log in</.link>
        </p>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
