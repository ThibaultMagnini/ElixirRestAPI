defmodule ProjectipWeb.AnimalController do
  use ProjectipWeb, :controller

  alias Projectip.AnimalContext
  alias Projectip.AnimalContext.Animal
  alias Projectip.UserContext
  alias Projectip.ApiKeyContext

  action_fallback ProjectipWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    if authorize(conn, user_id) do
      user = UserContext.get_user!(user_id)
      animals = AnimalContext.load_animals(user)
      render(conn, "index.json", animals: animals.animals)
    else
      conn
      |> send_resp(401, "Unauthorized.")
    end
  end

  def create(conn, %{"user_id" => user_id, "animal" => animal_params}) do

    if authorize(conn, user_id) do

      user = UserContext.get_user!(user_id)

      case AnimalContext.create_animal(animal_params, user) do
        {:ok, %Animal{} = animal} ->
          conn
          |> put_status(:created)
          |> put_resp_header("location", Routes.user_animal_path(conn, :show, user_id, animal))
          |> render("show.json", animal: animal)

        {:error, _cs} ->
          conn
          |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
      end

    else
      conn
      |> send_resp(401, "Unauthorized.")
    end
  end

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    if authorize(conn, user_id) do
      animal = AnimalContext.get_animal!(id)
      render(conn, "show.json", animal: animal)
    else
      conn
      |> send_resp(401, "Unauthorized.")
    end
  end

  def update(conn, %{"id" => id, "animal" => animal_parameters, "user_id" => user_id}) do
    if authorize(conn, user_id) do
      animal = AnimalContext.get_animal(id)

      if animal == nil do
        conn
        |> send_resp(400, "Animal does not exist.")
      end
      case AnimalContext.update_animal(animal, animal_parameters) do
        {:ok, %Animal{} = animal} ->
          render(conn, "show.json", animal: animal)

        {:error, _cs} ->
          conn
          |> send_resp(400, "Something went wrong, sorry. Adjust your parameters or give up.")
      end
    else
      conn
      |> send_resp(401, "Unauthorized.")
    end
  end


  def delete(conn, %{"id" => id, "user_id" => user_id}) do
    if authorize(conn, user_id) do
      animal = AnimalContext.get_animal(id)

      if animal == nil do
        conn
        |> send_resp(400, "User does not exist.")
      end

      with {:ok, %Animal{}} <- AnimalContext.delete_animal(animal) do
        send_resp(conn, :no_content, "")
      end

    else
      conn
      |> send_resp(401, "Unauthorized.")
    end
  end


  def authorize(conn, user_id)do
    user = UserContext.get_user(user_id)
    if user == nil do
      conn
      |> send_resp(400, "User does not exist.")
    end
    userkeys = ApiKeyContext.load_keys(user)
    api_key = get_req_header(conn, "x-api-key")
    Enum.any?(userkeys.apikey, fn x -> String.equivalent?(x.key, api_key) end)
  end
end
