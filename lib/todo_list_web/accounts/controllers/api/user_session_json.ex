defmodule TodoListWeb.Api.UserSessionJSON do
  @moduledoc false
  alias TodoList.Accounts.User

  # @doc """
  # Renders a list of users.
  # """
  # def index(%{users: users}) do
  #   %{data: for(user <- users, do: data(user))}
  # end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email
    }
  end
end
