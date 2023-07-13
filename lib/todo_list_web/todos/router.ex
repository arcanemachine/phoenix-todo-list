defmodule TodoListWeb.Todos.Router do
  # BROWSER #
  def todos_login_required do
    quote do
      resources("/todos", TodoController, only: [:index, :new, :create])
    end
  end

  def todos_login_required_live_session do
    quote do
      live "/todos/live", TodosLive
    end
  end

  def todos_require_todo_permissions do
    quote do
      resources("/todos", TodoController, only: [:show, :edit, :update, :delete])
    end
  end

  # API #
  def todos_api_login_required do
    quote do
      resources "/todos", Api.TodoController, only: [:index, :create]
    end
  end

  def todos_require_api_todo_permissions do
    quote do
      resources "/todos", Api.TodoController, only: [:show, :update, :delete]
    end
  end

  @doc """
  When used, dispatch the appropriate function by calling the desired function name as an atom.

  ## Examples

      use AccountsRouter, :accounts_allow_any_user
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
