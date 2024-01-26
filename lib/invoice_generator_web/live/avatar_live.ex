defmodule InvoiceGeneratorWeb.AvatarLive do
  @moduledoc false
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts
  alias InvoiceGenerator.Accounts.User

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="bg-red-400 h-screen">
    <.header>
      Welcome let's create your profile
    </.header>
    <p>Just a few more steps</p>
    <%!-- <%= inspect(@uploads.avatar) %> --%>

    <div>
      <div class="grid grid-cols-2 bg-red-300 ">
        <div class="flex justify-center">
          <div
            phx-drop-target={@uploads.avatar.ref}
            class=" w-24 h-24 rounded-full border border-dashed flex justify-center"
          >
            <img src="../images/user_icon.svg" alt="user icon" class="w-10" />
          </div>
        </div>
        <div class="bg-gray-200 flex items-center">
          <form id="upload-form" phx-submit="save" phx-change="validate">
            <.live_file_input upload={@uploads.avatar} />
            <%!-- <button type="submit" class="bg-blue-400 rounded-full py-2 px-4">Upload</button> --%>
          </form>
        </div>
      </div>
      <div class="flex justify-end">
        <.button class="bg-[#979797] rounded-full mt-4">
          <%= live_patch("Continue", to: "/address") %>
        </.button>
      </div>
      <div>
        <%= for entry <- @uploads.avatar.entries do %>
          <article class="upload-entry">
            <figure>
              <.live_img_preview entry={entry} />
              <figcaption><%= entry.client_name %></figcaption>
            </figure>

            <progress value={entry.progress} max="100"><%= entry.progress %>%</progress>

            <button
              type="button"
              phx-click="cancel-upload"
              phx-value-ref={entry.ref}
              aria-label="cancel"
            >
              &times;
            </button>

            <%= for err <- upload_errors(@uploads.avatar, entry) do %>
              <%!-- <p class="alert alert-danger"><%= error_to_string(err) %></p> --%>
            <% end %>
          </article>
        <% end %>
      </div>
      <div>
        <%= for err <- upload_errors(@uploads.avatar) do %>
          <%!-- <p class="alert alert-danger"><%= error_to_string(err) %></p> --%>
        <% end %>
      </div>
    </div>
  </div>
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

  def handle_event("save", %{"avatar" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign(socket, Map.put(changeset, :action, :validate))}
  end

  # create changeset to update avatar in db
end
