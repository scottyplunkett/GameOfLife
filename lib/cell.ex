defmodule GameOfLife.Cell do

  def live(cell,location) do 
    %{cell | location => :alive}  
  end

  def die(cell,location) do 
    %{cell | location => :dead}  
  end

  def is_alive(cell,location) do 
    cell[location] == :alive
  end

  def find_neighbor_locations({cell_x,cell_y}) do
    distance_from_neighbor = [{1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}, {0,-1}, {1,-1}]
    for {distance_x, distance_y} <- distance_from_neighbor, do: 
      {cell_x + distance_x, cell_y + distance_y}
  end
end