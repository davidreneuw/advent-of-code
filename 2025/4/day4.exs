defmodule Day4 do
  def read_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def to_map(list) do
    list
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _x} -> char == "@" end)
      |> Enum.map(fn {_char, x} -> {x, y} end)
    end)
    |> MapSet.new()
  end

  def surrounding_positions({x, y}) do
    for dx <- -1..1, dy <- -1..1, {dx, dy} != {0, 0} do
      {x + dx, y + dy}
    end
  end

  def accesible_roll({x, y}, map) do
    surrounding_positions({x, y})
    |> Enum.filter(fn {x, y} -> MapSet.member?(map, {x, y}) end)
    |> Enum.count() < 4
  end

  def accessible_rolls(map) do
    map
    |> Enum.filter(fn {x, y} -> accesible_roll({x, y}, map) end)
    |> MapSet.new()
  end

  def remove_accessible_rolls(map), do: remove_accessible_rolls(map, 0)

  def remove_accessible_rolls(map, roll_count) do
    accessible = accessible_rolls(map)
    unaccessible = MapSet.difference(map, accessible)
    removed_count = Enum.count(accessible)

    case removed_count do
      0 -> roll_count
      _ -> remove_accessible_rolls(unaccessible, roll_count + removed_count)
    end
  end

  def part1() do
    read_input()
    |> to_map()
    |> accessible_rolls()
    |> Enum.count()
  end

  def part2() do
    read_input()
    |> to_map()
    |> remove_accessible_rolls()
  end
end

IO.puts(Day4.part1())
IO.puts(Day4.part2())
