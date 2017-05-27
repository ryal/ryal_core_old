defmodule Ryal.PaymentMethodGateway do
  @moduledoc """
  A join table between a `Ryal.PaymentGateway` and a `Ryal.PaymentMethod`, this
  model is responsible for connecting a payment to a user's payment method and
  billing it under the appropriate `Ryal.PaymentGateway`.
  """

  use Ryal.Web, :model

  schema "ryal_payment_method_gateways" do
    has_many :payments, Ryal.Payment

    belongs_to :payment_gateway, Ryal.PaymentGateway
    belongs_to :payment_method, Ryal.PaymentMethod

    timestamps()
  end

  @required_fields ~w(payment_method_id payment_gateway_id)a

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> cast_assoc(:payment_gateway)
    |> cast_assoc(:payment_method)
  end
end
