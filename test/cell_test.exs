defmodule GameOfLife.CellTest do
  use ExUnit.Case, async: true

  setup _context do 
    location = {1,1}
    {:ok, [
            location: location,
            dead:   %{location => :dead},
            living: %{location => :alive}
          ]
    }
  end 

  test "A Cell can stay or come alive", context do 
    assert GameOfLife.Cell.live(context[:dead],context[:location]) == %{{1,1} => :alive}
    assert GameOfLife.Cell.live(context[:living],context[:location]) == %{{1,1} => :alive}
  end 

  test "A Cell can stay or be dead", context do 
    assert GameOfLife.Cell.die(context[:dead],context[:location]) == %{{1,1} => :dead}
    assert GameOfLife.Cell.die(context[:living],context[:location]) == %{{1,1} => :dead}
  end

  test "A living Cell responds true to is_alive?", context do 
    assert GameOfLife.Cell.is_alive?(context[:living],context[:location]) == true
  end

  test "A dead Cell responds false to is_alive?", context do 
    assert GameOfLife.Cell.is_alive?(context[:dead],context[:location]) == false
  end
end