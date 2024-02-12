defmodule InvoiceGeneratorWeb.UserConfirmationInstructionsLive do
  use InvoiceGeneratorWeb, :live_view

  alias InvoiceGenerator.Accounts

  def render(assigns) do
    ~H"""
    <div class=" flex flex-col justify-center items-center h-screen ">
      <div class=" w-6/12 flex flex-col justify-center bg-[#7C5DFA33]  px-8 py-4  rounded-lg">
        <.header class="text-center">
          Confirm your email address
        </.header>

        <div class="mx-4">
          <p>
            We've sent a confirmation email to
            <span class="font-bold"><%= @current_user.email %></span>
          </p>
          <p>Please follow the link in the message to confirm your email address.</p>
          <p>If you did not receive the email, please check your spam folder or:</p>
          <.form for={@form} id="resend_confirmation_form" phx-submit="send_instructions">
            <.button phx-disable-with="Sending..." class="w-full my-6 mr-2">
              Resend confirmation instructions
            </.button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    IO.inspect(socket)
    {:ok, assign(socket, form: to_form(%{}, as: "user"))}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/confirm/#{&1}")
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
