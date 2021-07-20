defmodule Graph.BFS do


  @spec run(%Graph{}, non_neg_integer()) :: [{non_neg_integer(), non_neg_integer()}]
  def run(%Graph{vertices: vertices} = graph, source) when is_nil(graph) or source >= vertices do
    []
  end

  def run(graph, source) do
    :queue.new()
    |> then(&:queue.in(source, &1))
    |> then(&run_server(graph, &1, [], []))
  end

  defp run_server(graph, queue, components, visited_edges) do
    case :queue.out(queue) do
      {{:value, vertex}, new_queue} ->
        case vertex in visited_edges do
          false -> Graph.adjacent_vertices(graph, vertex)
                    |> then(&run_server(graph, enqueue_adjacent_vertices(new_queue, &1), transform_adjacency_list(&1) ++ components, [vertex] ++ visited_edges))
          true -> run_server(graph, new_queue, components, visited_edges)
        end

      {:empty, _} -> components |> sanitize_adjacency_pairs() |> Enum.reverse()
    end
  end

  defp enqueue_adjacent_vertices(queue, []), do: queue

  defp enqueue_adjacent_vertices(queue, [head | tail] = _adjacency_list) do
    head.to
    |> :queue.in(queue)
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

end
