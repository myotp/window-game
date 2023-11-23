defmodule WindowGameWeb.GameLive do
  use Phoenix.LiveView, layout: false

  @screen_report_interval 2000

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_screen_timer()
    end

    {:ok, socket}
  end

  @impl true
  def handle_event("screen-response", %{"x" => x, "y" => y, "width" => w, "height" => h}, socket) do
    IO.inspect({x, y, w, h}, label: "SCREEN")
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_screen_timer()
    {:noreply, push_event(socket, "my-screen-event", %{})}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div id="some-unique-id" phx-hook="SendScreenPosition">
      Hello!
    </div>
    """
  end

  defp schedule_screen_timer() do
    Process.send_after(self(), :tick, @screen_report_interval)
  end
end
