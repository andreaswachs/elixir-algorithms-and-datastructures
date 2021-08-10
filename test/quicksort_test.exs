defmodule QuicksortTest do
  use ExUnit.Case
  doctest Quicksort

  test "can sort a list of random integers into ascending order" do
    range = 1..1000

    numbers = range |> Enum.to_list()
    numbers_shuffled = numbers |> Enum.shuffle()

    assert(numbers != numbers_shuffled)

    sorted_numbers = Quicksort.sort(numbers_shuffled, :asc)

    assert(sorted_numbers == numbers)
  end

  test "can sort a list of random integers into descending order" do
    range = 1000..1

    numbers = range |> Enum.to_list()
    numbers_shuffled = numbers |> Enum.shuffle()

    assert(numbers != numbers_shuffled)

    sorted_numbers = Quicksort.sort(numbers_shuffled, :desc)

    assert(sorted_numbers == numbers)
  end

  test "can sort list of strings by string length in ascending order with custom function" do
    strings = ["a", "bb", "ccc", "dddd", "eeeee", "ffffff", "ggggggg", "hhhhhhhh", "iiiiiiiii"]

    strings_shuffled = strings |> Enum.shuffle()

    assert(strings != strings_shuffled)

    sorting_function = fn pivot, item -> String.length(pivot) >= String.length(item) end

    strings_sorted = Quicksort.sort(strings_shuffled, sorting_function)

    assert(strings_sorted == strings)
  end

  test "can sort an empty list" do
    list = []

    list_sorted_asc = Quicksort.sort(list, :asc)
    list_sorted_desc = Quicksort.sort(list, :desc)

    assert(list_sorted_asc == list)
    assert(list_sorted_desc == list)
  end

  test "can't sort nil" do
    assert_raise ArgumentError, "nil value passed as expected list to be sorted.", fn ->
      Quicksort.sort(nil, :asc)
    end

    assert_raise ArgumentError, "nil value passed as expected list to be sorted.", fn ->
      Quicksort.sort(nil, :desc)
    end
  end

  test "cant sort a list that is not a list" do
    assert_raise ArgumentError, "expected list passed, was not a list", fn ->
      Quicksort.sort(1, :asc)
    end
  end
end
