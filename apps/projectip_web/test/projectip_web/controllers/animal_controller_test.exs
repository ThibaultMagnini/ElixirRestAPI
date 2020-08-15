defmodule ProjectipWeb.AnimalControllerTest do
  use ProjectipWeb.ConnCase

  alias Projectip.AnimalContext
  alias Projectip.AnimalContext.Animal

  @create_attrs %{
    cat_or_dog: "some cat_or_dog",
    dob: "some dob",
    name: "some name"
  }
  @update_attrs %{
    cat_or_dog: "some updated cat_or_dog",
    dob: "some updated dob",
    name: "some updated name"
  }
  @invalid_attrs %{cat_or_dog: nil, dob: nil, name: nil}

  def fixture(:animal) do
    {:ok, animal} = AnimalContext.create_animal(@create_attrs)
    animal
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all animals", %{conn: conn} do
      conn = get(conn, Routes.animal_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create animal" do
    test "renders animal when data is valid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.animal_path(conn, :show, id))

      assert %{
               "id" => id,
               "cat_or_dog" => "some cat_or_dog",
               "dob" => "some dob",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.animal_path(conn, :create), animal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update animal" do
    setup [:create_animal]

    test "renders animal when data is valid", %{conn: conn, animal: %Animal{id: id} = animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.animal_path(conn, :show, id))

      assert %{
               "id" => id,
               "cat_or_dog" => "some updated cat_or_dog",
               "dob" => "some updated dob",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, animal: animal} do
      conn = put(conn, Routes.animal_path(conn, :update, animal), animal: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete animal" do
    setup [:create_animal]

    test "deletes chosen animal", %{conn: conn, animal: animal} do
      conn = delete(conn, Routes.animal_path(conn, :delete, animal))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.animal_path(conn, :show, animal))
      end
    end
  end

  defp create_animal(_) do
    animal = fixture(:animal)
    {:ok, animal: animal}
  end
end
