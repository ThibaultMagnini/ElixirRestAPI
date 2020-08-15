defmodule Projectip.AnimalContext.Animal do
  use Ecto.Schema
  import Ecto.Changeset

  alias Projectip.UserContext.User

  schema "animals" do
    field :cat_or_dog, :string
    field :dob, :string
    field :name, :string
    belongs_to :user, User
  end

  @doc false
  def changeset(animal, attrs) do
    animal
    |> cast(attrs, [:name, :dob, :cat_or_dog])
    |> validate_required([:name, :dob, :cat_or_dog])
  end

  def create_changeset(animal, attrs, user) do
    animal
    |> cast(attrs, [:cat_or_dog, :dob, :name])
    |> validate_required([:cat_or_dog, :dob, :name])
    |> put_assoc(:user, user)
  end
end
