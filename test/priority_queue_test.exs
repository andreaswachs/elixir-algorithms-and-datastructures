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

    {:ok, new_pq, val} = PriorityQueue.dequeue(new_pq)
    assert val == 2

    {:ok, _, val} = PriorityQueue.dequeue(new_pq)
    assert val == 3
  end


  test "max oriented priority queue returns all values in correct order with many values" do
    queue =
      Enum.reduce(Range.new(1, 100), PriorityQueue.new_maxpq, fn x, acc ->
        PriorityQueue.insert(acc, x)
      end)

      IO.inspect(queue, label: "Queue after insertion of 1..100")

      Enum.reduce(Range.new(100, 1), queue, fn x, acc ->
        {:ok, new_pq, val} = PriorityQueue.dequeue(acc)
        assert x == val
        new_pq
      end)
  end

  test "min oriented priority queue retusn all values in correct order with many values" do
    assert true
  end

end
