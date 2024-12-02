defmodule D1 do
  def solve_first_puzzle(filename) do
	{first_col, second_col} = read_file_and_take_lists(filename)
	
	first_task = Task.async(fn -> Enum.sort(first_col) end)
	second_task = Task.async(fn -> Enum.sort(second_col) end)

	first_col = Task.await(first_task)
	second_col = Task.await(second_task)
	
	Enum.zip(first_col, second_col)
	|> Enum.map(fn z ->
	  {x, y} = z
	  abs(x - y)
	end)
	|> Enum.sum
  end

  def solve_second_puzzle(filename) do
	{first_col, second_col} = read_file_and_take_lists(filename)
	map = Enum.frequencies(second_col)
	first_col
	|> Enum.map(fn x ->
	  case Map.get(map, x) do
		nil -> x * 0
		result -> result * x
	  end
	end)
	|> Enum.sum
  end

  defp read_file_and_take_lists(filename) do
	File.read!(filename)
	|> String.split
	|> Enum.chunk_every(2)
	|> Enum.reduce({[], []},
				   fn x, acc ->
					 [first, second] = x
					 {first_col, second_col} = acc
					 first_col = [String.to_integer(first) | first_col]
					 second_col = [String.to_integer(second) | second_col]
					 {first_col, second_col}
				   end)
  end
end
