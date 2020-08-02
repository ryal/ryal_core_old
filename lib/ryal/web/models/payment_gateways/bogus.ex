defmodule Ryal.PaymentGateway.Bogus do
  @moduledoc """
  A very simple payment gateway module that provides the basic functions to fake
  create, update, and delete methods with a payment gateway.
  """

  @behaviour Ryal.PaymentGateway

  @doc "Simple bogus create function for an external_id."
  def create(_type, _data, _base), do: {:ok, random_id()}
  def create(_type, _data), do: {:ok, random_id()}

  @doc "Simple bogus update function."
  def update(_atom, _data, _base), do: {:ok, %{}}
  def update(_atom, _data), do: {:ok, %{}}

  @doc "Simple bogus delete function."
  def delete(_atom, _data, _base), do: {:ok, %{}}
  def delete(_atom, _data), do: {:ok, %{}}

  defp random_id do
    :rand.uniform()
    |> Kernel.*(10_000_000_000)
    |> round
    |> to_string
    |> String.pad_trailing(10, "0")
  end
end
