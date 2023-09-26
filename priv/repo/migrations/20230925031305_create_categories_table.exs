defmodule Freddit.Repo.Migrations.CreateCategoriesTable do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string)
    end

    create(unique_index(:categories, :name))
  end
end
