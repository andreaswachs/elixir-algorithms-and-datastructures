
defmodule BFSTest do
  use ExUnit.Case
  doctest Graph.BFS


  test "BFS finds identifies all three vertices in graph with three vertices" do
    # Arrange
    graph = Graph.new(3) |> Graph.add_edge(0, 1) |> Graph.add_edge(1, 2)

    # Act
    result = Graph.BFS.run(graph, 0)

    # Assert
    assert {0, 1} in result
    assert {1, 2} in result
    assert length(result) == 2
  end

  test "BFS finds single vertex that is not a connected component" do
    graph = Graph.new(3) |> Graph.add_edge(0, 1)

    result = Graph.BFS.run(graph, 2)

    assert result == []
  end

  test "BFS finds connected component in a graph with a single disconnected vertex" do
    graph = Graph.new(3) |> Graph.add_edge(0, 1)

    result = Graph.BFS.run(graph, 0)

    assert length(result) == 1
    assert {0, 1} in result
  end


  test "BFS finds self loop in a component with reflexive properties" do
    graph = Graph.new(3) |> Graph.add_edge(0, 1) |> Graph.add_edge(0, 0)

    result = Graph.BFS.run(graph, 0)

    assert length(result) == 2
    assert {0, 1} in result
    assert {0, 0} in result
  end
end
