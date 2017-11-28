defmodule GameOfLifeTest do
  use ExUnit.Case, async: true
  doctest GameOfLife

  defmodule IconifyTest do
    use ExUnit.Case
    test "returns cell status icons" do
      assert GameOfLife.iconify(:alive) == " ☙ "
      assert GameOfLife.iconify(:dead)  == " ☠ "
    end
  end

  defmodule LivesTest do
    use ExUnit.Case 
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
  end

  defmodule LivingNeighborsTest do
    use ExUnit.Case
    test "counts living neighbor to the North" do 
      world = %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
                {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
                {-1,-1} => :dead, {0,-1} => :dead,  {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the South" do 
      world = %{{-1,1}  => :dead, {0,1}  => :dead,  {1,1}  => :dead,
                {-1,0}  => :dead, {0,0}  => :dead,  {1,0}  => :dead, 
                {-1,-1} => :dead, {0,-1} => :alive, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the West" do 
      world = %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :alive, {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the East" do 
      world = %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :alive, 
                {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the NorthEast" do 
      world = %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :alive,
                {-1,0}  => :dead, {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :dead, {0,-1} => :dead, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the SouthEast" do 
      world = %{{-1,1}  => :dead, {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :dead, {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :dead, {0,-1} => :dead, {1,-1} => :alive}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the NorthWest" do 
      world = %{{-1,1}  => :alive, {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :dead,  {0,-1} => :dead, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
    test "counts living neighbor to the SouthWest" do 
      world = %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :alive, {0,-1} => :dead, {1,-1} => :dead}
      assert world |> GameOfLife.living_neighbors({0,0}) == 1
    end
  end

  defmodule GridTest do 
    use ExUnit.Case 
    test "grid transforms world into list w/ sublist for each row" do 
      world = %{{-1,1}  => :dead,  {0,1}  => :dead, {1,1}  => :dead,
                {-1,0}  => :dead,  {0,0}  => :dead, {1,0}  => :dead, 
                {-1,-1} => :alive, {0,-1} => :dead, {1,-1} => :dead}
      assert GameOfLife.grid(world) == [[:dead,:dead,:dead],
                                        [:dead,:dead,:dead],
                                        [:alive,:dead,:dead]]
      world = %{{-2,1} =>:alive,{-1,1}=>:dead, {0,1} =>:dead, {1,1} =>:dead,
                {-2,0} =>:dead, {-1,0}=>:alive,{0,0} =>:dead, {1,0} =>:dead, 
                {-2,-1}=>:dead,{-1,-1}=>:dead,{0,-1} =>:alive,{1,-1}=>:dead,
                {-2,-2}=>:dead,{-1,-2}=>:dead,{0,-2} =>:dead, {1,-2}=>:alive}
      assert GameOfLife.grid(world) == [[:alive,:dead,:dead,:dead],
                                        [:dead,:alive,:dead,:dead],
                                        [:dead,:dead,:alive,:dead],
                                        [:dead,:dead,:dead,:alive]]
    end
  end

  defmodule PrintTest do
    use ExUnit.Case
    import ExUnit.CaptureIO
    test "a world is printed as rows of icons" do 
      world = %{{-2,1} =>:alive,{-1,1}=>:dead, {0,1} =>:dead, {1,1} =>:dead,
                {-2,0} =>:dead, {-1,0}=>:alive,{0,0} =>:dead, {1,0} =>:dead, 
                {-2,-1}=>:dead,{-1,-1}=>:dead,{0,-1} =>:alive,{1,-1}=>:dead,
                {-2,-2}=>:dead,{-1,-2}=>:dead,{0,-2} =>:dead, {1,-2}=>:alive}
      clear_screen = "\e[H\e[J\n"    
           row_one = " ☙  ☠  ☠  ☠ \n" 
           row_two = " ☠  ☙  ☠  ☠ \n" 
         row_three = " ☠  ☠  ☙  ☠ \n" 
          row_four = " ☠  ☠  ☠  ☙ \n" 
      printed_world = clear_screen <> row_one <> row_two <> row_three <> row_four
      assert capture_io(fn -> GameOfLife.print(world) end) == printed_world
    end
  end

  defmodule RegenerateTest do 
    use ExUnit.Case
    test "regenerates cell according to status and neighbors" do 
      world = %{{-1,1}  => :dead,  {0,1}  => :dead,  {1,1}  => :dead,
                {-1,0}  => :alive, {0,0}  => :alive, {1,0}  => :alive, 
                {-1,-1} => :dead,  {0,-1} => :dead,  {1,-1} => :dead}
      assert GameOfLife.regenerate(world,{-1,0}) == :dead
      assert GameOfLife.regenerate(world,{0,0}) == :alive
      assert GameOfLife.regenerate(world,{1,0}) == :dead
      assert GameOfLife.regenerate(world,{0,1}) == :alive
      assert GameOfLife.regenerate(world,{0,-1}) == :alive
    end
  end

  defmodule NextTest do
    use ExUnit.Case 
    test "makes upsized world for next generation" do 
      world = %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
                {-1,0}  => :dead, {0,0}  => :alive, {1,0}  => :dead, 
                {-1,-1} => :dead, {0,-1} => :alive, {1,-1} => :dead}
      next_gen = %{{-2,2} =>:dead, {-1,2}=>:dead, {0,2} =>:dead, {1,2} =>:dead,{2,2} =>:dead,
                   {-2,1} =>:dead, {-1,1}=>:dead, {0,1} =>:dead, {1,1} =>:dead,{2,1} =>:dead,
                   {-2,0} =>:dead, {-1,0}=>:alive,{0,0} =>:alive,{1,0} =>:alive,{2,0}=>:dead, 
                   {-2,-1}=>:dead,{-1,-1}=>:dead,{0,-1} =>:dead, {1,-1}=>:dead,{2,-1}=>:dead,
                   {-2,-2}=>:dead,{-1,-2}=>:dead,{0,-2} =>:dead, {1,-2}=>:dead,{2,-2}=>:dead}
      assert GameOfLife.next(world) == next_gen
    end
  
  defmodule TickTest do
      use ExUnit.Case
      import ExUnit.CaptureIO
      test "ticks for n generations" do 
        clear_screen = "\e[H\e[J\n"
               row_l = " ☙  ☙  ☙ \n" 
               row_d = " ☠  ☠  ☠ \n" 
               ng_l = " ☠  ☠  ☙  ☠  ☠ \n" 
               ng_d = " ☠  ☠  ☠  ☠  ☠ \n"
        gen_zero = clear_screen <> row_d <> row_l <> row_d
        gen_one  = gen_zero <> clear_screen <> ng_d <> ng_l <> ng_l <> ng_l <> ng_d      
        world = %{{-1,1}  => :dead, {0,1}  => :alive, {1,1}  => :dead,
                  {-1,0}  => :dead, {0,0}  => :alive, {1,0}  => :dead, 
                  {-1,-1} => :dead, {0,-1} => :alive, {1,-1} => :dead}
        assert capture_io(fn -> GameOfLife.tick(world,0) end) == gen_zero
        assert capture_io(fn -> GameOfLife.tick(world,1) end) == gen_one
      end 
    end
  end
end