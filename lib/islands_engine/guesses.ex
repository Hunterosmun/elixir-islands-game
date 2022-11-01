defmodule IslandsEngine.Guesses do
  alias __MODULE__
  alias IslandsEngine.{Coordinate, Guesses}

  @enforce_keys [:hits, :misses]
  defstruct [:hits, :misses]

  @type t :: %Guesses{hits: MapSet.t(), misses: MapSet.t()}

  @spec new :: Guesses.t()
  def new(), do: %Guesses{hits: MapSet.new(), misses: MapSet.new()}

  # could also do this (to make defaults)
  # defstruct [hits: MapSet.new(), misses: MapSet.new()]
  # do new(), do: %Guesses{}

  def add(%Guesses{} = guesses, :hit, %Coordinate{} = coordinate) do
    update_in(guesses.hits, &MapSet.put(&1, coordinate))
    # update_in is a magic Elixir taht changes something and returns a full thing
    # Here it's changing our MapSet.hits, then returning the whole MapSet
    # using only MapSet.put() won't change the object you're looking at
  end

  def add(%Guesses{} = guesses, :miss, %Coordinate{} = coordinate) do
    update_in(guesses.misses, &MapSet.put(&1, coordinate))
  end

  def add(_, _, _) do
    "Ya don guffed bud. Do better."
  end
end
