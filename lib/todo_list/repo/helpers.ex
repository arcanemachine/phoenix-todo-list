defmodule TodoList.Repo.Helpers do
  @moduledoc false

  def count(model) do
    TodoList.Repo.aggregate(model, :count, :id)
  end
end
