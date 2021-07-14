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

  test "insert same key twice with different value, should contain last inserted value" do
    key = "key"
    value_1 = "value_1"
    value_2 = "value_2"

    tree = TST.new() |> TST.insert(key, value_1) |> TST.insert(key, value_2)

    assert TST.exists?(tree, key)
    assert {:ok, ^value_2} = TST.get_item(tree, key)
  end

  test "can insert multiple keys into TST and find all" do
    key_1 = "key"
    key_2 = "other key"
    value = "value"

    tree = TST.new() |> TST.insert(key_1, value) |> TST.insert(key_2, value)

    assert TST.exists?(tree, key_1)
    assert TST.exists?(tree, key_2)
  end

  test "can insert key-value pair and get same value out" do
    key = "key"
    value = "value"

    tree = TST.new() |> TST.insert(key, value)

    assert {:ok, ^value} = TST.get_item(tree, key)
  end

  test "can get list of prefixes" do
    key_1 = "bob"
    key_2 = "bobine"
    value = "value"

    tree = TST.new() |> TST.insert(key_1, value) |> TST.insert(key_2, value)

    assert ["bob", "bobine"] = TST.get_keys_with_prefix(tree, "bo")
  end


  test "attempt getting all keys with prefix john in empty tree" do
    tree = TST.new()

    assert [] = TST.get_keys_with_prefix(tree, "john")
  end


  test "attempt getting keys with empty key as prefixes in tree" do
    tree = TST.new() |> TST.insert("key", "value") |> TST.insert("otherkey", "value")

    assert ["key", "otherkey"] = TST.get_keys_with_prefix(tree, "")
  end
end
