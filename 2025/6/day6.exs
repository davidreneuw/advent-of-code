defmodule Day6 do
  def read_input() do
    File.read!("input.txt")
    |> String.split("\n", trim: true)
  end

  def to_equations(list) do
    list
    |> Enum.map(fn term -> String.split(term, " ", trim: true) end)
    |> Enum.zip_with(&Function.identity/1)
  end

  def evaluate_equations(list) do
    list
    |> Enum.map(&evaluate_equation/1)
  end

  def evaluate_equation(equation) do
    numbers = Enum.drop(equation, -1) |> Enum.map(&String.to_integer/1)

    case List.last(equation) do
      "*" -> Enum.reduce(numbers, 1, fn term, acc -> term * acc end)
      "+" -> Enum.reduce(numbers, 0, fn term, acc -> term + acc end)
    end
  end

  def to_equations_2(list) do
    clean_equation = fn equation ->
      equation
      |> Enum.reverse()
      |> List.update_at(-1, fn s ->
        {head, tail} = String.split_at(s, -1)
        [head, tail]
      end)
      |> List.flatten()
      |> Enum.map(&String.trim/1)
    end

    list
    |> Enum.map(&String.graphemes/1)
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.map(&Enum.join/1)
    |> Enum.chunk_by(&(String.trim(&1) == ""))
    |> Enum.reject(fn chunk ->
      Enum.all?(chunk, &(String.trim(&1) == ""))
    end)
    |> Enum.map(clean_equation)
  end

  def part1() do
    read_input()
    |> to_equations()
    |> evaluate_equations()
    |> Enum.sum()
  end

  def part2() do
    read_input()
    |> to_equations_2()
    |> evaluate_equations()
    |> Enum.sum()
  end
end

IO.puts(Day6.part1())
IO.puts(Day6.part2())
