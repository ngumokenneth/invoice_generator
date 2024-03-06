defmodule InvoiceGeneratorWeb.AddressLiveTest do
  use InvoiceGeneratorWeb.ConnCase, async: true

  import InvoiceGenerator.AccountsFixtures
  import Phoenix.LiveViewTest

  setup %{conn: conn} do
    password = valid_user_password()
    user = user_fixture(%{password: password}) |> confirm_email()
    %{conn: log_in_user(conn, user), user: user, password: password}
  end

  describe "Address details page" do
    test "a user can access the address page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/address")

      assert html =~ "Enter your business address details"
    end

    test "a user can see the input fields", %{conn: conn} do
      {:ok, view, html} = live(conn, ~p"/address")
      country_field = element(view, "input#address_country")
      assert has_element?(country_field)
    end

    test "a user can update an address", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/address")
      html = render(view)
      assert html =~ "Enter your business address details"

      {:ok, conn} =
        view
        |> form("#address_form", %{
          address: %{
            country: "Kenya",
            city: "Nairobi",
            street_address: "123",
            postal_code: "1234",
            phone_number: "1234567890"
          }
        })
        |> render_submit()

        assert html =~ "Address updated successfully"
    end

    test "renders errors when data is valid", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/address")

      result =
        view
        |> form("#address_form", %{address: %{country: "Kenya"}})
        |> render_submit()

      assert conn.resp.body =~ "Address updated successfully"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/address")

      result =
        view
        |> form("#address_form", %{address: %{country: ""}})
        |> IO.inspect(label: "result")
        |> render_submit()

      assert result =~ "can&#39;t be blank"
    end
  end
end
