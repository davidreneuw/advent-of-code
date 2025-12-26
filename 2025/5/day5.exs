defmodule Day5 do
  def read_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def get_fresh_list(input) do
    input
    |> Enum.filter(fn text -> String.contains?(text, "-") end)
  end

  def to_ranges(fresh_list) do
    fresh_list
    |> Enum.map(fn text -> Enum.map(String.split(text, "-"), &String.to_integer/1) end)
    |> Enum.map(fn list -> Range.new(List.first(list), List.last(list)) end)
  end

  def get_id_list(input) do
    input
    |> Enum.filter(fn text -> !String.contains?(text, "-") end)
    |> Enum.filter(fn text -> String.length(text) > 0 end)
  end

  def check_freshness(fresh_list, id) do
    fresh_list
    |> Enum.any?(fn range ->
      [lower, upper] =
        range
        |> String.split("-")
        |> Enum.map(fn str -> String.to_integer(str) end)

      identifier = String.to_integer(id)

      cond do
        identifier >= lower and identifier <= upper -> true
        true -> false
      end
    end)
  end

  def to_mapset(range) do
    [lower, upper] =
      range
      |> String.split("-")
      |> Enum.map(fn str -> String.to_integer(str) end)

    Enum.to_list(lower..upper)
    |> MapSet.new()
  end

  def ranges_overlap?(_a..b//_, c.._d//_) do
    c <= b + 1
  end

  def merge_ranges(a..b//_, c..d//_) do
    min(a, c)..max(b, d)
  end

  def merge_overlapping_ranges([first | rest]) do
    Enum.reduce(rest, [first], fn current_range, [last_merged | acc] ->
      if ranges_overlap?(last_merged, current_range) do
        [merge_ranges(last_merged, current_range) | acc]
      else
        [current_range, last_merged | acc]
      end
    end)
  end

  def part1() do
    fresh_list =
      read_input()
      |> get_fresh_list()

    read_input()
    |> get_id_list()
    |> Enum.filter(fn id -> check_freshness(fresh_list, id) end)
    |> Enum.count()
  end

  def part2() do
    read_input()
    |> get_fresh_list()
    |> to_ranges()
    |> Enum.sort()
    |> merge_overlapping_ranges()
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end
end

IO.puts(Day5.part1())
IO.puts(Day5.part2())
