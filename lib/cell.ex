defmodule GameOfLife.Cell do

  def live(cell, location) do 
    %{cell | location => :alive}  
  end

  def die(cell, location) do 
    %{cell | location => :dead}  
  end

  def is_alive?(cell, location) do 
    cell[location] == :alive
  end
end