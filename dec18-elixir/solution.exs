import String
import Enum

defmodule Solution do
  def apply_rules(str) do
    case join(str) do    
      "^^." -> "^"
      ".^^" -> "^"
      "^.." -> "^"
      "..^" -> "^"
      _     -> "."
    end
  end
  
  def next_row(row) do
    "." <> row <> "."
    |> codepoints
    |> chunk(3, 1)
    |> map(&(apply_rules(&1)))
    |> join
  end

  def print_rows(rows), do: IO.puts join(rows, "\n")

  def count_safe([]), do: 0
  def count_safe([row|tail]), do: count_safe(row) + count_safe(tail)
  def count_safe(row), do: count(codepoints(row), &(&1 == "."))

  def compute_rows(start, n) do
    concat([start], scan(1..n-1, start, fn (_, acc) -> next_row(acc) end))
  end
end

{fname, num_rows} = case System.argv do
  [str, n] -> {str, elem(Integer.parse(n), 0)}
  [str] -> {str, 40}
  _ -> {"input.txt", 40}
end

{:ok, input} = File.read(fname)

rows = Solution.compute_rows(strip(input), num_rows)
safe_tiles = Solution.count_safe(rows)
IO.puts "Number of safe tiles: #{safe_tiles}"
