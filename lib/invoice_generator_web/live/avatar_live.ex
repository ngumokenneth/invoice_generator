defmodule InvoiceGeneratorWeb.AvatarLive do
  @moduledoc false
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="lg:grid grid-cols-2">
      <div class="hidden lg:block">
        <div class="hidden lg:block  overflow-hidden">
          <img src="../images/cover_image.png" alt="" class="h-[100vh] w-full" />
        </div>
      </div>
      <div class="px-4 md:px-20">
        <.header class="pt-3 lg:pt-9 w-full flex flex-col ">
          <div class="flex items-center  w-full pt-12">
            <div>
              <img src="../images/logo.svg" alt="company logo" class="w-16" />
            </div>
            <p class="text-[#7C5DFA] px-4 font-bold text-4xl">Invoice</p>
          </div>
          <div class="pt-8">
            <p class="text-xl  font-semi-bold  ">
              Welcome let's create your profile
              <span class="text-[#979797]  w-full block text-md  font-light text-start">
                Just a few more steps...
              </span>
            </p>
          </div>
        </.header>
        <h2 class="mt-10 font-bold">Add an Avatar</h2>
        <div class="grid grid-cols-3">
          <section phx-drop-target={@uploads.avatar.ref} class="flex items-center  h-40">
            <div class="rounded-full h-32 w-32 border-2 border-dashed overflow-hidden border-[#979797]">
              <img src={@current_user.avatar} alt="" class="" />
            </div>
            <%= for entry <- @uploads.avatar.entries do %>
              <article class="upload-entry">
                <figure>
                  <.live_img_preview entry={entry} />
                  <figcaption><%= entry.client_name %></figcaption>
                </figure>

                <%= for err <- upload_errors(@uploads.avatar, entry) do %>
                  <p class="alert alert-danger"><%= error_to_string(err) %></p>
                <% end %>
              </article>
            <% end %>
            <%= for err <- upload_errors(@uploads.avatar) do %>
              <p class="alert alert-danger"><%= error_to_string(err) %></p>
            <% end %>
          </section>
          <.link navigate={~p"/address"}> kennne</.link>
          <form
            id="upload-form"
            phx-submit="save"
            phx-change="validate"
            class="flex flex-col text-white col-span-2"
          >
            <label class=" w-40 text-center my-auto  py-1 bg-[#7C5DFA] rounded-full font-semibold ml-4 hover:cursor-pointer">
              <.live_file_input class="hidden" upload={@uploads.avatar} />
              <span>Choose Image</span>
            </label>
            <button
              type="submit"
              navigate={~p"/address"}
              class="bg-[#979797] w-32 translate-x-16 rounded-full py-1 "
            >
              Continue
            </button>
          </form>
        </div>
      </div>
      <div class="pt-5 lg:hidden w-full">
        <img src="../images/footer_rectangle.png" alt="" class="w-full" />
      </div>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(_params, session, socket) do
    user = InvoiceGenerator.Accounts.get_user_by_session_token(session["user_token"])

    {:ok,
     socket
     |> assign(:current_user, user)
     |> assign(:uploaded_files, [])
     |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 2)}
  end

  @impl Phoenix.LiveView
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    case consume_uploads(socket) do
      [] ->
        {:noreply, socket}

      [hd | _] ->
        user =
          socket.assigns.current_user
          |> IO.inspect(label: "user data")

        attrs =
          %{avatar: hd}
          |> IO.inspect(label: "attrs data")

        case Accounts.update_user(user, attrs) do
          {:ok, user} ->
            {:noreply,
             socket
             |> assign(:current_user, user)}

          {:error, %Ecto.Changeset{} = _changeset} ->
            {:noreply, socket}
        end
    end
  end

  defp consume_uploads(socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
      IO.inspect(path)
      IO.inspect(entry)

      dest =
        Path.join(["priv", "static", "uploads", Path.basename(path)])
        |> IO.inspect(label: "destination string")

      File.cp!(path, dest)
      {:ok, ~p"/uploads/#{Path.basename(dest)}"}
    end)
  end

  defp error_to_string(:too_large), do: "Too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file type"
end
