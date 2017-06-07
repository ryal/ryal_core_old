defmodule Ryal.PaymentGateway do
  @moduledoc """
  For each gateway that an application is using, we have a profile or record of
  the `User`'s existence on that gateway. Think of it as a join table between a
  `User` and a payment provider.
  """

  use Ryal.Web, :model

  alias Ryal.Core

  schema "ryal_payment_gateways" do
    field :type, :string
    field :external_id, :string

    has_many :payment_method_gateways, Ryal.PaymentMethodGateway

    belongs_to :user, Core.user_module()

    timestamps()
  end

  @required_fields ~w(type external_id user_id)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> assoc_constraint(:user)
    |> validate_required(@required_fields)
  end
end
