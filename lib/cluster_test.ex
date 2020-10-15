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
          app_prefix: :cluster_test,
          ec2_tagname: "cluster_test",
          ip_to_nodename: &build_real_hostname/2,
          show_debug: true
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

  def build_real_hostname(list, app_prefix) when is_list(list) do
    list
    |> Enum.map(&String.replace(&1, ".", "-"))
    |> Enum.map(fn ip -> :"#{app_prefix}@ip-#{ip}" end)
  end
end
