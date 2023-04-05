defmodule TodoListWeb.UserLoginLive do
  use TodoListWeb, :live_view

  @page_title "Login"

  def render(assigns) do
    ~H"""
    <template x-page-title={@page_title} />

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
        <div>
          <.input
            field={{f, :remember_me}}
            type="checkbox"
            class="text-lg"
            label="Remember me"
            checked
          />
        </div>
      </:actions>

      <:actions>
        <.form_button_cancel />
        <.form_button_submit />
      </:actions>
    </.simple_form>

    <.action_links
      class="mt-16"
      items={[
        %{content: "Register new account", href: ~p"/users/register"},
        %{content: "Forgot your password?", href: ~p"/users/reset-password"}
      ]}
    />
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, page_title: @page_title, email: email), temporary_assigns: [email: nil]}
  end
end
