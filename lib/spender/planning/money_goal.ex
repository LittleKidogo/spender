defmodule Spender.Planning.MoneyGoal do
  use Ecto.Schema

  import Ecto.Changeset

  alias Spender.{
    MoneyLogs.Budget,
    Planning.MoneyGoal
  }

  @type t :: %__MODULE__{}

  #binary key setup
  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}

  schema "moneygoals" do
    field :name, :string
    field :location, :string
    field :price, :float
    belongs_to :budget, Budget, foreign_key: :budget_id, type: :binary_id

    timestamps()
  end

  @spec changeset(MoneyGoal.t, map) :: Ecto.Changeset.t()
  def changeset(%MoneyGoal{} = moneygoal, attrs) do
    moneygoal
    |> cast(attrs, [:name, :location, :price])
    |> validate_required([:name, :price])
  end

  @spec create_changeset(Budget.t, map) :: Ecto.Changeset.t()
  def create_changeset(%Budget{} = budget, attrs) do
    %MoneyGoal{}
    |> changeset(attrs)
    |> put_assoc(:budget, budget)
  end

end
