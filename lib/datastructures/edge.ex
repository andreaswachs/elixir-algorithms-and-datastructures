defmodule Edge do

  defstruct from: nil, to: nil, weight: 0, directed: false

  @spec new(non_neg_integer(), non_neg_integer(), integer(), boolean()) :: %Edge{}
  def new(to, from, weight \\ 0, directed \\ false) do
    %Edge{to: to, from: from, weight: weight, directed: directed}
  end
end
