defmodule ClusterTest do
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
end
