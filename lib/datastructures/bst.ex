# defmodule BST do

#   # Regarding this implementation of a BST:
#   # This BST supports inserting key and value pairs, such that it is
#   # the keys that are compared and inserted in their correct place in the BST
#   # The data structure will use maps to be very verbose about subtrees

#   # Functions for creating a binary search tree

#   defstruct left: nil, right: nil, key: nil, value: nil

#   def new() do
#     %BST{}
#   end

#   # Functions for inserting into a binary search tree

#   @spec insert(%BST{}, String.t() | number()) :: {:ok, %BST{}} | {:error, String.t()}
#   def insert(nil, key, value) do
#     %BST{key: key, value: value}
#   end

#   def insert(%BST{key: tree_key, value: tree_value, left: left, right: right} = tree, key, value) when tree_key == key do
#     %{tree | value: value}
#   end

#   def insert(%BST{key: tree_key, left: left}, key, value) when tree_key > key do
#     %{tree | left: insert(left, key, value)}
#   end

#   def insert(%BST{key: tree_key, right: right}, key, value) when tree_key < key do
#     %{tree | right: insert(right), key, value}
#   end

#   # Functions for searching in a binary search tree

#   # Functions for deleting in a binary search tree
# end
