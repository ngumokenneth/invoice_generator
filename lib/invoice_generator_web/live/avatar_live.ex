defmodule InvoiceGeneratorWeb.AvatarLive do
  @moduledoc false
  use InvoiceGeneratorWeb, :live_view
  alias InvoiceGenerator.Accounts

  # @impl Phoenix.LiveView
  # def render(assigns) do
  #   ~H"""
  #   <section class="lg:grid grid-cols-2">
  #     <div class="hidden lg:block  overflow-hidden">
  #       <img src="../images/cover_image.png" alt="" class="h-[100vh] w-full" />
  #     </div>
  #     <div class=" flex flex-col items-center ">
  #       <div class="h-screen bg-green-300 w-full flex flex-col ">
  #         <.header class="pt-3 lg:pt-9 w-full bg-gray-300 flex flex-col items-center">
  #           <div class="flex items-center  w-full pt-12">
  #             <div>
  #               <img src="../images/logo.svg" alt="company logo" class="w-8" />
  #             </div>
  #             <p class="text-[#7C5DFA] px-4 font-bold text-3xl">Invoice</p>
  #           </div>
  #           <div class="pt-8">
  #             <p class="text-xl  font-semi-bold  ">
  #               Welcome let's create your profile
  #               <span class="text-[#979797]  w-full block text-md  font-light text-start">
  #                 Just a few more steps...
  #               </span>
  #             </p>
  #           </div>
  #         </.header>

  #         <%= inspect(@uploads.avatar) %>
  #         <%!-- <form id="upload-form" phx-submit="save" phx-change="validate">
  #           <.live_file_input upload={@uploads.avatar} />
  #           <button type="submit">Upload</button>
  #         </form> --%>
  #         <%!-- <form phx-submit="save">
  #           <div class="w-full   bg-white flex flex-col items-center">
  #             <div>
  #               <h2 class="pt-8 pb-6 font-bold lg:text-2xl  w-full">Add an avatar</h2>
  #               <div class="flex items-center gap-6">
  #                 <div
  #                   phx-drop-target={@uploads.avatar.ref}
  #                   class=" w-24 h-24 rounded-full border border-2 border-dashed flex justify-center"
  #                 >
  #                   <img src="../images/user_icon.svg" alt="user icon" class="w-10" />
  #                 </div>
  #                 <label for="avatar">
  #                   <div class=" flex items-center ">
  #                     <label class="mr-4 text-white font-bold bg-[#7C5DFA] hover:opacity-75 px-4 py-2 rounded-full cursor-pointer">
  #                       <.live_file_input upload={@uploads.avatar} class="sr-only" />
  #                       <span>
  #                         Choose Image
  #                       </span>
  #                     </label>
  #                   </div>
  #                   <div class="flex justify-end">
  #                     <.button class="bg-[#979797] px-4 rounded-full mt-4" type="submit">
  #                       Continue
  #                     </.button>
  #                   </div>
  #                 </label>
  #               </div>
  #             </div>
  #           </div>
  #           <div>
  #             <%= for avatar <- @uploads.avatar.entries do %>
  #               <div>
  #                 <.live_img_preview entry={avatar} />
  #                 <button
  #                   type="button"
  #                   phx-click="cancel-upload"
  #                   phx-value-ref={avatar.ref}
  #                   aria-label="cancel"
  #                 >
  #                   &times;
  #                 </button>
  #                 <%= for err <- upload_errors(@uploads.avatar, avatar) do %>
  #                   <p class="alert alert-danger"><%= error_to_string(err) %></p>
  #                 <% end %>
  #               </div>
  #             <% end %>
  #           </div>
  #           <div>
  #             <%= for err <- upload_errors(@uploads.avatar) do %>
  #               <p class="alert alert-danger"><%= error_to_string(err) %></p>
  #             <% end %>
  #           </div>
  #         </form> --%>
  #         <div class="pt-5 lg:hidden w-full">
  #           <img src="../images/footer_rectangle.png" alt="" class="w-full" />
  #         </div>
  #       </div>
  #     </div>
  #   </section>
  #   """
  # end

  # def error_to_string(:too_large), do: "Too large"
  # def error_to_string(:not_accepted), do: "You have selected an unacceptable file type"

  # @impl Phoenix.LiveView
  # def mount(_params, _session, socket) do
  #   socket =
  #     allow_upload(socket, :avatar,
  #       accept: ~w(.jpeg .jpg .png),
  #       max_entries: 1,
  #       max_file_size: 10_000_000
  #     )

  #   {:ok, socket}
  # end

  # @impl Phoenix.LiveView

  # def handle_event("validate", _params, socket) do
  #   {:noreply, socket}
  # end

  # @impl Phoenix.LiveView
  # def handle_event("save", _params, socket) do
  #   case consume_uploads(socket) do
  #     [] ->
  #       {:noreply, socket}

  #     [hd | _] ->
  #       user =
  #         socket.assigns.current_user
  #         |> IO.inspect(label: "user data")

  #       attrs =
  #         %{avatar: hd}
  #         |> IO.inspect(label: "attrs data")

  #       case Accounts.update_user(user, attrs) do
  #         {:ok, user} ->
  #           {:noreply, assign(socket, :current_user, user)}

  #         {:error, %Ecto.Changeset{} = _changeset} ->
  #           {:noreply, socket}
  #       end
  #   end
  # end

  # defp consume_uploads(socket) do
  #   consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
  #     IO.inspect(path)
  #     IO.inspect(entry)

  #     dest =
  #       Path.join(["priv", "static", "uploads", Path.basename(path)])
  #       |> IO.inspect(label: "destination string")

  #     File.cp!(path, dest)
  #     {:ok, ~p"/uploads/#{Path.basename(dest)}"}
  #   end)
  # end
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
