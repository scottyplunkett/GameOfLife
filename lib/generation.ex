defmodule GameOfLife.Generation do

@doc """
  Underpopulation occurs thusly: Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    Steps-
    1. Get all live cells
    2. Get all their neighbors
    3. Count the neighbors that are also a live cell
    4. Where live_neighbors >= 2  #=> pass to next generation
""" 
  def kill_underpopulated_from(current_generation) do
    GameOfLife.Neighborhood.count_live_neighbors_of(current_generation) |>
      Enum.filter(
        fn([{_x,_y},live_neighbor_count]) -> 
          live_neighbor_count >= 2 
        end)
  end

@doc """
  Overpopulation occurs thusly: Any live cell with more than three live neighbours dies, as if by over-population.
    Steps-
    1. Get all live cells
    2. Get all their neighbors
    3. Count the neighbors that are also a live cell
    4. Where live_neighbors <= 3  #=> pass to next generation
"""
  def kill_overpopulated_from(current_generation) do 
    GameOfLife.Neighborhood.count_live_neighbors_of(current_generation) |>
      Enum.filter(
        fn([{_x,_y},live_neighbor_count]) -> 
          live_neighbor_count <= 3 
        end)
  end

@doc """
  Reproduction occurs thusly: Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
    Steps-
    1. Get all live cells
    2. Get all their neighbors
    3. Map occurences of each neighbor to their respective locations
      (ex. %{{dead_1x,dead_1y} => times_dead1_occurs, {dead_2x,dead_2y} => times_dead2_occurs)
    4. If a dead cell occurs three times 
      (ex. %{{dead_x,dead_y} => 3}) #=> pass to next generation
"""
  def reproduce_from(current_generation) do 
    locations_with_occurences = current_generation
    |> GameOfLife.Neighborhood.get_all_neighbors_of() 
    |> Enum.reduce(%{}, 
        fn(cell, occurs) -> 
          Map.update(occurs, cell, 1, &(&1 + 1)) 
        end)
    for {location,occurs} when occurs === 3 <- locations_with_occurences, do: location 
  end 

end