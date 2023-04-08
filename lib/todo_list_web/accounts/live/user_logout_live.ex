defmodule TodoListWeb.UserLogoutLive do
  use TodoListWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, page_title: "Confirm Logout")}
  end

  def render(assigns) do
    ~H"""
    <%= if !assigns[:current_user] do %>
      <!--script>
        // if user is not authenticated, redirect them to homepage
        window.location.replace('/');
      </script-->
    <% end %>

    <.header class="my-8 text-center">
      Are you sure you want to log out?
    </.header>

    <.simple_form for={%{}} id="logout-form">
      <:actions>
        <.form_button_cancel />
        <.link href={~p"/users/logout"} id="logout-form-button-submit" method="delete">
          <.form_button class="btn-primary" content="Yes" />
        </.link>
      </:actions>
    </.simple_form>
    """
  end
end
