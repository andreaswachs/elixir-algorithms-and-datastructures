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

  test "get adjacent vertices for a connected component with one adjacent vertex" do
    graph =
      Graph.new(2)
      |> Graph.add_edge(0, 1)

    result = Graph.adjacent_vertices(graph, 0)

    assert 1 in result
    assert length(result) == 1
  end

  test "get adjacnt vertices for a disconnected component" do
    graph =
      Graph.new(2)

    result = Graph.adjacent_vertices(graph, 0)

    assert result == []
  end

  test "get adjacent vertices for a connected component with many adjacent vertices" do
    graph =
      Graph.new(4)
      |> Graph.add_edge(0, 1)
      |> Graph.add_edge(0, 2)
      |> Graph.add_edge(0, 3)

      result = Graph.adjacent_vertices(graph, 0)

      assert 1 in result
      assert 2 in result
      assert 3 in result
      assert length(result) == 3
  end

  test "get adjacent vertices in a nil graph" do
    graph = nil

    result = Graph.adjacent_vertices(graph, 0)

    assert result == []
  end

  test "get adjacent vertices in a graph not containing queried vertex" do
    graph = Graph.new(4)

    result = Graph.adjacent_vertices(graph, 5)

    assert result == []
  end

end
