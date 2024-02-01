defmodule InvoiceGeneratorWeb.AddressLive do
  @moduledoc false
  alias InvoiceGenerator.Accounts
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts.Address

  def render(assigns) do
    ~H"""
    <.header>
      <p class="[#7C5DFA]">Logo</p>
      <p>Enter your business address details</p>
    </.header>
    <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save_address">
        <.input
          field={@form[:country]}
          type="text"
          placeholder="Choose Your Country"
          phx-debounce="blur"
        >
          Country
        </.input>
        <.input field={@form[:city]} type="text" placeholder="City Name" phx-debounce="blur" required>
          city
        </.input>
        <.input
          field={@form[:street_address]}
          placeholder="Street Address"
          phx-debounce="blur"
          required
        >
          Street Address
        </.input>
        <.input field={@form[:postal_code]} placeholder="Postal Code" phx-debounce="blur" required>
          Postal Code
        </.input>
        <.input field={@form[:phone_number]} placeholder="Phone Number" phx-debounce="blur" required>
          Postal Code
        </.input>
        <div class="flex gap-4 mt-4">
          <%!-- <.button class="w-full rounded-full"><%= live_patch("Back", to: "/profile") %></.button> --%>
          <.button phx-disable-with="Saving..." class="w-full rounded-full">Save</.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, %{"email" => email}, socket) do
    user = Accounts.get_user_by_email(email)
    form = to_form(Address.changeset(%Address{}))

    {:ok,
     socket
     |> assign(current_user: user)
     |> assign(trigger_submit: false, check_errors: false)
     |> assign(:form, form)}
  end

  def handle_event("validate", %{"address" => address_params}, socket) do
    form =
      %Address{}
      |> Address.changeset(address_params)
      |> Map.put(:action, :validate)
      |> to_form(as: "address")

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("save_address", params, socket) do
    user =
      socket.assigns.current_user
      |> IO.inspect(label: "user")

    IO.inspect(params, label: "address_params")

    case Accounts.update_user(user, params) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(current_user: user)
         |> put_flash(:info, "Address updated successfully")
         |> push_redirect(to: "/")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign(check_errors: true)
         |> assign(changeset)
         |> put_flash(:info, "Failed to update address")}
    end
  end
end
