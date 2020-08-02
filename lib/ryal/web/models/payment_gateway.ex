defmodule Ryal.PaymentGateway do
  @moduledoc """
  For each gateway that an application is using, we have a profile or record of
  the `User`'s existence on that gateway. Think of it as a join table between a
  `User` and a payment provider.

  The behaviour for all of the payment gateways that we've setup are also
  contained inside of here. Please use this guy if you'd like to create your
  own. This way you don't make any mistakes and you get warnings if you update
  Ryal.
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

  @callback create(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback create(atom, %{}) :: {:ok, %{}}

  @callback update(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback update(atom, %{}) :: {:ok, %{}}

  @callback delete(atom, %{}, String.t() | nil) :: {:ok, %{}}
  @callback delete(atom, %{}) :: {:ok, %{}}

  @optional_callbacks create: 2, update: 2, delete: 2

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields)
    |> assoc_constraint(:user)
    |> validate_required(@required_fields)
  end
end
