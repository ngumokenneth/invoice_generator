defmodule InvoiceGeneratorWeb.UserRegistrationLive do
  use InvoiceGeneratorWeb, :live_view

  alias InvoiceGenerator.Accounts
  alias InvoiceGenerator.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-full  w-full lg:grid grid-cols-2">
      <div class="overflow-hidden hidden lg:block">
        <img src="../images/cover_image.png" alt="" class="h-[100vh] w-full" />
      </div>

      <div class="lg:flex  flex-col justify-center items-center ">
        <div class="relative hidden lg:block  bottom-20 right-56 ">
          <div class="flex items-center">
            <img src="../images/right_arrow.svg" alt="" />
            <p class="text-[#7C5DFA]">Back</p>
          </div>
        </div>
        <div class="hidden lg:block -mt-6  w-full ">
          <div class="flex items-center justify-center ">
            <img src="../images/logo.svg" alt="company logo" class="w-8" />
            <p class="text-[#7C5DFA] px-4 font-bold text-3xl">Invoice</p>
          </div>
        </div>
        <.header class="text-center text-start px-8 lg:mt-8">
          <p class="text-3xl font-bold lg:font-semibold ">Create an Account</p>
          <:subtitle>
            <subtitle class="text-sm ">Begin Creating Invoices For Free!</subtitle>
          </:subtitle>
        </.header>
        <div class="w-full px-8">
          <.simple_form
            for={@form}
            id="registration_form"
            phx-submit="save"
            phx-change="validate"
            phx-trigger-action={@trigger_submit}
            action={~p"/users/log_in?_action=registered"}
            method="post"
          >
            <.error :if={@check_errors}>
              Oops, something went wrong! Please check the errors below.
            </.error>
            <div class="lg:flex gap-4">
              <.input
                field={@form[:name]}
                type="text"
                placeholder="Enter Your Name"
                label="Name"
                required
              />
              <.input
                field={@form[:username]}
                type="text"
                placeholder="Enter Your Username"
                label="Username"
                required
              />
            </div>
            <.input
              field={@form[:email]}
              type="email"
              placeholder="Enter Your Email"
              label="Email"
              required
            />
            <.input field={@form[:password]} type="password" label="Password" required />
            <:actions>
              <.button
                phx-disable-with="Creating account..."
                class="w-full bg-[#7C5DFA80] hover:bg-[#7C5DFA] lg:mt-4"
              >
                Sign Up
              </.button>
            </:actions>
          </.simple_form>
        </div>
        <div class="mt-4 lg:mt-6 px-8">
          Already have an account?
          <.link navigate={~p"/users/log_in"} class="text-brand text-[#7C5DFA] hover:underline">
            Login
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false)
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
