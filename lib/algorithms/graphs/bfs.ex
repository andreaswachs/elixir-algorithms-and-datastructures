defmodule Graph.BFS do
  @moduledoc """
  This module allows users to run Breadth First Searches on graphs, from a source vertex.
  """


  @spec run(%Graph{}, non_neg_integer()) :: [{non_neg_integer(), non_neg_integer()}]
  def run(%Graph{vertices: vertices} = graph, source) when is_nil(graph) or source >= vertices do
    []
  end

  @doc """
  The run function finds a path to all other nodes in the graph by returning a list
  of tuples with vertices numbers {from, to}, showing that there is a path *from* a given vertex
  *to* another given vertex.

  This is the most barebones run of a BFS.

  ## Parameters

  - graph: The graph data structure with a minimum of a single vertex
  - source: The source vertex, which should be a non negative integer.

  ## Examples

  ```elixir
  iex> Graph.new(3) |> Graph.add_edge(0, 1) |> Graph.add_edge(1, 2) |> Graph.BFS.run(0)
  [{0, 1}, {1, 2}]
  ```
  """
  def run(graph, source) do
    :queue.new()
    |> then(&:queue.in(source, &1))
    |> then(&handle_run(graph, &1, [], []))
  end

  defp handle_run(graph, queue, components, visited_edges) do
    case :queue.out(queue) do
      {{:value, vertex}, new_queue} ->
        case vertex in visited_edges do
          false -> Graph.get_edges(graph, vertex)
                    |> then(&handle_run(graph,
                                        enqueue_adjacent_vertices(new_queue, &1),
                                        transform_adjacency_list(&1) ++ components,
                                        [vertex] ++ visited_edges))
          true -> handle_run(graph, new_queue, components, visited_edges)
        end

      {:empty, _} -> components |> sanitize_adjacency_pairs() |> Enum.reverse()
    end
  end

  defp enqueue_adjacent_vertices(queue, []), do: queue

  defp enqueue_adjacent_vertices(queue, [%Edge{to: to} = _head | tail] = _adjacency_list) do
    :queue.in(to, queue)
    |> enqueue_adjacent_vertices(tail)
  end

  defp transform_adjacency_list(adjacency_list) do
    # Transforms the list of edges to tuples with {from, to} vertices numbers
    [(for edge <- adjacency_list, do: {edge.from, edge.to})]
    |> List.flatten()
    |> sanitize_adjacency_pairs()
  end

  defp sanitize_adjacency_pairs([]), do: []

  defp sanitize_adjacency_pairs([{from, to} = pair | tail]) do
    cond do
      {to, from} in tail -> sanitize_adjacency_pairs(tail)
      true -> [pair] ++ sanitize_adjacency_pairs(tail)
    end
  end

  ##################################################################################################
  # Function(s) for using BFS to see if two vertices are connected
  ##################################################################################################

  @doc """
  Query a given graph to see if two vertices are connected to each other.
  This utilises the BFS, hence why this function is located here.

  Vertices are implicitly connected to themselves and therefore queries into the connectedness of the
  same vertex will always return true.

  ## Parameters

  - graph: The given graph, which is a struct from the Graph module
  - source: The source vertex, one of the vertices to check to see if it connected with the next
  - target: The target vertex, the other verte to see if it is coonnected with the source vertex

  ## Examples
  ```elixir
  iex> Graph.new(2) |> Graph.add_edge(0, 1) |> Graph.BFS.is_connected(0, 1)
  true

  iex> Graph.new(2) |> Graph.BFS.is_connected(0, 1)
  false

  iex> Graph.new(2) |> Graph.BFS.is_connected(0, 0)
  true
  ```
  """
  @spec is_connected(%Graph{}, non_neg_integer(), non_neg_integer()) :: boolean()
  def is_connected(nil, _, _), do: false
  def is_connected(%Graph{vertices: vertices} = _graph, source, target) when source >= vertices or target >= vertices, do: false
  def is_connected(_, source, target) when source < 0 or target < 0, do: false

  def is_connected(graph, source, target) do
    handle_is_connected(graph, source, target, Graph.BFS.run(graph, source))
  end

  defp handle_is_connected(_graph, source, target, _run) when source == target, do: true

  defp handle_is_connected(graph, source, target, connected_pairs) do
    case get_pairs_with_target(connected_pairs, target) do
      {:error, _} -> source == target
      {:ok, pairs_list} -> [(for {from, _} <- pairs_list, do: handle_is_connected(graph, source, from, connected_pairs))]
                          |> List.flatten()
                          |> then(fn result_list -> true in result_list end)
      end
  end

  defp get_pairs_with_target(pairs, target) do
    Enum.filter(pairs, fn {_, to} -> to == target end)
    |> then(fn
          [] -> {:error, "No connection to target"}
          list -> {:ok, list}
    end)
  end
end
