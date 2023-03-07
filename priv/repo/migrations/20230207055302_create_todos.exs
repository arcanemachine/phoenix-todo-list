defmodule TodoList.Repo.Migrations.CreateTodos do
  @moduledoc false

  use Ecto.Migration

  def change do
    create table(:todos) do
      add :content, :string
      add :is_completed, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:todos, [:user_id])
  end
end
