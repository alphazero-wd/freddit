defmodule Freddit.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field(:content, :string)
    field(:title, :string)
    belongs_to(:creator, Freddit.Accounts.User)
    belongs_to(:category, Freddit.Categories.Category)

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :content, :category_id])
    |> validate_required([:title, :category_id])
    |> assoc_constraint(:category)
  end
end
