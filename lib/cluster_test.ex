defmodule ClusterTest do
  defmodule Checker do
    use Task

    def start_link(_), do: Task.start_link(__MODULE__, :run, [])

    def run() do
      require Logger

      Logger.info("Connected to: #{inspect(:erlang.nodes())}")
      :timer.sleep(1000)
      run()
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
      __MODULE__.Checker
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end
