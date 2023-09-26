defmodule Freddit.Posts do
  @moduledoc """
  The Posts context.
  """
  import Ecto
  import Ecto.Query, warn: false
  alias Freddit.Categories.Category
  alias Freddit.Repo

  alias Freddit.Posts.Post

  defp user_posts(user) do
    assoc(user, :posts)
  end

  def list_posts(params \\ %{}) do
    Post
    |> order_by(desc: :inserted_at)
    |> preload([:creator, :category])
    |> Repo.paginate(params)
  end

  def get_posts_by_category(category_id) do
    category = Repo.get!(Category, category_id)

    {Repo.all(
       from(p in Post,
         where: p.category_id == ^category.id,
         order_by: [:inserted_at],
         preload: [:creator, :category]
       )
     ), category}
  end

  def get_post!(id), do: Repo.get!(Post, id) |> Repo.preload([:creator, :category])

  def get_post_by_owner(user, id), do: Repo.get!(user_posts(user), id)

  def create_post(post_params, user) do
    user
    |> build_assoc(:posts)
    |> change_post(post_params)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, post_params) do
    post
    |> change_post(post_params)
    |> Repo.update()
  end

  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end
end
