defmodule Lounge.Repo do
  use Ecto.Repo,
    otp_app: :lounge,
    adapter: Ecto.Adapters.Postgres
end
