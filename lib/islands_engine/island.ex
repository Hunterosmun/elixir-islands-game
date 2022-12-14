defmodule IslandsEngine.Island do
  alias IslandsEngine.{Coordinate, Island}
  alias __MODULE__

  @enforce_keys [:coordinates, :hit_coordinates]
  defstruct [:coordinates, :hit_coordinates]

  def new(), do: %Island{coordinates: MapSet.new(), hit_coordinates: MapSet.new()}

  def new(type, %Coordinate{} = upper_left) do
    with [_ | _] = offsets <- offsets(type),
         %MapSet{} = coordinates <- add_coordinates(offsets, upper_left) do
      {:ok, %Island{coordinates: coordinates, hit_coordinates: MapSet.new()}}
    else
      error -> error
    end
  end

  defp offsets(:square), do: [{0, 0}, {0, 1}, {1, 0}, {1, 1}]
  defp offsets(:atoll), do: [{0, 0}, {0, 1}, {1, 1}, {2, 0}, {2, 1}]
  defp offsets(:dot), do: [{0, 0}]
  defp offsets(:l_shape), do: [{0, 0}, {1, 0}, {2, 0}, {2, 1}]
  defp offsets(:s_shape), do: [{0, 1}, {0, 2}, {1, 0}, {1, 1}]
  defp offsets(:_), do: {:error, :invalid_island_shape}

  defp add_coordinates(offsets, upper_left) do
    Enum.reduce_while(offsets, MapSet.new(), fn offset, acc ->
      add_coordinate(acc, upper_left, offset)
    end)
  end

  defp add_coordinate(coordinates, %Coordinate{row: row, col: col}, {row_offset, col_offset}) do
    case Coordinate.new(row + row_offset, col + col_offset) do
      {:ok, coordinate} -> {:cont, MapSet.put(coordinates, coordinate)}
      {:error, :invalid_coordinate} -> {:halt, {:error, :invalid_coordinate}}
    end
  end

  def overlaps?(existing_island, new_island) do
    not MapSet.disjoint?(existing_island.coordinates, new_island.coordinates)
    # a ? at the end of a function name means it will return a boolean
    # a ! at the end means "this could throw an error"
  end

  # Our second try at the guess function (uses if instead of case)
  # def guess(island, coordinate) do
  #   if MapSet.member?(island.coordinates, coordinate),
  #     do: {:hit, update_in(island.hit_coordinates, &MapSet.put(&1, coordinate))},
  #     else: :miss
  # end

  def guess(island, coordinate) do
    case MapSet.member?(island.coordinates, coordinate) do
      true -> {:hit, update_in(island.hit_coordinates, &MapSet.put(&1, coordinate))}
      # Below (What the book told us to do), Above (What we changed it to)
      # true ->
      #   hit_coordinates = MapSet.put(island.hit_coordinates, coordinate)
      #   {:hit, %{island | hit_coordinates: hit_coordinates}}
      false -> :miss
    end
  end

  def forested?(island), do: MapSet.equal?(island.coordinates, island.hit_coordinates)

  def types(), do: [:atoll, :dot, :l_shape, :s_shape, :square]
end
