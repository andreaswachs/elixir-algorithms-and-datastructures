defmodule Graph do
  @moduledoc """
  This module supports the graph data structure
  Common operations will also be supported in the future,
  but algorithms that utilize a graph data structure might be
  written elsewhere (not sure yet).


  The graph will be implemented as an adjacency list, with the vertices as keys in a map
  This means that the keys in the graph map will be the vertex number that will hold a value
  that is a list of Edge structs that hold properties of each given edge.

  The graph defaults to being an undirected graph, if you're not inserting
  """
  defstruct vertices: 0, edges: 0, directed: false

  @spec new(non_neg_integer(), boolean()) :: %Graph{
          :directed => any,
          :edges => 0,
          :vertices => non_neg_integer
        }
  def new(size, directed \\ false) when size > 0 do
    create_graph(%Graph{directed: directed}, 0, size)
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

  @spec add_edge(
          %Graph{:edges => non_neg_integer(), :vertices => non_neg_integer()},
          non_neg_integer,
          non_neg_integer,
          integer,
          any
        ) :: %{
          :__struct__ => Graph | [...],
          :edges => number,
          :vertices => any,
          optional(any) => any
        }
  def add_edge(%Graph{vertices: vertices, edges: edges} = graph, from, to, weight \\ 0, insert_inverse_edge \\ false)
      when from < vertices and to < vertices do
        graph
        |> Map.get(from, [])
        |> List.insert_at(0, Edge.new(from, to, weight))
        |> then(fn adj_list -> %{graph | from => adj_list, edges: (unless insert_inverse_edge, do: edges + 1, else: edges)} end)
        # figure out why this goes into an infinite loop
        |> then(fn new_graph -> if not graph.directed and not insert_inverse_edge, do: add_edge(new_graph, to, from, weight, true), else: new_graph end)
  end


end
