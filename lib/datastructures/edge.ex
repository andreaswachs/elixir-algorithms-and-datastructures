defmodule Edge do
  @moduledoc """
  The edge module reflects edges.

  Here is a struct defined for an edge, that shows vital information for a given
  edge such as where it coems from, goes to and what the weight of the edge is
  """

  defstruct from: nil, to: nil, weight: 0

  @spec new(non_neg_integer(), non_neg_integer(), integer()) :: %Edge{}
  def new(from, to, weight \\ 0) do
    %Edge{to: to, from: from, weight: weight}
  end
end
