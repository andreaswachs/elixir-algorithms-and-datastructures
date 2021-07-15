defmodule Graph do
  @moduledoc """
  This module supports the graph data structure
  Common operations will also be supported in the future,
  but algorithms that utilize a graph data structure might be
  written elsewhere (not sure yet).
  """
  defstruct vertices: 0, edges: 0, graph: {}

  @spec new(Integer) :: {:error, String.t()} | {:ok, %Graph{edges: 0, graph: {}, vertices: 0}}
  def new(size) when size > 0 do
    {:ok, create_graph(%Graph{}, 0, size)}
  end

  def new(size) when size <= 0 do
    {:error, "Size needs to be larger than 0"}
  end

  defp create_graph(graph, vertex, limit) when vertex >= limit do
    graph
  end

  defp create_graph(%Graph{vertices: vertices} = graph, vertex, limit) when vertex < limit do
    Map.put(graph, vertex, [])
    |> Map.put(:vertices, vertices + 1)
    |> create_graph(vertex + 1, limit)
  end

  ####################################################################################################
  # Functions to add edges between vertices
  # Should also support directed edges
  ####################################################################################################
end
