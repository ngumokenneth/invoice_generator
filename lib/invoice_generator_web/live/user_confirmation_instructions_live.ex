defmodule InvoiceGeneratorWeb.UserConfirmationInstructionsLive do
  use InvoiceGeneratorWeb, :live_view

  alias InvoiceGenerator.Accounts

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm bg-[#7C5DFA33]">
      <.header class="text-center">
        Confirm your email address
        <:subtitle>
          We've sent a confirmation email to  Please follow the link in the message to confirm your email address.
          If you did not receive the email, please check your spam folder or:
        </:subtitle>
      </.header>

      <.simple_form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
        <%!-- <.input field={@form[:email]} type="email" placeholder="Email" required /> --%>
        <:actions>
          <.button phx-disable-with="Sending..." class="w-full relative">
            Resend confirmation instructions
          </.button>
        </:actions>
      </.simple_form>

      <%!-- <p class="text-center mt-4">
        <.link href={~p"/users/register"}>Register</.link>
        | <.link href={~p"/users/log_in"}>Log in</.link>
      </p> --%>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    IO.inspect(socket.assigns.current_user)

    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
