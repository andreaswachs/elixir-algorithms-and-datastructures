defmodule Heapsort do
  @moduledoc """
  The Heapsort module provides an interface for performing heapsort.

  TODO: Explain later how the standard functions allow for regular heapsort usage
  and the special function to allow for a custom comparison function to sort
  funky data
  """

  def sort(data, :asc) do
    PriorityQueue.new_maxpq()
    |> handle_sort(data)
  end

  def sort(data, :desc) do
    PriorityQueue.new_minpq()
    |> handle_sort(data)
  end

  defp handle_sort(pq, data) do
    pq
    |> handle_insertion(data)
    |> handle_dequeueing()
  end

  defp handle_insertion(pq, []), do: pq

  defp handle_insertion(pq, [head | tail] = _data) do
    PriorityQueue.insert(pq, head)
    |> handle_insertion(tail)
  end

  defp handle_dequeueing(pq, acc \\ []) do
    case PriorityQueue.get_size(pq) do
      0 -> acc
      _ -> widthdraw_next_item(pq)
            |> then(fn {new_pq, value} -> handle_dequeueing(new_pq, [value] ++ acc) end)
    end
  end

  defp widthdraw_next_item(pq) do
    PriorityQueue.dequeue(pq)
    |> then(fn {:ok, new_pq, value} -> {new_pq, value} end)
  end
end
