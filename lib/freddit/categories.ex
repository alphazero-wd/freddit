defmodule Freddit.Categories do
  alias Freddit.{Categories.Category, Repo}
  import Ecto.Query

  defp alphabetical(query) do
    from(c in query, order_by: c.name)
  end

  defp names_and_ids(query) do
    from(c in query, select: {c.name, c.id})
  end

  def load_categories() do
    Category
    |> alphabetical()
    |> names_and_ids()
    |> Repo.all()
  end
end
