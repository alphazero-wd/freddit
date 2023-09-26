# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Freddit.Repo.insert!(%Freddit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Freddit.Categories.Category
alias Freddit.Repo

for category <-
      ~w(Health Education Films Books Tech Science Environment Politics Gaming Food Fashion Sports Music) do
  Repo.insert(%Category{name: category})
end
