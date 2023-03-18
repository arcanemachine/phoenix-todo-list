defmodule TodoListWeb.UserForgotPasswordLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  def render(assigns) do
    ~H"""
    <div class="mb-8 text-center">
      Complete this form, then check your email inbox.
    </div>

    <.simple_form :let={f} id="reset_password_form" for={%{}} as={:user} phx-submit="send_email">
      <.input field={{f, :email}} type="email" placeholder="Your email" required />
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

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Forget Your Password")}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, then we have sent an email to your inbox " <>
        "containing password reset instructions."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
