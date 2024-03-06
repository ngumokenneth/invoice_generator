defmodule InvoiceGeneratorWeb.AddressLive do
  @moduledoc false
  alias InvoiceGenerator.Accounts
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts.Address

  def render(assigns) do
    ~H"""
    <section class="h-screen grid-cols-2 lg:grid ">
      <div class="hidden lg:block">
        <div class="lg:block">
          <img src="../images/cover_image.png" alt="" />
        </div>
      </div>

      <div class="flex flex-col items-center justify-center w-full">
        <div class="w-full px-5 lg:px-16">
          <.header class="my-8">
            <div class="hidden lg:relative lg:block bottom-40 right-12 ">
              <div class="flex items-center ">
                <img src="../images/right_arrow.svg" alt="" />
                <p class="text-[#7C5DFA]"><.link navigate={~p"/"}>Back</.link></p>
              </div>
            </div>
            <div class="flex flex-col">
              <div class="flex items-center lg:justify-center">
                <img src="../images/logo.svg" alt="company logo" class="w-10 lg:w-16" />
                <p class="text-[#7C5DFA] px-4 font-bold text-3xl lg:text-4xl">Invoice</p>
              </div>
              <p class="w-9/12 py-4 lg:pt-12 lg:w-full">Enter your business address details:</p>
            </div>
          </.header>
          <div class="w-full -mt-10">
            <.simple_form
              for={@form}
              id="address_form"
              phx-change="validate"
              phx-submit="save_address"
              action={~p"/address"}
            >
              <div class="lg:flex place-content-between">
                <.input
                  field={@form[:country]}
                  type="text"
                  placeholder="Choose Your Country"
                  phx-debounce="blur"
                >
                  Country
                </.input>
                <.input
                  field={@form[:city]}
                  type="text"
                  placeholder="City Name"
                  phx-debounce="blur"
                  required
                >
                  city
                </.input>
              </div>
              <.input
                field={@form[:street_address]}
                placeholder="Street Address"
                phx-debounce="blur"
                required
              >
                Street Address
              </.input>
              <.input
                field={@form[:postal_code]}
                placeholder="Postal Code"
                phx-debounce="blur"
                required
              >
                Postal Code
              </.input>
              <.input
                field={@form[:phone_number]}
                placeholder="Phone Number"
                phx-debounce="blur"
                required
              >
                Postal Code
              </.input>
              <div class="flex gap-4 lg:justify-end place-content-between">
                <.button class="lg:hidden px-16 rounded-full text-black bg-[#FFFFFF] border">
                  <.link navigate={~p"/profile"}>Back</.link>
                </.button>
                <.button phx-disable-with="Saving..." class=" rounded-full bg-[#7C5DFA] px-16">
                  Save
                </.button>
              </div>
            </.simple_form>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    form = to_form(Address.changeset(%Address{}), as: "address")

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
         |> IO.inspect(label: "flash_socket")
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
