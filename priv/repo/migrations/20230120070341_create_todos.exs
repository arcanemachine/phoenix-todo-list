defmodule TodoList.Repo.Migrations.CreateTodos do
  @moduledoc """
  Initial migration for todos.
  """
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :content, :string, null: false
      add :is_completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
