defmodule ClusterTest do
  defmodule Reporter do
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

  def start(_type, _args) do
    topologies = [
      gossip_example: [
        strategy: Cluster.Strategy.Gossip,
        config: [
          port: 45892,
          if_addr: "0.0.0.0",
          multicast_addr: "230.1.1.251",
          multicast_ttl: 1,
          secret: "somepassword"
        ]
      ]
    ]

    children = [
      {Cluster.Supervisor, [topologies, [name: ClusterTest.ClusterSupervisor]]},
      Supervisor.child_spec({__MODULE__.Reporter, __MODULE__.Reporter}, id: :local_reporter),
      Supervisor.child_spec({__MODULE__.Reporter, {:global, __MODULE__.Reporter}}, id: :global_reporter)
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end

  defmodule Util do
    def start_link_maybe_global(fun) do
      case fun.() do
        {:error, {:already_started, pid}} ->
          Task.start_link(fn ->
            ref = Process.monitor(pid)

            receive do
              {:DOWN, ^ref, :process, _, _} ->
                Logger.warn("Lost connection to #{inspect(name)}")
                :stop
            end
          end)

        other ->
          other
      end
    end
  end
end
