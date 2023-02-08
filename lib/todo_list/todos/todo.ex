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
    |> cast(attrs, [:content, :is_completed, :user_id])
    |> validate_required([:content, :is_completed, :user_id])
    |> foreign_key_constraint(:user_id)
  end
end
