defmodule Edge do

  defstruct from: nil, to: nil, weight: 0

  @spec new(non_neg_integer(), non_neg_integer(), integer()) :: %Edge{}
  def new(from, to, weight \\ 0) do
    %Edge{to: to, from: from, weight: weight}
  end
end
