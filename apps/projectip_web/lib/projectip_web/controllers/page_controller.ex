defmodule ProjectipWeb.PageController do
  use ProjectipWeb, :controller

  alias Projectip.AnimalContext

  def index(conn, _params) do
    render(conn, "index.html", role: "everyone")
  end

  def user_index(conn, _params) do

    user = Guardian.Plug.current_resource(conn)
    animals = AnimalContext.load_animals(user)
    render(conn, "index.html", animals: animals.animals)
  end

  def admin_index(conn, _params) do
    render(conn, "index.html", role: "admins")
  end
end
