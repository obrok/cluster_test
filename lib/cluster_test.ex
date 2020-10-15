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
      ec_example: [
        strategy: ClusterEC2.Strategy.Tags,
        config: [
          ec2_tagname: "cluster_test"
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
