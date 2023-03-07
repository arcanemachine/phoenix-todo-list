defmodule TodoListWeb.UserDeleteLive do
  use TodoListWeb, :live_view

  alias TodoList.Accounts

  # lifecycle
  def mount(_params, session, socket) do
    current_user = Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     assign(socket,
       page_title: "Delete Account",
       current_user: current_user
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="template-center max-w-md">
      <.header class="text-center">
        Are you sure you want to delete your account?
      </.header>

      <.simple_form for={%{}}>
        <:actions>
          <.link href={~p"/users/profile/delete"} method="delete">
            <.button
              type="button"
              class="btn btn-lg btn-error form-button"
              phx-click="user_delete_confirm"
              phx-disable-with
            >
              Yes
            </.button>
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
