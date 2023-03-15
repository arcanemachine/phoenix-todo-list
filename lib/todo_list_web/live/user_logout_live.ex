defmodule TodoListWeb.UserLogoutLive do
  use TodoListWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Confirm Logout")}
  end

  def render(assigns) do
    ~H"""
    <%= if !assigns[:current_user] do %>
      <script>
        // if user is not authenticated, redirect them to homepage
        window.location.replace('/');
      </script>
    <% end %>

    <div class="template-center max-w-sm">
      <.header class="text-center">
        Are you sure you want to log out?
      </.header>

      <.simple_form for={%{}}>
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
end
