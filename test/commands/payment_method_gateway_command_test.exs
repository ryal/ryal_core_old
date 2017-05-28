defmodule Ryal.PaymentMethodGatewayCommandTest do
  use Ryal.ModelCase

  alias Dummy.{Repo, User}
  alias Plug.Conn
  alias Ryal.{
    PaymentGatewayCommand, PaymentMethod, PaymentMethodGateway,
    PaymentMethodGatewayCommand
  }

  describe ".create/1" do
    setup do
      user = %User{email: "hello@example.com"}
        |> User.changeset
        |> Repo.insert!

      credit_card_data = %{
        name: "Bobby Orr",
        number: "4242 4242 4242 4242",
        month: "03",
        year: "2048",
        cvc: "004"
      }

      payment_method = %PaymentMethod{}
        |> PaymentMethod.changeset(%{
          type: "credit_card",
          user_id: user.id,
          proxy: credit_card_data
        })
        |> Repo.insert!

      [
        credit_card_data: credit_card_data,
        payment_method: payment_method,
        user: user
      ]
    end

    test "will create the payment method gateway with bogus",
        %{credit_card_data: credit_card_data, payment_method: payment_method,
          user: user} do
      {:ok, payment_gateway} = PaymentGatewayCommand.create(:bogus, user)

      %PaymentMethodGateway{}
      |> PaymentMethodGateway.changeset(%{
        payment_method_id: payment_method.id,
        payment_gateway_id: payment_gateway.id
      })
      |> PaymentMethodGatewayCommand.create(credit_card_data)

      assert Repo.one! PaymentMethodGateway
    end

    test "will create the payment method gateway with stripe",
        %{credit_card_data: credit_card_data, payment_method: payment_method,
          user: user} do
      bypass = Bypass.open

      Bypass.expect bypass, fn(conn) ->
        assert "/v1/customers" == conn.request_path
        assert "POST" == conn.method

        Conn.resp(conn, 201, read_fixture("stripe/customer.json"))
      end

      {:ok, payment_gateway} = PaymentGatewayCommand.create(:stripe, user, bypass_endpoint(bypass))

      Bypass.expect bypass, fn(conn) ->
        assert "/v1/customers/cus_AMUcqwTDYlbBSp/sources" == conn.request_path
        assert "POST" == conn.method

        Conn.resp(conn, 201, read_fixture("stripe/credit_card.json"))
      end

      %PaymentMethodGateway{}
      |> PaymentMethodGateway.changeset(%{
        payment_method_id: payment_method.id,
        payment_gateway_id: payment_gateway.id
      })
      |> PaymentMethodGatewayCommand.create(credit_card_data, bypass_endpoint(bypass))

      assert Repo.one! PaymentMethodGateway
    end
  end
end
