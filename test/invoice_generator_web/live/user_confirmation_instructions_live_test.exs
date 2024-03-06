defmodule InvoiceGeneratorWeb.UserConfirmationInstructionsLiveTest do
  use InvoiceGeneratorWeb.ConnCase

  import Phoenix.LiveViewTest
  import InvoiceGenerator.AccountsFixtures

  alias InvoiceGenerator.Accounts
  alias InvoiceGenerator.Repo

  # setup %{conn: conn} do
  #   user =
  #     user_fixture()

  #   %{user: log_in_user(conn, user)}
  # end

  setup %{conn: conn} do
    user = user_fixture() |> confirm_email()
    %{conn: log_in_user(conn, user), user: user}
  end

  describe "Resend confirmation" do
    test "renders the resend confirmation page", %{conn: conn} do
      {:ok, _lv, html} = live(conn, ~p"/confirm")
      assert html =~ "Resend confirmation instructions"
    end

    test "sends a new confirmation token", %{conn: conn, user: user} do
      {:ok, lv, _html} = live(conn, ~p"/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", user: %{email: user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      assert Repo.get_by!(Accounts.UserToken, user_id: user.id).context == "confirm"
    end

    test "does not send confirmation token if user is confirmed", %{conn: conn, user: user} do
      Repo.update!(Accounts.User.confirm_changeset(user))

      {:ok, lv, _html} = live(conn, ~p"/confirm")

      {:ok, conn} =
        lv
        |> form("#resend_confirmation_form", user: %{email: user.email})
        |> render_submit()
        |> follow_redirect(conn, ~p"/")

      assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
               "If your email is in our system"

      refute Repo.get_by(Accounts.UserToken, user_id: user.id)
    end

    # test "does not send confirmation token if email is invalid", %{conn: conn} do
    #   {:ok, lv, _html} = live(conn, ~p"/confirm")

    #   {:ok, conn} =
    #     lv
    #     |> form("#resend_confirmation_form", user: %{email: "unknown@example.com"})
    #     |> render_submit()
    #     |> follow_redirect(conn, ~p"/")

    #   assert Phoenix.Flash.get(conn.assigns.flash, :info) =~
    #            "If your email is in our system"

    #   assert Repo.all(Accounts.UserToken) == []
    # end
  end
end
