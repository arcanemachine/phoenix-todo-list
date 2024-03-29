defmodule TodoListWeb.AccountsController do
  use TodoListWeb, :controller

  alias TodoList.Accounts
  alias TodoListWeb.UserAuth

  def root(conn, _params) do
    conn |> redirect(to: ~p"/users/profile")
  end

  def delete(conn, _params) do
    # get user
    user = conn.assigns[:current_user]

    # delete the user
    Accounts.delete_user(user)

    # queue success message and log the user out
    conn
    |> put_flash(:info, "Account deleted successfully")
    |> UserAuth.logout_user()
  end
end
