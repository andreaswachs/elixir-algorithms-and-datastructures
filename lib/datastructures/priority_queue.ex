defmodule PriorityQueue do
  @moduledoc """
  Provides an interface to maintain and use the PriorityQueue data type.

  This priority queue data type is implemented as a binary heap data structure.

  The first element in the tuple that represents the data structure is a map that
  contains the functions which to compare elements and meta data about the current
  state of the priority queue
  """

  @doc """
  Create a new priority queue with the judging function as the first element
  """
  @spec new(fun()) :: {%{fun: fun(), size: non_neg_integer()}}
  def new(fun), do: {%{fun: fun, size: 0}}

  @spec new_minpq :: {%{fun: fun, size: 0}}
  def new_minpq(), do: new(fn x, y -> x > y end)

  @spec new_maxpq :: {%{fun: fun, size: 0}}
  def new_maxpq(), do: new(fn x, y -> x < y end)

  ##################################################################################################
  # Here comes the function for inserting an item into the priority queue
  # followed by helper functions
  ##################################################################################################

  @doc """
  Insert an item into the priority queue. This will use the supplied function from
  creating the PQ to help insert the item correctly into the underlying binary heap
  as to maintain heap ordering

  ## Parameters

  - pq: The Priority Queue data structure provided by this module
  - item: The item which needs to be stored. Should be of same type or at least comparable to other items inserted

  ## Examples
  ```elixir

  iex> PriorityQueue.new_maxpq() |> PriorityQueue.insert(1) |> PriorityQueue.insert(100)
  {%{fun: #Function<0.128179959/2 in PriorityQueue.new_maxpq/0>, size: 2}, 100, 1}
  ```

  """
  @spec insert(tuple(), any()) :: tuple
  def insert(pq, item) do
    elem(pq, 0)
    |> then(&put_elem(pq, 0, %{&1 | size: &1.size + 1}))
    |> Tuple.append(item)
    |> then(&swim(&1, get_size(&1)))
  end


  defp swim(pq, index) do
    case index > 1 and maintains_heap_ordering(pq, div(index, 2), index) do
      true -> exchange(pq, div(index, 2), index) |> swim(div(index, 2))
      false -> pq
    end
  end

  ##################################################################################################
  # Here comes general helper functiosn for the entire module
  ##################################################################################################

  defp get_size(pq), do: elem(pq, 0) |> then(fn meta_data -> meta_data.size end)

  defp heap_order_functon(pq) do
    elem(pq, 0)
    |> then(fn meta_data -> meta_data.fun end)
  end

  defp maintains_heap_ordering(pq, next, current) do
    heap_order_functon(pq).(elem(pq, next), elem(pq, current))
  end


  defp exchange(pq, this, that) do
    {elem(pq, this), elem(pq, that)}
    |> then(&handle_exchange(pq, this, that, &1))
  end

  defp handle_exchange(pq, this, that, {this_item, that_item}) do
    put_elem(pq, this, that_item)
    |> put_elem(that, this_item)
  end

end
