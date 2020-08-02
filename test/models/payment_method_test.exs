defmodule Ryal.PaymentMethodTest do
  use Ryal.ModelCase, async: true

  alias Ryal.PaymentMethod
  alias Ryal.PaymentMethod.Proxy

  describe ".changeset/2" do
    test "will cast the appropriate data embed" do
      changeset =
        PaymentMethod.changeset(%PaymentMethod{}, %{
          type: "credit_card"
        })

      %module{} = changeset.changes.proxy.data
      assert module == Proxy
    end

    test "won't break when a type isn't specified" do
      changeset = PaymentMethod.changeset(%PaymentMethod{}, %{})
      refute changeset.valid?
    end
  end
end
