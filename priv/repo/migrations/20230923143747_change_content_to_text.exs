defmodule Freddit.Repo.Migrations.ChangeContentToText do
  use Ecto.Migration

  def change do
    alter table(:posts) do
      modify(:content, :text, null: true)
    end
  end
end
