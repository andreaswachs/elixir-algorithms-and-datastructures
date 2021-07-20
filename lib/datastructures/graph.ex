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

  @doc """
  Add an edge in a graph. Defaults to unweighted edges and takes care of the case that the graph
  is undirected

  ## Parameters
  - graph: The graph data structure from this module
  - from: the vertex id of the vertex where the edge goes from
  - to: the vertex id of the vertex where the edge goes to
  - weight: the weight of the edge (optional, default value: 0)

  ## Examples

  ```
  # Create an undirected graph with two vertices and add an edge between them
  graph = Graph.new(2) |> Graph.add_edge(0, 1)

  # Create a directed graph with two vertices and add an edge from vertex 0 to 1
  graph = Graph.new(2, true) |> Graph.add_edge(0, 1)
  ```
  """
  @spec add_edge(
          %Graph{:vertices => non_neg_integer()},
          non_neg_integer,
          non_neg_integer,
          integer
        ) :: %{
          :__struct__ => Graph | [...],
          :edges => number,
          :vertices => any,
          optional(any) => any
        }
  def add_edge(%Graph{vertices: vertices} = graph, from, to, weight \\ 0)
      when from < vertices and to < vertices do
      add_edge_server(graph, from, to, weight, not graph.directed)
  end

  defp add_edge_server(%Graph{vertices: vertices} = graph, from, to, weight, insert_inverse_edge)
      when from < vertices and to < vertices do
        graph
        |> Map.get(from, [])
        |> List.insert_at(0, Edge.new(from, to, weight))
        |> then(&update_adj_list(graph, from, &1, insert_inverse_edge))
        |> then(&maybe_insert_inverse_edge(&1,from, to, weight, insert_inverse_edge))
  end

  defp update_adj_list(graph, vertex, adj_list, insert_inverse_edge) do
    # Insert the updated adjacency list for the correct vertex and maybe update edges count
    %{graph | vertex => adj_list, edges: update_edges_count(graph, insert_inverse_edge)}
  end

  defp update_edges_count(%{edges: edges, directed: directed} = _graph, insert_inverse_edge) do
    cond do
      directed -> edges + 1
      not directed and not insert_inverse_edge -> edges + 1
      true -> edges
    end
  end

  defp maybe_insert_inverse_edge(graph, from, to, weight, insert_inverse_edge) do
    case insert_inverse_edge do
      true -> add_edge_server(graph, to, from, weight, false)
      false -> graph
    end
  end


  ##################################################################################################
  # Functions for supporting getting adjacent vertices in a graph
  ##################################################################################################

  @spec adjacent_vertices(%Graph{}, non_neg_integer()) :: [non_neg_integer()]
  def adjacent_vertices(nil, _vertex) do
    []
  end

  def adjacent_vertices(%Graph{vertices: vertices} = _graph, vertex) when vertex >= vertices do
    []
  end

  def adjacent_vertices(graph, vertex) do
    Map.get(graph, vertex, [])
  end

end
