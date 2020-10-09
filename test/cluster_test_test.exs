defmodule ClusterTestTest do
  use ExUnit.Case
  doctest ClusterTest

  test "greets the world" do
    assert ClusterTest.hello() == :world
  end
end
