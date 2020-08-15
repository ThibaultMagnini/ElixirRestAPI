defmodule Projectip.ApiKeyContext do
  @moduledoc """
  The ApiKeyContext context.
  """

  import Ecto.Query, warn: false
  alias Projectip.Repo
  alias Projectip.UserContext.User

  alias Projectip.ApiKeyContext.ApiKey

  @doc """
  Returns the list of apikeys.

  ## Examples

      iex> list_apikeys()
      [%ApiKey{}, ...]

  """
  def list_apikeys do
    Repo.all(ApiKey)
  end

  @doc """
  Gets a single api_key.

  Raises `Ecto.NoResultsError` if the Api key does not exist.

  ## Examples

      iex> get_api_key!(123)
      %ApiKey{}

      iex> get_api_key!(456)
      ** (Ecto.NoResultsError)

  """
  def get_api_key!(id), do: Repo.get!(ApiKey, id)


  def load_keys(%User{} = u), do: u |> Repo.preload([:apikey])

  @doc """
  Creates a api_key.

  ## Examples

      iex> create_api_key(%{field: value})
      {:ok, %ApiKey{}}

      iex> create_api_key(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_api_key(attrs \\ %{}) do
    %ApiKey{}
    |> ApiKey.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a api_key.

  ## Examples

      iex> update_api_key(api_key, %{field: new_value})
      {:ok, %ApiKey{}}

      iex> update_api_key(api_key, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_api_key(%ApiKey{} = api_key, attrs) do
    api_key
    |> ApiKey.changeset(attrs)
    |> Repo.update()
  end




  def create_apikey(attrs, %User{} = user) do
    %ApiKey{}
    |> ApiKey.add_apikey(attrs, user)
    |> Repo.insert()
  end

  @doc """
  Deletes a api_key.

  ## Examples

      iex> delete_api_key(api_key)
      {:ok, %ApiKey{}}

      iex> delete_api_key(api_key)
      {:error, %Ecto.Changeset{}}

  """
  def delete_api_key(%ApiKey{} = api_key) do
    Repo.delete(api_key)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking api_key changes.

  ## Examples

      iex> change_api_key(api_key)
      %Ecto.Changeset{source: %ApiKey{}}

  """
  def change_api_key(%ApiKey{} = api_key) do
    ApiKey.changeset(api_key, %{})
  end
end
