defmodule Projectip.UserContext.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Projectip.AnimalContext.Animal
  alias Projectip.ApiKeyContext.ApiKey

  @acceptable_roles ["Admin", "Manager", "User"]

  schema "users" do
    field :password, :string, virtual: true
    field :hashed_password, :string
    field :role, :string, default: "User"
    field :username, :string
    has_many :animals, Animal
    has_many :apikey, ApiKey
  end

  def get_acceptable_roles, do: @acceptable_roles

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password, :role])
    |> unique_constraint(:username)
    |> validate_required([:username, :password, :role])
    |> validate_inclusion(:role, @acceptable_roles)
    |> put_password_hash()
  end

  @doc false
  def change_username(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
  end

  @doc false
  def change_password(user, attrs) do
    user
    |> cast(attrs, [:password])
    |> validate_required([:password])
    |> put_password_hash()
  end

  defp put_password_hash(
      %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
    ) do
    change(changeset, hashed_password: Pbkdf2.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
