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
    <.header class="my-8 text-center">
      Are you sure you want to delete your account?
    </.header>

    <.simple_form for={%{}} confirmation_required={true}>
      <:actions>
        <.form_button_cancel />
        <.link
          href={~p"/users/profile/delete"}
          method="delete"
          class="btn btn-error form-button"
          phx-disable-with
        >
          Yes
        </.link>
      </:actions>
    </.simple_form>

    <.action_links items={[
      %{content: "Return to your profile", href: ~p"/users/profile", class: "list-back"}
    ]} />
    """
  end
end
