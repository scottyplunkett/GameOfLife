defmodule GameOfLife.CellTest do
  use ExUnit.Case, async: true

  setup _cell do 
    location = {1,1}
    {:ok, [
            location: location,
            dead:   %{location => :dead},
            living: %{location => :alive}
          ]
    }
  end 

  test "A Cell can stay or come alive", cell do 
    assert GameOfLife.Cell.live(cell[:dead],cell[:location]) == %{{1,1} => :alive}
    assert GameOfLife.Cell.live(cell[:living],cell[:location]) == %{{1,1} => :alive}
  end 

  test "A Cell can stay or be dead", cell do 
    assert GameOfLife.Cell.die(cell[:dead],cell[:location]) == %{{1,1} => :dead}
    assert GameOfLife.Cell.die(cell[:living],cell[:location]) == %{{1,1} => :dead}
  end

  test "A living Cell responds true to is_alive", cell do 
    assert GameOfLife.Cell.is_alive(cell[:living],cell[:location]) == true
  end

  test "A dead Cell responds false to is_alive", cell do 
    assert GameOfLife.Cell.is_alive(cell[:dead],cell[:location]) == false
  end

  test "A cell can find the location of his neighbor" do
    assert GameOfLife.Cell.find_neighbor_locations({0,0}) == [{1,0}, {1,1}, {0,1}, {-1,1}, {-1,0}, {-1,-1}, {0,-1}, {1,-1}]
    assert GameOfLife.Cell.find_neighbor_locations({3,5}) == [{4,5}, {4,6}, {3,6}, {2,6}, {2,5}, {2,4}, {3,4}, {4,4}]
  end

end