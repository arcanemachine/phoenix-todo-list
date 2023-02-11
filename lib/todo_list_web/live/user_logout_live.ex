defmodule TodoListWeb.UserLogoutLive do
  use TodoListWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Are you sure you want to log out?
      </.header>

      <.simple_form for={:nothing}>
        <:actions>
          <.link href={~p"/users/log_out"} method="delete">
            <.form_button phx-disable-with="Logging out...">
              Yes
            </.form_button>
          </.link>
          <.form_button class="btn-secondary" onclick="history.go(-1)">
            Cancel
          </.form_button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Confirm Logout")}
  end
end
