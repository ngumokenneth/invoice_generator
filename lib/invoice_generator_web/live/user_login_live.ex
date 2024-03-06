defmodule InvoiceGeneratorWeb.UserLoginLive do
  use InvoiceGeneratorWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="grid lg:grid-cols-2 ">
      <div class="hidden lg:block">
        <div class="lg:block">
          <img src="../images/cover_image.png" alt="" />
        </div>
      </div>

      <div class="flex flex-col items-center justify-center w-full mx-3 ">
        <div class="relative hidden lg:block bottom-24 right-52 ">
          <div class="flex items-center">
            <img src="../images/right_arrow.svg" alt="" />
            <p class="text-[#7C5DFA]"><.link navigate={~p"/"}>Back</.link></p>
          </div>
        </div>
        <div class="hidden lg:block">
          <div class="flex flex-col items-center">
            <div class="flex items-center">
              <img src="../images/logo.svg" alt="company logo" class="w-20" />
              <p class="text-[#7C5DFA] px-4 font-bold text-5xl">Invoice</p>
            </div>
          </div>
        </div>
        <div class="">
          <h1 class="mt-4 text-2xl font-bold text-center lg:py-4">
            Sign in to Invoice
          </h1>
          <div class="-mt-4">
            <.simple_form for={@form} id="login_form" action={~p"/log_in"} phx-update="ignore">
              <.input field={@form[:email]} type="email" label="Email" required />
              <.input field={@form[:password]} type="password" label="Password" required />
              <:actions>
                <.input
                  field={@form[:remember_me]}
                  type="checkbox"
                  label="Keep me logged in"
                  class="lg:hidden"
                />
                <.link href={~p"/reset_password"} class="text-sm font-semibold">
                  Forgot your password?
                </.link>
              </:actions>
              <:actions>
                <.button
                  phx-disable-with="Signing in..."
                  class="w-full rounded bg-[#7C5DFA] hover:bg-blue-500"
                >
                  Continue
                </.button>
              </:actions>
            </.simple_form>
            <p class="hidden py-3 text-center lg:block">
              Don't have an account?<span class="text-[#7C5DFA]"><.link navigate={~p"/register"}></.link> Sign Up</span>
            </p>
          </div>
          <div class="lg:hidden">
            <p class="mt-2">
              Don't have an account?
              <.link navigate={~p"/register"} class="font-semibold text-brand hover:underline">
                Sign up
              </.link>
              for an account now.
            </p>
            <div class="flex justify-center py-4 ">
              <div class="flex items-center ">
                <hr class="w-48 h-1 bg-gray-100 dark:bg-[#00000080]" />
              </div>
              <span class="px-3">or with</span>
              <div class="flex items-center">
                <hr class="w-48 h-1 bg-gray-100 dark:bg-[#00000080]" />
              </div>
            </div>
            <div class=" flex justify-center py-1 px-3 rounded-lg md:rounded-lg border-[#888EB0] mt-2 border">
              <img src="../images/google.svg" alt="Google logo" />
              <button class="px-2 ">Sign in with Google</button>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(_params, _session, socket) do
    email = live_flash(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
