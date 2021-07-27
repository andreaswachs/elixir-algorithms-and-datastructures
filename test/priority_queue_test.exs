defmodule PriorityQueueTest do
  use ExUnit.Case
  doctest PriorityQueue

  test "Can create priority queue" do
    queue = PriorityQueue.new_maxpq()
    |> PriorityQueue.insert(1)
    |> PriorityQueue.insert(2)
    |> PriorityQueue.insert(3)

    assert PriorityQueue.get_size(queue) == 3
    {_, fst, snd, trd} = queue
    values = [1, 2, 3]
    assert fst in values
    assert snd in values
    assert trd in values
  end


  test "Priority queue returns values in correct order for max oriented pq" do
    queue = PriorityQueue.new_maxpq()
    |> PriorityQueue.insert(1)
    |> PriorityQueue.insert(2)
    |> PriorityQueue.insert(3)

    {:ok, new_pq, val} = PriorityQueue.dequeue(queue)
    assert val == 3
    {:ok, new_pq, val} = PriorityQueue.dequeue(new_pq)
    assert val == 2
   {:ok, _, val} = PriorityQueue.dequeue(new_pq)
    assert val == 1
  end

  test "Priority queue returns values in correct order for min oriented pq" do
    queue = PriorityQueue.new_minpq()
    |> PriorityQueue.insert(1)
    |> PriorityQueue.insert(2)
    |> PriorityQueue.insert(3)

    {:ok, new_pq, val} = PriorityQueue.dequeue(queue)
    assert val == 1
    IO.inspect(new_pq)

    {:ok, new_pq, val} = PriorityQueue.dequeue(new_pq)
    assert val == 2

    {:ok, _, val} = PriorityQueue.dequeue(new_pq)
    assert val == 3
  end

end
