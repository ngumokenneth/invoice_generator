defmodule InvoiceGeneratorWeb.CustomComponents do
  use InvoiceGeneratorWeb, :html

  def logo_icon(assigns) do
    ~H"""
    <svg xmlns="http://www.w3.org/2000/svg" width="85" height="80" viewBox="0 0 85 80" fill="none">
      <path
        fill-rule="evenodd"
        clip-rule="evenodd"
        d="M22.1763 0.108887L42.4672 40.6907L62.7581 0.109081C75.9694 7.30834 84.934 21.3193 84.934 37.424C84.934 60.8779 65.9209 79.891 42.467 79.891C19.0131 79.891 0 60.8779 0 37.424C0 21.3191 8.96477 7.30809 22.1763 0.108887Z"
        fill="#7C5DFA"
      />
    </svg>
    """
  end
end