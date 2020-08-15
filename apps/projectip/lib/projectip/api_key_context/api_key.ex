defmodule Projectip.ApiKeyContext.ApiKey do
  use Ecto.Schema
  import Ecto.Changeset
  alias Projectip.UserContext.User

  schema "apikeys" do
    field :key, :string
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(api_key, attrs) do
    api_key
    |> cast(attrs, [:key, :name])
    |> validate_required([:key, :name])
  end

  def add_apikey(api_key, attrs, user) do
      api_key
      |> cast(attrs, [:key, :name])
      |> validate_required([:key, :name])
      |> put_assoc(:user, user)
  end

end
