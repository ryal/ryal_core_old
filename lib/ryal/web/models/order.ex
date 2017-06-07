defmodule Ryal.Order do
  @moduledoc """
  Orders are hubs that connect all sorts of information together such as
  products, payments, and shipments.

  TODO: Order documentation as this model becomes more fledged out.
  """

  use Ryal.Web, :model

  alias Ryal.Core

  schema "ryal_orders" do
    field :number, :string
    field :state, :string, default: "cart"
    field :total, :decimal, default: 0.0

    has_many :payments, Ryal.Payment

    belongs_to :user, Core.user_module()

    timestamps()
  end

  @required_fields ~w(user_id)a
  @optional_fields ~w(number state total)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields ++ @optional_fields)
    |> cast_assoc(:user)
    |> generate_number
    |> validate_required(@required_fields)
    |> unique_constraint(:number)
  end

  def generate_number(changeset) do
    Ryal.Base33Calculator.change_number(changeset, "R")
  end
end
