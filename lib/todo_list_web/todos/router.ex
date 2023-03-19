defmodule TodoListWeb.Todos.Router do
  # api
  def todos_api_login_required do
    quote do
      resources "/todos", Api.TodoController, only: [:index, :create]
    end
  end

  def todos_api_require_todo_permissions do
    quote do
      resources "/todos", Api.TodoController, except: [:index, :create]
    end
  end

  # browser
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

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
