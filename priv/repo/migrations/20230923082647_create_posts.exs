defmodule Freddit.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add(:title, :string, null: false)
      add(:content, :string)
      add(:creator_id, references(:users, on_delete: :delete_all))

      timestamps()
    end
  end
end
