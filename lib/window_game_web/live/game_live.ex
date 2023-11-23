defmodule WindowGameWeb.GameLive do
  use Phoenix.LiveView, layout: false

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_event(event, _unsigned_params, socket) do
    IO.inspect(event, label: "EVENT")
    {:noreply, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    Hello!
    """
  end
end
