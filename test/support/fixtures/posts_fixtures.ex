defmodule Freddit.PostsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Freddit.Posts` context.
  """
  alias Freddit.Categories.Category
  alias Freddit.Repo

  @doc """
  Generate a post.
  """
  def post_fixture(user, attrs \\ %{}) do
    category = category_fixture()

    {:ok, post} =
      attrs
      |> Enum.into(%{
        content: "some content",
        title: "some title",
        category_id: category.id
      })
      |> Freddit.Posts.create_post(user)

    post
  end

  def category_fixture() do
    {:ok, category} =
      Repo.insert(%Category{
        name: "category-#{System.unique_integer([:positive])}"
      })

    category
  end
end
