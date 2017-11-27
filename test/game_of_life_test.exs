defmodule GameOfLifeTest do
  use ExUnit.Case, async: true
  doctest GameOfLife

  test "Any live cell with fewer than two live neighbours dies, as if caused by underpopulation." do 
    assert GameOfLife.lives?(:alive,1) == false
    assert GameOfLife.lives?(:alive,0) == false
  end

  test "Any live cell with two or three live neighbours lives on to the next generation." do 
    assert GameOfLife.lives?(:alive,2) == true
    assert GameOfLife.lives?(:alive,3) == true
  end

  test "Any live cell with more than three live neighbours dies, as if by overpopulation." do 
    assert GameOfLife.lives?(:alive,4) == false
    assert GameOfLife.lives?(:alive,5) == false
  end

  test "Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction." do 
    assert GameOfLife.lives?(:dead,3) === true
    assert GameOfLife.lives?(:dead,4) === false
    assert GameOfLife.lives?(:dead,2) === false
  end

  test "counts living neighbor to the North" do 
    world = 
          %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
            {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1

  end

  test "counts living neighbor to the South" do 
    world = 
          %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead, {0,-1} => :alive,  {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the West" do 
    world = 
          %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :alive, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the East" do 
    world = 
          %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :alive, 
            {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the NorthEast" do 
    world = 
          %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :alive,
            {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the SouthEast" do 
    world = 
          %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :alive
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the NorthWest" do 
    world = 
          %{{-1,1}  => :alive,  {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
            {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "counts living neighbor to the SouthWest" do 
    world = 
          %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
            {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
            {-1,-1} => :alive,  {0,-1} => :dead, {1,-1} => :dead
            }
    assert world |> GameOfLife.living_neighbors({0,0}) == 1
  end

  test "grid transforms world into list w/ sublist for each row" do 
    world = 
        %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
          {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
          {-1,-1} => :alive,  {0,-1} => :dead, {1,-1} => :dead
          }
    assert GameOfLife.grid(world) == [[:dead,:dead,:dead],
                                      [:dead,:dead,:dead],
                                      [:alive,:dead,:dead]]
    world = 
        %{{-2,1} =>:alive,{-1,1}=>:dead, {0,1} =>:dead, {1,1} =>:dead,
          {-2,0} =>:dead, {-1,0}=>:alive,{0,0} =>:dead, {1,0} =>:dead, 
          {-2,-1}=>:dead,{-1,-1}=>:dead,{0,-1} =>:alive,{1,-1}=>:dead,
          {-2,-2}=>:dead,{-1,-2}=>:dead,{0,-2} =>:dead, {1,-2}=>:alive
          }

    assert GameOfLife.grid(world) == [[:alive,:dead,:dead,:dead],
                                      [:dead,:alive,:dead,:dead],
                                      [:dead,:dead,:alive,:dead],
                                      [:dead,:dead,:dead,:alive]]
  end
end