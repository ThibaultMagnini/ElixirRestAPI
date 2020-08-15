defmodule Projectip.Repo.Migrations.CreateApikeys do
  use Ecto.Migration

  def change do
    create table(:apikeys) do
      add :key, :string
      add :name, :string
      add :user_id, references(:users, on_delete: :nothing)
    end

    create index(:apikeys, [:user_id])
  end
end
