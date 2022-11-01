defmodule IslandsEngine.Coordinate do
  alias __MODULE__
  @enforce_keys [:row, :col]
  defstruct [:row, :col]
  @board_range 1..10

  defguard valid_coords?(pos) when pos in @board_range
  defguard valid_coords?(row, col) when valid_coords?(row) and valid_coords?(col)

  # def new(row, col) when row in @board_range and col in @board_range do
  def new(row, col) when valid_coords?(row, col) do
    {:ok, %Coordinate{row: row, col: col}}
    # could also be: {:ok, %__MODULE__{row: row, col: col}}
  end

  def new(_row, _col), do: {:error, :invalid_coordinate}
end
