defmodule TodoListWeb.UserLoginLive do
  use TodoListWeb, :live_view

  def render(assigns) do
    ~H"""
    <template x-if="$store.globals.platformIsNative">
      <div x-init="() => {
        // after logging out, select the 'Items' tab
        $store.globals.flutterHandler.callHandler('bottomBarSelectedIndexSet', 0);
      }">
      </div>
    </template>

    <section class="template-center">
      <div class="mx-auto max-w-sm">
        <.header class="text-center">
          Sign in to account
          <:subtitle>
            Don't have an account?
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </:subtitle>
        </.header>

        <.simple_form
          :let={f}
          id="login_form"
          for={:user}
          action={~p"/users/login"}
          as={:user}
          phx-update="ignore"
        >
          <.input field={{f, :email}} type="email" label="Email" required />
          <.input field={{f, :password}} type="password" label="Password" required />

          <:actions :let={f}>
            <.input field={{f, :remember_me}} type="checkbox" label="Remember me" checked />
          </:actions>
          <:actions>
            <.button phx-disable-with="Signing in..." class="mt-2 btn-primary w-full">
              Sign in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>

        <div class="mt-8 text-center">
          <.link href={~p"/users/reset_password"} class="text font-semibold">
            Forgot your password?
          </.link>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    {:ok, assign(socket, email: email), temporary_assigns: [email: nil]}
  end
end
