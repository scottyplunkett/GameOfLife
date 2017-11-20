defmodule GameOfLife.Generation do

 @doc """
  Underpopulation occurs thusly: Any live cell with fewer than two live neighbours dies, as if caused by under-population.
    Steps-
    1. Get all live cells
    2. Get all their neighbors
    3. Count the neighbors that are also a live cell
        if live_neighbors < 2    #=> put into next_gen on list
 """ 
  def kill_underpopulated_from(current_generation) do
    GameOfLife.Neighborhood.count_live_neighbors_of(current_generation) |>
    Enum.filter(
      fn([{_x,_y},live_neighbor_count]) -> 
        live_neighbor_count >= 2 
      end)
  end
end