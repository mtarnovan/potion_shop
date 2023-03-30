defmodule Carafe.Potions do
  alias Carafe.Repo
  alias Carafe.Potion
  alias Carafe.Review

  import Ecto.Query

  def get_potion(id) do
    Repo.get(Potion, id)
    |> Repo.preload(:reviews)
  end

  def search_potions(name) do
    from(p in Potion, where: like(p.name, ^"%#{name}%") and p.secret == true)
    |> Repo.all()
  end

  def list_potions() do
    from(p in Potion,
      where: p.secret == false)
    |>
    Repo.all()
  end

  def get_reviews(potion_id) do
    from(r in Review,
      where: r.potion_id == ^potion_id)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  def api() do
    q = from(Potion, order_by: [asc: :id])
    Repo.paginate(q, cursor_fields: [:inserted_at, :id], limit: 2)
  end

  def api(a) do
    q = from(Potion, order_by: [asc: :id])
    Repo.paginate(q, after: a, cursor_fields: [:inserted_at, :id], limit: 2)
  end

  def create_potion(params) do
    %Potion{}
    |> Potion.changeset(params)
    |> Repo.insert()
  end

  def create_review(params) do
    %Review{}
    |> Review.changeset(params)
    |> Repo.insert()
  end
end
