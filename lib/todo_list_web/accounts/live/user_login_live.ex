defmodule TodoListWeb.UserLoginLive do
  use TodoListWeb, :live_view

  def render(assigns) do
    ~H"""
    <.simple_form
      :let={f}
      id="login_form"
      for={%{}}
      action={~p"/users/login"}
      as={:user}
      phx-update="ignore"
    >
      <.input field={{f, :email}} type="email" label="Email" required />
      <.input field={{f, :password}} type="password" label="Password" required />

      <:actions :let={f}>
        <.input field={{f, :remember_me}} type="checkbox" class="text-lg" label="Remember me" checked />
      </:actions>

      <:actions>
        <.form_button_cancel />
        <.form_button_submit />
      </:actions>
    </.simple_form>

    <.action_links
      class="mt-16"
      items={[
        %{content: "Register new account", navigate: ~p"/users/register"},
        %{content: "Forgot your password?", navigate: ~p"/users/reset_password"}
      ]}
    />
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, page_title: "Login", email: email), temporary_assigns: [email: nil]}
  end
end
