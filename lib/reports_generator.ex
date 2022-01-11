defmodule ReportsGenerator do
  alias ReportsGenerator.Parser

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options [
    "users",
    "foods"
  ]


  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report)
    end)
  end

  defp sum_values([id, food_name, price], %{"users" => users, "foods" => foods} = report) do
    users =  Map.put(users, id, users[id] + price)
    foods =  Map.put(foods, food_name, foods[food_name] + 1)
    %{report | "users" => users, "foods" => foods}
  end


  def fetch_higher_cost(report, option) when option in @options do
     Enum.max_by(report[option], fn {_key, value} -> {:ok, value} end)
  end
  # maior valor

  def fetch_higher_cost(_report, _option), do: {:error, "inválid option!"}

  defp report_acc do
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    %{"users" => users, "foods" => foods}
  end
end


# ReportsGenerator.build("report_test.csv")
