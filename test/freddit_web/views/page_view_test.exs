defmodule FredditWeb.PageViewTest do
  alias Freddit.Posts
  alias Freddit.Categories.Category
  alias Freddit.Posts.Post
  import Freddit.{AccountsFixtures}
  import Phoenix.View
  use FredditWeb.ConnCase, async: true

  test "renders index.html", %{conn: conn} do
    user = user_fixture()

    present = NaiveDateTime.utc_now()
    categories = [{"cats", 123}, {"dogs", 124}]

    posts = [
      %Post{
        id: 1,
        title: "some title",
        content: "some content",
        inserted_at: present,
        updated_at: present,
        category_id: 123,
        category: %Category{
          id: 123,
          name: "cats"
        },
        creator_id: user.id,
        creator: user
      },
      %Post{
        id: 2,
        title: "some another title",
        content: "some another content",
        inserted_at: present,
        updated_at: present,
        category_id: 123,
        category: %Category{
          id: 123,
          name: "cats"
        },
        creator_id: user.id,
        creator: user
      }
    ]

    page_size = 2
    total_entries = 20
    total_pages = ceil(total_entries / page_size)
    page_number = Enum.random(1..total_pages)

    html =
      render_to_string(FredditWeb.PostView, "index.html",
        conn: conn,
        posts: posts,
        page_size: page_size,
        total_entries: total_entries,
        total_pages: total_pages,
        page_number: page_number,
        categories: categories
      )

    assert String.contains?(html, "Latest posts")

    for category <- categories do
      assert String.contains?(html, elem(category, 0) <> "</a>")
    end

    for num <- 1..total_pages do
      assert String.contains?(html, to_string(num))
    end

    for post <- posts do
      assert String.contains?(html, post.title)
      assert String.contains?(html, post.content)
      assert String.contains?(html, Calendar.strftime(post.inserted_at, "%B %-d, %Y %I:%M %p"))
      assert String.contains?(html, post.category.name)
      assert String.contains?(html, post.creator.username)
    end
  end

  test "renders new.html", %{conn: conn} do
    changeset = Posts.change_post(%Post{})
    categories = [{"cats", 123}, {"dogs", 124}]

    html =
      render_to_string(FredditWeb.PostView, "new.html",
        conn: conn,
        changeset: changeset,
        categories: categories
      )

    assert String.contains?(html, "Create new post")

    for category <- categories do
      assert String.contains?(html, elem(category, 0) <> "</option>")
    end
  end

  test "renders edit.html", %{conn: conn} do
    user = user_fixture()

    post = %Post{
      id: 1,
      title: "some title",
      content: "some content",
      category_id: 123,
      category: %Category{
        id: 123,
        name: "cats"
      },
      creator_id: user.id,
      creator: user
    }

    changeset = Posts.change_post(post)
    categories = [{"cats", 123}, {"dogs", 124}]

    html =
      render_to_string(FredditWeb.PostView, "edit.html",
        conn: conn,
        post: post,
        changeset: changeset,
        categories: categories
      )

    assert String.contains?(html, "Edit post")
    assert String.contains?(html, post.title)
    assert String.contains?(html, post.content)

    for category <- categories do
      assert String.contains?(html, elem(category, 0) <> "</option>")
    end
  end
end
