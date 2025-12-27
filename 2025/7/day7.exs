defmodule Day7 do
  def read_input() do
    File.read!("input.txt")
    |> String.replace("S", "1")
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
  end

  def write_output(input) do
    content = input |> Enum.map(fn value -> Enum.join(value, "") end) |> Enum.join("\n")
    File.write!("output.txt", content)
  end

  def step(input, part), do: step(input, 0, 0, part)

  def step(input, row, count, part) do
    if row >= Enum.count(input) - 1 do
      {input, count}
    else
      indices =
        input
        |> Enum.at(row)
        |> Enum.with_index()
        |> Enum.filter(fn {value, _index} -> value != "." && value != "^" end)

      next_row = Enum.at(input, row + 1)

      {updated_row, new_count} =
        indices
        |> Enum.reduce({next_row, count}, fn {above_value, index}, {acc_list, acc_count} ->
          current_value = Enum.at(acc_list, index)

          case current_value do
            "." ->
              {List.update_at(acc_list, index, fn val -> increment_beam(val, above_value) end),
               acc_count}

            "^" ->
              left_val = Enum.at(acc_list, index - 1)
              right_val = Enum.at(acc_list, index + 1)

              splits = 0

              splits =
                if left_val == "." || right_val == ".", do: splits + 1, else: splits

              updated_list =
                acc_list
                |> List.update_at(index - 1, fn value -> increment_beam(value, above_value) end)
                |> List.update_at(index + 1, fn value -> increment_beam(value, above_value) end)

              {updated_list, acc_count + splits}

            _ ->
              {List.update_at(acc_list, index, fn value -> increment_beam(value, above_value) end),
               acc_count}
          end
        end)

      new_input = List.update_at(input, row + 1, fn _ -> updated_row end)

      step(new_input, row + 1, new_count, part)
    end
  end

  def increment_beam(value, above_value) do
    {above_int, _} = Integer.parse(above_value)

    case Integer.parse(value) do
      {int, _} ->
        Integer.to_string(int + above_int)

      :error ->
        case value do
          "." -> above_value
          "^" -> "^"
        end
    end
  end

  def sum_bottom_row(input) do
    input
    |> List.last()
    |> Enum.filter(fn val -> val != "." && val != "^" end)
    |> Enum.map(fn val ->
      {int, _} = Integer.parse(val)
      int
    end)
    |> Enum.sum()
  end

  def part1() do
    read_input()
    |> step(:part1)
  end

  def part2() do
    {input, count} = read_input() |> step(:part2)
    sum_bottom_row(input)
  end
end

{_input1, count1} = Day7.part1()
#
IO.puts(count1 - 1)
IO.puts(Day7.part2())
