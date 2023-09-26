defmodule Freddit.Categories.Category do
  use Ecto.Schema

  schema "categories" do
    field(:name, :string)
    has_many(:posts, Freddit.Posts.Post)
  end
end
