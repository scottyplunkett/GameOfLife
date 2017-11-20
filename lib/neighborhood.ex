defmodule GameOfLife.Neighborhood do

  def count_live_neighbors_of(cells) do 
    cells |> count_live_neighbors_of(get_all_neighbors_of(cells),[]) 
  end
  def count_live_neighbors_of([],_,live_neighbors) do live_neighbors end 
  def count_live_neighbors_of([{x,y}|other_living_cells],neighbors,live_neighbors) do 
    live_neighbor_count = live_neighbors ++ [[{x,y},Enum.count(neighbors, 
      fn({a,b}) ->
        {a,b} == {x,y}
      end)]]
    other_living_cells |> count_live_neighbors_of(neighbors,live_neighbor_count)
  end

  def get_all_neighbors_of(cells) do
    List.flatten(Enum.map(cells, 
      fn({x,y}) -> 
        GameOfLife.Cell.find_neighbor_locations({x,y}) 
      end))
  end
end