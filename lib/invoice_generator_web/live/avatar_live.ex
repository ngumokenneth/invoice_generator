defmodule InvoiceGeneratorWeb.AvatarLive do
  @moduledoc false
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts
  alias InvoiceGenerator.Accounts.User

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <section class="lg:grid grid-cols-2">
      <div class="hidden lg:block  overflow-hidden">
        <img src="../images/cover_image.png" alt="" class="h-[100vh] w-full" />
      </div>
      <div class=" flex flex-col items-center ">
        <div class="h-screen bg-green-300 w-full flex flex-col ">
          <.header class="pt-3 lg:pt-9 w-full bg-gray-300 flex flex-col items-center">
            <div class="flex items-center  w-full pt-12">
              <div>
                <img src="../images/logo.svg" alt="company logo" class="w-8" />
              </div>
              <p class="text-[#7C5DFA] px-4 font-bold text-3xl">Invoice</p>
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

          <%!-- <%= inspect(@uploads.avatar) %> --%>
          <div class="w-full   bg-white flex flex-col items-center">
            <div>
              <h2 class="pt-8 pb-6 font-bold lg:text-2xl  w-full">Add an avatar</h2>
              <div class="flex items-center gap-6">
                <div
                  phx-drop-target={@uploads.avatar.ref}
                  class=" w-24 h-24 rounded-full border border-2 border-dashed flex justify-center"
                >
                  <img src="../images/user_icon.svg" alt="user icon" class="w-10" />
                </div>
                <label for="avatar">
                  <div class=" flex items-center ">
                    <div class="mr-4">
                      <.live_file_input upload={@uploads.avatar} class="sr-only" />
                    </div>
                    <span class="text-white font-bold bg-[#7C5DFA] hover:opacity-75 px-4 py-2 rounded-full cursor-pointer">
                      Choose Image
                    </span>
                  </div>
                  <div class="flex justify-end">
                    <.button class="bg-[#979797] px-4 rounded-full mt-4">
                      <%= live_patch("Continue", to: "/address") %>
                    </.button>
                  </div>
                </label>
              </div>
            </div>
            <div>
              <%= for avatar <- @uploads.avatar.entries do %>
                <div>
                  <.live_img_preview entry={avatar} />
                  <button
                    type="button"
                    phx-click="cancel-upload"
                    phx-value-ref={avatar.ref}
                    aria-label="cancel"
                  >
                    &times;
                  </button>
                  <%= for err <- upload_errors(@uploads.avatar, avatar) do %>
                    <p class="alert alert-danger"><%= error_to_string(err) %></p>
                  <% end %>
                </div>
              <% end %>
            </div>
            <div>
              <%= for err <- upload_errors(@uploads.avatar) do %>
                <p class="alert alert-danger"><%= error_to_string(err) %></p>
              <% end %>
            </div>
          </div>
          <div class="pt-5 lg:hidden w-full">
            <img src="../images/footer_rectangle.png" alt="" class="w-full" />
          </div>
        </div>
      </div>
    </section>
    """
  end

  def error_to_string(:too_large), do: "Too large"
  def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    socket =
      allow_upload(socket, :avatar,
        accept: ~w(.jpeg .jpg .png),
        max_entries: 1,
        max_file_size: 10_000_000
      )

    {:ok, socket}
  end

  @impl Phoenix.LiveView

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl Phoenix.LiveView
  def handle_event("save", _params, socket) do
    uploaded_files =
      consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
        IO.inspect(path)
        IO.inspect(entry)

        dest =
          Path.join(
            Application.app_dir(:invoice_generator, "priv/static/uploads"),
            Path.basename(path)
          )

        # You will need to create `priv/static/uploads` for `File.cp!/2` to work.
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    IO.inspect(uploaded_files)
    {:noreply, socket}
  end

  # def handle_event("save", %{"avatar" => user_params}, socket) do
  #   changeset = Accounts.change_user_registration(%User{}, user_params)
  #   {:noreply, assign(socket, Map.put(changeset, :action, :validate))}
  # end

  # create changeset to update avatar in db
end
