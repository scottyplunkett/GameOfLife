defmodule GameOfLifeTest do
  use ExUnit.Case, async: true
  doctest GameOfLife

  test "tick outputs next N generations" do 
    world = %{{-1,1}  => :alive,  {0,1}  => :dead, {1,1}  => :alive,
              {-1,0}  => :dead,   {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :alive,  {0,-1} => :dead, {1,-1} => :dead}
    
    next  = %{{-1,1}  => :alive,  {0,1}  => :alive, {1,1}  => :alive,
              {-1,0}  => :alive,  {0,0}  => :alive, {1,0}  => :alive, 
              {-1,-1} => :alive,  {0,-1} => :alive, {1,-1} => :alive}

    last  = %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead}

    blinker = %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead, 
                {-1,0}  => :dead,  {0,0}  => :alive, {1,0}  => :dead, 
                {-1,-1} => :dead,  {0,-1} => :alive, {1,-1} => :dead}
    glider = %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
               {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :alive,
               {-1,-1} => :alive,  {0,-1} => :alive, {1,-1} => :alive}

    assert GameOfLife.tick(world,1) == next
    assert GameOfLife.tick(next,1) == last
  end

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
    assert GameOfLife.lives?(:dead,2) === false
    assert GameOfLife.lives?(:dead,4) === false
  end

  defmodule LivingNeighborsTest do 
    use ExUnit.Case, async: true
    test "counts living neighbor to the North" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :alive,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,1}) == 1
    end

    test "counts living neighbor to the South" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :alive,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,-1}) == 1
    end

    test "counts living neighbor to the West" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :alive, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead,  {1,0}  => :alive, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,0}) == 1
    end

    test "counts living neighbor to the East" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :alive, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :alive, {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,0}) == 1
    end

    test "counts living neighbor to the NorthEast of center" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :alive,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end

    test "counts living neighbor to the NorthEast of NE most cell" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :alive, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,1}) == 1
    end

    test "counts living neighbor to the NorthEast of northerly Cells" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :alive,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,1}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :alive
              }
      assert world |> GameOfLife.living_neighbors({0,1}) == 1
    end

    test "counts living neighbor to the NorthEast of easterly Cells" do 
      world = 
            %{{-1,1}  => :alive, {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,0}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead,  {1,1}  => :dead,
              {-1,0}  => :alive, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,-1}) == 1
    end

    test "counts living neighbor to the SouthEast of center" do 
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :alive
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end

    test "counts living neighbor to the SouthEast of SE most cell" do 
      world = 
            %{{-1,1}  => :alive, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,-1}) == 1
    end

    test "counts living neighbor to the SouthEast of southerly Cells" do   
      world = 
            %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,-1}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :alive,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,-1}) == 1
    end

    test "counts living neighbor to the SouthEast of easterly Cells" do   
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :alive, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,0}) == 1
      world = 
            %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :alive, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,1}) == 1
    end

    test "counts living neighbor to the NorthWest of center" do 
      world = 
            %{{-1,1}  => :alive,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end

    test "counts living neighbor to the NorthWest of NW most cell" do   
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :alive
              }
      assert world |> GameOfLife.living_neighbors({-1,1}) == 1
    end

    test "counts living neighbor to the NorthWest of northerly cells" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :alive,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,1}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :alive,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,1}) == 1
    end

    test "counts living neighbor to the NorthWest of westerly cells" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :alive,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,0}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :alive, 
              {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,-1}) == 1
    end

    test "counts living neighbor to the SouthWest of center" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :alive,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end

    test "counts living neighbor to the SouthWest of SW most cell" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :alive,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,-1}) == 1
    end

    test "counts living neighbor to the SouthWest of southerly cells" do 
      world = 
            %{{-1,1}  => :alive,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({0,-1}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :alive, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({1,-1}) == 1
    end

    test "counts living neighbor to the SouthWest of westerly cells" do 
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :alive, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead
              }
      assert world |> GameOfLife.living_neighbors({-1,1}) == 1
      world = 
            %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
              {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
              {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :alive
              }
      assert world |> GameOfLife.living_neighbors({-1,0}) == 1
    end
  end

end