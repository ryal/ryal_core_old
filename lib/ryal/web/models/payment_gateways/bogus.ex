defmodule Ryal.PaymentGateway.Bogus do
  @moduledoc """
  A very simple payment gateway module that provides the basic functions to fake
  create, update, and delete methods with a payment gateway.
  """

  @doc "Simple bogus create function for an external_id."
  @spec create(atom, String.t | nil, Ecto.Schema.t | Map.t) :: {:ok, String.t}
  def create(type, customer_id, data, nil), do: create(type, customer_id, data)
  def create(_atom, _customer_id, _data), do: {:ok, random_id()}

  @doc "Simple bogus update function."
  @spec update(atom, Ecto.Schema.t) :: {:ok, %{}}
  def update(_atom, _schema), do: {:ok, %{}}

  @doc "Simple bogus delete function."
  @spec delete(atom, Ecto.Schema.t) :: {:ok, %{}}
  def delete(_atom, _schema), do: {:ok, %{}}

  defp random_id do
    :rand.uniform * 10_000_000_000
    |> round
    |> to_string
    |> String.ljust(10, ?0)
  end
end
