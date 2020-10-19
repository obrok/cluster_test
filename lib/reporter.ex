defmodule ClusterTest.Reporter do
  require Logger

  use GenServer

  def start_link(name) do
    Util.start_link_maybe_global(fn ->
      GenServer.start_link(__MODULE__, name, name: name)
    end)
  end

  def init(name) do
    :timer.send_interval(:timer.seconds(1), :report)
    {:ok, name}
  end

  def handle_info(:report, name) do
    require Logger

    Logger.info("Reporting #{inspect(name)}")
    {:noreply, name}
  end
end
