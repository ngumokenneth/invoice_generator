defmodule InvoiceGeneratorWeb.UserLoginLive do
  use InvoiceGeneratorWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="grid lg:grid-cols-2 ">
      <div class="bg-green-300 hidden lg:block">
        <div class="bg-red-400 hidden lg:block">
          <div class=" w-full hidden lg:block bg-red-500">
            <img src="../images/cover_image.png" alt="" />
          </div>
        </div>
      </div>

      <div class="px-8 flex flex-col justify-center items-center">
        <div class="lg:relative hidden lg:block  bottom-56 right-60 ">
          <div class="flex items-center">
            <img src="../images/right_arrow.svg" alt="" />
            <p class="text-[#7C5DFA]">Back</p>
          </div>
        </div>
        <div class="hidden lg:block -mt-48  w-full ">
          <div class="flex items-center justify-center ">
            <img src="../images/logo.svg" alt="company logo" class="w-8" />
            <p class="text-[#7C5DFA] px-4 font-bold text-3xl">Invoice</p>
          </div>
        </div>
        <div class=" w-full ">
          <h1 class="text-center text-2xl font-bold mt-4">
            Sign in to Invoice
          </h1>
          <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
            <.input field={@form[:email]} type="email" label="Email" required />
            <.input field={@form[:password]} type="password" label="Password" required />
            <:actions>
              <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
              <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
                Forgot your password?
              </.link>
            </:actions>
            <:actions>
              <.button phx-disable-with="Signing in..." class="w-full">
                Log in <span aria-hidden="true">→</span>
              </.button>
            </:actions>
          </.simple_form>
          <p class="my-4">
            Don't have an account?
            <.link navigate={~p"/users/register"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </p>
          <div class="flex justify-center py-4">
            <div class="  flex items-center">
              <hr class="w-48 h-1 bg-gray-100 dark:bg-[#00000080]" />
            </div>
            <span class=" px-3">or with</span>
            <div class="flex items-center">
              <hr class="w-48 h-1 bg-gray-100 dark:bg-[#00000080]" />
            </div>
          </div>
          <div class=" flex justify-center mt-4 py-1 px-3 rounded-lg md:rounded-lg border-[#888EB0] border">
            <img src="../images/google.svg" alt="Google logo" />
            <button class=" px-2 ">Sign in with Google</button>
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
