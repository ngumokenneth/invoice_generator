defmodule InvoiceGeneratorWeb.UserForgotPasswordLive do
  use InvoiceGeneratorWeb, :live_view

  alias InvoiceGenerator.Accounts

  def render(assigns) do
    ~H"""
    <div class="grid lg:grid-cols-2">
      <div class="hidden lg:block">
        <div class="hidden lg:block overflow-hidden">
          <img src="../images/cover_image.png" alt="" class="h-[100vh] w-full" />
        </div>
      </div>
      <div class="h-screen flex items-center">
        <div class="mx-auto max-w-sm w-full">
          <.header class="text-center">
            Forgot your password?
            <:subtitle>
              Enter the email that you used to create your account and we will send you a link
              to reset your password.
            </:subtitle>
          </.header>
          <.simple_form for={@form} id="reset_password_form" phx-submit="send_email">
            <.input field={@form[:email]} type="email" placeholder="Email" required />
            <:actions>
              <.button phx-disable-with="Sending..." class="w-full bg-[#7C5DFA]">
                Send reset link
              </.button>
            </:actions>
          </.simple_form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_email", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_reset_password_instructions(
        user,
        &url(~p"/users/reset_password/#{&1}")
      )
    end

    info =
      "If your email is in our system, you will receive instructions to reset your password shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
