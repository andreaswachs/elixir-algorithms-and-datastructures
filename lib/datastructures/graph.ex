defmodule Graph do
  @moduledoc """
  This module supports the graph data structure
  Common operations will also be supported in the future,
  but algorithms that utilize a graph data structure might be
  written elsewhere (not sure yet).


  The graph will be implemented as an adjacency list, with the vertices as keys in a map
  This means that the keys in the graph map will be the vertex number that will hold a value
  that is a list of Edge structs that hold properties of each given edge
  """
  defstruct vertices: 0, edges: 0

  @spec new(Integer) :: {:error, String.t()} | {:ok, %Graph{edges: 0, vertices: 0}}
  def new(size) when size > 0 do
    create_graph(%Graph{}, 0, size)
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

  def add_edge(%Graph{vertices: vertices, edges: edges} = graph, from, to, weight \\ 0, directed \\ false)
      when from < vertices and to < vertices do
        graph
        |> Map.get(from, [])
        |> List.insert_at(0, Edge.new(from, to, weight))
        |> then(fn adj_list -> %{graph | from => adj_list, edges: edges + 1} end)
        |> then(fn new_graph -> if directed, do: add_edge(new_graph, to, from, weight), else: new_graph end)
  end
end
