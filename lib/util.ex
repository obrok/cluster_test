defmodule Util do
  require Logger

  def start_link_maybe_global(fun) do
    case fun.() do
      {:error, {:already_started, pid}} ->
        Task.start_link(fn ->
          ref = Process.monitor(pid)

          receive do
            {:DOWN, ^ref, :process, _, _} ->
              Logger.warn("Lost connection to #{inspect(pid)}")
              :stop
          end
        end)

      other ->
        other
    end
  end
end
