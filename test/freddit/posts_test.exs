defmodule Freddit.PostsTest do
  use Freddit.DataCase

  alias Freddit.Posts

  describe "posts" do
    alias Freddit.Posts.Post

    import Freddit.{PostsFixtures, AccountsFixtures}

    @invalid_attrs %{content: nil, title: nil, category_id: nil}

    setup do
      creator = user_fixture()
      %{creator: creator}
    end

    test "list_posts/0 returns 1 post per page", %{creator: creator} do
      post_fixture(creator)
      post_fixture(creator)
      posts = Repo.all(Post) |> Repo.preload([:creator, :category])

      assert Posts.list_posts() == %Scrivener.Page{
               entries: [Enum.at(posts, 0)],
               page_number: 1,
               page_size: 1,
               total_entries: 2,
               total_pages: 2
             }

      assert Posts.list_posts(%{page: 2}) == %Scrivener.Page{
               entries: [Enum.at(posts, 1)],
               page_number: 2,
               page_size: 1,
               total_entries: 2,
               total_pages: 2
             }
    end

    test "get_post!/1 returns the post with given id", %{creator: creator} do
      post_id = post_fixture(creator).id
      post = Repo.get!(Post, post_id) |> Repo.preload([:category, :creator])
      assert Posts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post", %{creator: creator} do
      category = category_fixture()
      valid_attrs = %{content: "some content", title: "some title", category_id: category.id}

      assert {:ok, %Post{} = post} = Posts.create_post(valid_attrs, creator)
      assert post.content == "some content"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset", %{creator: creator} do
      assert {:error, %Ecto.Changeset{}} = Posts.create_post(@invalid_attrs, creator)
    end

    test "create_post/1 with unknown category returns error", %{creator: creator} do
      attrs_with_unknown_category = %{
        content: "some content",
        title: "some title",
        category_id: 0
      }

      assert {:error, %Ecto.Changeset{}} = Posts.create_post(attrs_with_unknown_category, creator)
    end

    test "update_post/2 with valid data updates the post", %{creator: creator} do
      post = post_fixture(creator)
      update_attrs = %{content: "some updated content", title: "some updated title"}

      assert {:ok, %Post{} = post} = Posts.update_post(post, update_attrs)
      assert post.content == "some updated content"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset", %{creator: creator} do
      post = post_fixture(creator)
      assert {:error, %Ecto.Changeset{}} = Posts.update_post(post, @invalid_attrs)
      assert post == Repo.get(Post, post.id)
    end

    test "delete_post/1 deletes the post", %{creator: creator} do
      post = post_fixture(creator)
      assert {:ok, %Post{}} = Posts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Posts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset", %{creator: creator} do
      post = post_fixture(creator)
      assert %Ecto.Changeset{} = Posts.change_post(post)
    end
  end
end
