defmodule TodoList.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :content, :string
    field :is_completed, :boolean, default: false
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:content, :is_completed])
    |> validate_required([:content, :is_completed])
  end
end
