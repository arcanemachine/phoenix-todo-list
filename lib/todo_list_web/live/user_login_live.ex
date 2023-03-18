defmodule TodoListWeb.UserLoginLive do
  use TodoListWeb, :live_view

  def render(assigns) do
    ~H"""
    <template x-if="$store.globals.platformIsApp">
      <div x-init="() => {
        // after logging out, select the 'Items' tab
        $store.globals.flutterHandler.callHandler('bottomBarSelectedIndexSet', 0);
      }">
      </div>
    </template>

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
        <div class="mb-8">
          <.input field={{f, :remember_me}} type="checkbox" label="Remember me" checked />
        </div>
      </:actions>

      <:actions>
        <.form_button_submit />
        <.form_button_cancel />
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
    {:ok, assign(socket, email: email, page_title: "Login"), temporary_assigns: [email: nil]}
  end
end
