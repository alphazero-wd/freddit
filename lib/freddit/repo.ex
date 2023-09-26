defmodule Freddit.Repo do
  use Ecto.Repo,
    otp_app: :freddit,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: if(Mix.env() == :test, do: 1, else: 12)
end
