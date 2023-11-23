defmodule WindowGame.SimpleClient do
  alias WindowGame.GameServer

  def start_client() do
    spawn(fn -> do_start_client() end)
  end

  defp do_start_client() do
    GameServer.join()
    loop()
  end

  defp loop() do
    receive do
      :stop ->
        IO.puts("shutdown #{inspect(self())}")
        :ok

      {:update, {x, y, w, h}} ->
        GameServer.report({x, y, w, h})
        loop()

      msg ->
        IO.puts("#{inspect(self())} recv: #{inspect(msg)}")
        loop()
    end
  end
end
