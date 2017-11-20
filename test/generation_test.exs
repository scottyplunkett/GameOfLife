defmodule GameOfLife.GenerationTest do
  use ExUnit.Case, async: true

  setup _present_generation do
    {:ok, [
            with_three_cells_not_underpopulated: 
              [{1,1},{1,2},{2,2},{2,0}],
            not_underpopulated:
              [[{1,1},3],[{1,2},2],[{2,2},2]],
            with_one_cell_overpopulated: 
              [{1,1},{2,0},{2,1},{2,2},{3,1}],
            without_one_overpopulated: 
              [[{1,1},3],[{2,0},3],[{2,2},3],[{3,1},3]],
            with_two_cells_overpopulated: 
              [{1,1},{2,0},{2,1},{2,2},{3,1},{-2,-1},{-2,-2},{-2,-3},{-1,-2},{-3,-2}],
            without_two_overpopulated: 
              [[{1,1},3],[{2,0},3],[{2,2},3],[{3,1},3],[{-2,-1},3],[{-2,-3},3],[{-1,-2},3],[{-3,-2},3]],
            with_three_living_cells_around_one_dead_cell:
              [{4,2},{6,2},{5,3}],
            following_reproduction:
              [{5,2}]
          ]
    }
  end

  test "A generation can kill off underpopulated cells", present_generation do 
    assert GameOfLife.Generation.kill_underpopulated_from(present_generation[:with_three_cells_not_underpopulated]) == present_generation[:not_underpopulated] 
  end

  test "A generation can kill off overpopulated cells", present_generation do 
    assert GameOfLife.Generation.kill_overpopulated_from(present_generation[:with_one_cell_overpopulated]) == present_generation[:without_one_overpopulated]
    assert GameOfLife.Generation.kill_overpopulated_from(present_generation[:with_two_cells_overpopulated]) == present_generation[:without_two_overpopulated]  
  end

  test "A generation can reproduce in dead cell locations where there are exactly 3 living neighbors", present_generation do 
      assert GameOfLife.Generation.reproduce_from(present_generation[:with_three_living_cells_around_one_dead_cell]) == present_generation[:following_reproduction]
  end

end