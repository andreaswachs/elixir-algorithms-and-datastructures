# Ternary Search Trie

defmodule TST do
  @moduledoc """
  This module supports the Ternary Search Trie data structure.
  """

  defstruct middle: nil, right: nil, left: nil, value: nil, item: nil

  @doc """
  Creates an empty ternary search trie data structure

  Returns `%TST{}`

  ## Examples
  `
    iex> TST.new()
    %TST{item: nil, left: nil, middle: nil, right: nil, value: nil}
  `
  """
  @spec new() :: %TST{}
  def new(), do: %TST{}

  defp new(c) do
    %TST{value: c}
  end


  ####################################################################################################
  # Here comes the functions for inserting values into the TST
  ####################################################################################################

  @doc """
  Insert a key-value pair into a TST. It is acceptable to pass nil as the first argument - a new TST
  will then be created.


  ## Parameters

  - tst: A Ternary Search Trie map or nil (no tree yet created)
  - key: A String key in which to associate a value with
  - value: The value that you want to have stored. Can be of any type

  ## Examples
  ```
  iex> TST.new() |> TST.insert("key", "value")
  %TST{
  item: nil,
  left: nil,
  middle: %TST{
    item: nil,
    left: nil,
    middle: %TST{item: "value", left: nil, middle: nil, right: nil, value: "y"},
    right: nil,
    value: "e"
  },
  right: nil,
  value: "k"
  }
  ```
  """
  @spec insert(%TST{}, String.t(), any) :: %TST{}
  def insert(tst, key, value) when is_nil(tst) do
    key
    |> String.next_grapheme()
    |> (fn {first_char, rest} ->
          insert(new(first_char), rest, value)
        end).()
  end

  def insert(%TST{value: tree_value, left: left, right: right, middle: middle} = tst, key, value)
    when is_nil(tree_value) and is_nil(left) and is_nil(right) and is_nil(middle) do
      # This function handles inserting into a 1 level deep TST that is empty
      # Used to pass test case "can insert value into TST and it exists"
    key
    |> String.next_grapheme()
    |> (fn {first_char, rest} ->
          insert(%TST{tst | value: first_char}, rest, value)
        end).()

  end

  def insert(tst, "", value) do
    # Here we handle the case that the key is an empty string
    # This means that we should have traversed the tree until we hit a leaf
    # and we can now insert the value
    %TST{tst | item: value}
  end

  def insert(tst, key, value) do
    # Here we're going to insert the given key/value pair
    # whilst we make a judgement of which direction (right, left, middle)
    # were inserting
    key
    |> String.next_grapheme()
    |> then(&insert_in_direction(tst, key, value, &1))
  end

  defp insert_in_direction(%TST{value: tree_value, middle: next_middle} = tst, key, value, {first_char, rest}) do
    case next_middle do
      nil -> %TST{tst | middle: insert(new(first_char), rest, value)}
      _   ->  case insert_direction?(tree_value, first_char) do
                :left  -> %TST{tst | left: insert(tst.left, key, value)}
                :right -> %TST{tst | right: insert(tst.right, key, value)}
              end
    end
  end

  ####################################################################################################
  # Here comes functions related to querying the TST if a key is valid
  ####################################################################################################

  @doc """
  Query the TST to see if a key is a valid key

  ## Parameters

  - tst: The Ternary Search Trie if you have saved one, or nil (although this doesn't make much sense to look for valid keys in)
  - key: The key which you are querying whether is valid or not

  ## Examples
  ```
  iex> TST.new() |> TST.insert("key", "value") |> TST.exists?("key")
  true

  iex> TST.new() |> TST.insert("key", "value") |> TST.exists?("a whole other key")
  false
  ```
  """
  @spec exists?(nil | %TST{}, String.t()) :: boolean()
  def exists?(tst, _) when is_nil(tst), do: false

  def exists?(_, ""), do: false

  def exists?(tst, key) do
    key
    |> String.next_grapheme()
    |> (fn grapheme ->
          case find(tst, grapheme) do
            {:ok, _}    -> true
            {:error, _} -> false
          end
        end).()
  end

  defp find(%TST{value: value, item: item} = _tst, {first_char, ""}) when value == first_char do
    case item do
      nil -> {:error, "nil item"}
      _   -> {:ok, item}
    end
  end

  defp find(nil, _) do
    {:error, "nil subtree"}
  end

  defp find(%TST{value: value}, {first_char, ""}) when value != first_char do
    {:error, "no match"}
  end

  defp find(%TST{value: value, middle: middle, left: left, right: right}, {first_char, rest} = key) do
    cond do
      value == first_char -> find(middle, String.next_grapheme(rest))
      value > first_char  -> find(left, key)
      value < first_char  -> find(right, key)
    end
  end

  ####################################################################################################
  # Here comes helper functions
  ####################################################################################################

  defp insert_direction?(tree_value, first_char) do
    codepoint_pair(tree_value, first_char)
    |> (fn {left, right} -> left > right end).()
    |> (fn
          true -> :left
          false -> :right
        end).()
  end

  defp codepoint_pair(left, right) do
    {
      left |> String.codepoints() |> List.first(),
      right |> String.codepoints() |> List.first()
    }
  end
end
