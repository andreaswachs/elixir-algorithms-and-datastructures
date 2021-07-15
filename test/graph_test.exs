defmodule GraphTest do
  use ExUnit.Case
  doctest Graph

  test "can create graph" do
    graph = Graph.new(2)

    assert graph.edges == 0
    assert graph.vertices == 2
  end

  test "can add undirected edge to graph" do
    # the graph is undirected by default
    graph = Graph.new(2) |> Graph.add_edge(0, 1)

    assert graph.edges == 1
    assert graph.vertices == 2
    assert length(Map.get(graph, 0)) == 1
    assert length(Map.get(graph, 1)) == 1
  end

  test "can add edge to directed graph" do
    graph = Graph.new(2, true) |> Graph.add_edge(0, 1)

    assert graph.edges == 1
    assert graph.vertices == 2
    assert length(Map.get(graph, 0)) == 1
    assert length(Map.get(graph, 1)) == 0
  end

  test "can add three edges to undirected graph" do
    graph =
      Graph.new(3, false)
      |> Graph.add_edge(0, 1)
      |> Graph.add_edge(1, 2)
      |> Graph.add_edge(2, 0)

    assert graph.edges == 3
    assert graph.vertices == 3
    assert length(Map.get(graph, 0)) == 2
    assert length(Map.get(graph, 1)) == 2
    assert length(Map.get(graph, 2)) == 2
  end
end
