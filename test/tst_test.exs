defmodule TSTTest do
  use ExUnit.Case
  doctest TST


  test "creates empty TST" do
    expected = %TST{item: nil, left: nil, middle: nil, right: nil, value: nil}

    actual = TST.new()

    assert actual == expected
  end

  test "can insert value into TST and it exists" do
    key = "key"
    value = "value"
    expected = TST.new() |> TST.insert(key, value)

    assert TST.exists?(expected, key) == true
  end

  test "can insert multiple keys into TST and find all" do
    key_1 = "key"
    key_2 = "other key"
    value = "value"

    tree = TST.new() |> TST.insert(key_1, value) |> TST.insert(key_2, value)

    assert TST.exists?(tree, key_1)
    assert TST.exists?(tree, key_2)
  end


end
