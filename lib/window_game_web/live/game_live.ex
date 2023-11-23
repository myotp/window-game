defmodule WindowGameWeb.GameLive do
  use Phoenix.LiveView, layout: false
  alias WindowGame.GameServer

  @screen_report_interval 50

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket) do
      schedule_screen_timer()
      GameServer.join()
    end

    socket =
      assign(socket,
        rotate_degree: 0,
        pos1: nil,
        pos2: nil
      )

    {:ok, socket}
  end

  @impl true
  def handle_event("screen-response", %{"x" => x, "y" => y, "width" => w, "height" => h}, socket) do
    pos1 = {x + round(w / 2), y + round(h / 2)}
    socket = assign(socket, :pos1, pos1)
    GameServer.report(pos1)
    {:noreply, socket}
  end

  @impl true
  def handle_info(:tick, socket) do
    schedule_screen_timer()
    {:noreply, push_event(socket, "my-screen-event", %{})}
  end

  def handle_info({:global_state, game_state}, socket) do
    pos2 = get_pos2(game_state)
    socket = assign(socket, :pos2, pos2)
    rotate_degree = calculate_rotate_degree(socket.assigns.pos1, socket.assigns.pos2)
    socket = assign(socket, rotate_degree: rotate_degree)
    {:noreply, socket}
  end

  defp get_pos2(game_state) do
    player2 =
      game_state
      |> Map.delete(self())
      |> Enum.to_list()

    case player2 do
      [] ->
        nil

      [{_pid, pos2}] ->
        pos2
    end
  end

  defp schedule_screen_timer() do
    Process.send_after(self(), :tick, @screen_report_interval)
  end

  defp calculate_rotate_degree(nil, _), do: 0
  defp calculate_rotate_degree(_, nil), do: 0

  defp calculate_rotate_degree({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1
    round(:math.atan2(dy, dx) * 180 / :math.pi())
  end
end
