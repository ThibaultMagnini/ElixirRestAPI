defmodule Projectip.ApiKeyContextTest do
  use Projectip.DataCase

  alias Projectip.ApiKeyContext

  describe "apikeys" do
    alias Projectip.ApiKeyContext.ApiKey

    @valid_attrs %{key: "some key", name: "some name"}
    @update_attrs %{key: "some updated key", name: "some updated name"}
    @invalid_attrs %{key: nil, name: nil}

    def api_key_fixture(attrs \\ %{}) do
      {:ok, api_key} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ApiKeyContext.create_api_key()

      api_key
    end

    test "list_apikeys/0 returns all apikeys" do
      api_key = api_key_fixture()
      assert ApiKeyContext.list_apikeys() == [api_key]
    end

    test "get_api_key!/1 returns the api_key with given id" do
      api_key = api_key_fixture()
      assert ApiKeyContext.get_api_key!(api_key.id) == api_key
    end

    test "create_api_key/1 with valid data creates a api_key" do
      assert {:ok, %ApiKey{} = api_key} = ApiKeyContext.create_api_key(@valid_attrs)
      assert api_key.key == "some key"
      assert api_key.name == "some name"
    end

    test "create_api_key/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ApiKeyContext.create_api_key(@invalid_attrs)
    end

    test "update_api_key/2 with valid data updates the api_key" do
      api_key = api_key_fixture()
      assert {:ok, %ApiKey{} = api_key} = ApiKeyContext.update_api_key(api_key, @update_attrs)
      assert api_key.key == "some updated key"
      assert api_key.name == "some updated name"
    end

    test "update_api_key/2 with invalid data returns error changeset" do
      api_key = api_key_fixture()
      assert {:error, %Ecto.Changeset{}} = ApiKeyContext.update_api_key(api_key, @invalid_attrs)
      assert api_key == ApiKeyContext.get_api_key!(api_key.id)
    end

    test "delete_api_key/1 deletes the api_key" do
      api_key = api_key_fixture()
      assert {:ok, %ApiKey{}} = ApiKeyContext.delete_api_key(api_key)
      assert_raise Ecto.NoResultsError, fn -> ApiKeyContext.get_api_key!(api_key.id) end
    end

    test "change_api_key/1 returns a api_key changeset" do
      api_key = api_key_fixture()
      assert %Ecto.Changeset{} = ApiKeyContext.change_api_key(api_key)
    end
  end
end
