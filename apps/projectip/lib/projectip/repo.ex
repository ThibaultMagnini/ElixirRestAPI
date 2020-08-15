defmodule Projectip.Repo do
  use Ecto.Repo,
    otp_app: :projectip,
    adapter: Ecto.Adapters.Postgres
end
