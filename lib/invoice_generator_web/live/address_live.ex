defmodule InvoiceGeneratorWeb.AddressLive do
  @moduledoc false
  alias InvoiceGenerator.Accounts
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts.User

  def render(assigns) do
    ~H"""
    <.header>
      <p class="[#7C5DFA]">Logo</p>
      <p>Enter your business address details</p>
    </.header>
    <div>
      <.simple_form for={@form} phx-change="validate" phx-submit="save">
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
      </.simple_form>
    </div>
    <div class="flex gap-4 mt-4">
      <.button class="w-full rounded-full"><%= live_patch("Back", to: "/profile") %></.button>
      <.button phx-disable-with="Saving..." class="w-full rounded-full">Save</.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    form = to_form(Accounts.change_user_registration(%User{}))
    {:ok, assign(socket, :form, form)}
  end

  def handle_event("validate", %{"user" => address_params}, socket) do
    form =
      %User{}
      |> Accounts.change_user_registration(address_params)
      |> Map.put(:action, :validate)
      |> to_form(as: "user_address")

    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("validate", %{"user_address" => user_address_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_address_params)
    {:noreply, assign(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user_address} ->
        {:noreply,
         socket
         |> assign(user_address: user_address)
         |> put_flash(:info, "Address updated successfully")}
    end
  end
end
