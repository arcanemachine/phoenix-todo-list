defmodule TodoListWeb.UserLogoutLive do
  use TodoListWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="template-center max-w-sm">
      <.header class="text-center">
        Are you sure you want to log out?
      </.header>

      <.simple_form for={:nothing}>
        <:actions>
          <.link href={~p"/users/logout"} method="delete">
            <button
              type="button"
              class="btn btn-lg btn-primary form-button"
              phx-disable-with="Logging out..."
            >
              Yes
            </button>
          </.link>
          <button type="button" class="btn btn-lg btn-secondary form-button" onclick="history.back()">
            Cancel
          </button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Confirm Logout")}
  end
end
