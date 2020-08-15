defmodule ProjectipWeb.AnimalView do
  use ProjectipWeb, :view
  alias ProjectipWeb.AnimalView

  def render("index.json", %{animals: animals}) do
    render_many(animals, AnimalView, "animal.json")
  end



  def render("show.json", %{animal: animal}) do
    render_one(animal, AnimalView, "detail.json")
  end


  def render("detail.json", %{animal: animal}) do
    %{id: animal.id,
      name: animal.name,
      dob: animal.dob,
      cat_or_dog: animal.cat_or_dog}
  end

  def render("animal.json", %{animal: animal}) do
    %{id: animal.id,
      name: animal.name}
  end
end
