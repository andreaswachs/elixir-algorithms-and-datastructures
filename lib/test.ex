defmodule Test do
  @spec divide(number(), number()) :: {:ok, number} | {:error, String.t()}
  def divide(_, b) when b == 0 do
    {:error, "Can't divide by zero"}
  end

  def divide(a, b) do
    {:ok, a / b}
  end

  @spec get_username(any) :: {:error, <<_::160>>} | {:ok, any}
  def get_username(%{username: username} = user_info) do
    {:ok, username}
  end

  def get_username(_) do
    {:error, "No username provided"}
  end

  def traverse([]) do
    IO.puts("I am finished!")
  end

  def traverse([head | tail]) do
    IO.puts("I traveled an element in the list: #{head}")
    traverse(tail)
  end
end
