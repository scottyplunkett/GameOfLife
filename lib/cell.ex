defmodule GameOfLife.Cell do
  def live(cell_map, location) do 
      %{cell_map | location => :alive}  
  end   

  def die(cell_map, location) do 
      %{cell_map | location => :dead}  
  end   

  def is_alive?(cells, location) do 
    if cells[location] == :alive do
      true
    else
      false
    end
  end

end