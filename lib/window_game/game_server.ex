defmodule WindowGame.GameServer do
  use GenServer

  @refresh_interval 100

  # API
  def join() do
    GenServer.call(__MODULE__, {:join, self()})
  end

  def report(screen_pos_size) do
    GenServer.cast(__MODULE__, {:report, self(), screen_pos_size})
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl GenServer
  def init(_) do
    schedule_ticker()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:join, pid}, _from, map) do
    IO.puts("#{inspect(pid)} JOINED")
    Process.monitor(pid)
    {:reply, {:ok, Enum.count(map)}, Map.put_new(map, pid, nil)}
  end

  @impl GenServer
  def handle_cast({:report, pid, screen_pos_size}, map) do
    {:noreply, %{map | pid => screen_pos_size}}
  end

  @impl GenServer
  def handle_info(:tick, map) do
    schedule_ticker()

    map
    |> Map.keys()
    |> Enum.each(fn pid -> send(pid, {:global_state, map}) end)

    {:noreply, map}
  end

  def handle_info({:DOWN, _, :process, client_pid, _}, map) do
    schedule_ticker()
    IO.puts("Client process #{inspect(client_pid)} down")
    {:noreply, Map.delete(map, client_pid)}
  end

  def handle_info(msg, map) do
    schedule_ticker()
    IO.inspect(msg, label: "HANDLE INFO")
    {:noreply, map}
  end

  defp schedule_ticker() do
    Process.send_after(self(), :tick, @refresh_interval)
  end
end
