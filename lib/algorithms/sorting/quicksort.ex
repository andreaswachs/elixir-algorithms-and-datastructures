defmodule Quicksort do
  @moduledoc """
  This module allows for sorting lists with the quick sort algorithm.
  """

  @doc """
  The sort function sorts lists of comparable data items. The classic case can be a list of numbers,
  where this function can sort the numbers in either ascending or descending order with the
  second parameter given as atoms as either `:asc` or `:desc`

  As a bonus, another sorting function is provided where the second parameter is a function
  that makes a comparison between the pivot point and the current considered item from the list.
  This will dictate how the left portion of the list will be sorted according to the pivot point.
  Then the right side of the pivot point will be sorted in the relative reverse order.

  This will make sense if my explanation was good and you know how quicksort works.
  """
  @spec sort(list(any), atom() | function) :: list(any)
  def sort(nil, _) do
    raise ArgumentError, message: "nil value passed as expected list to be sorted."
  end

  def sort(not_list, _) when not is_list(not_list) do
    raise ArgumentError, message: "expected list passed, was not a list"
  end

  def sort(list, :asc) do
    handle_sort(list, fn pivot, current_item -> pivot >= current_item end)
  end

  def sort(list, :desc) do
    handle_sort(list, fn pivot, current_item -> pivot <= current_item end)
  end

  def sort(list, fun) when is_function(fun) do
    case :erlang.fun_info(fun)[:arity] do
      2 -> handle_sort(list, fun)
      _ -> raise ArgumentError, message: "passed function was not of 2 arity"
    end
  end

  defp handle_sort([], _), do: []

  defp handle_sort([head | tail] = _list, comparator) do
    handle_sort(Enum.filter(tail, fn x -> comparator.(head, x) end), comparator) ++
      [head] ++
      handle_sort(Enum.filter(tail, fn x -> comparator.(x, head) end), comparator)
  end
end
