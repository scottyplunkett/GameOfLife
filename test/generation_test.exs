defmodule GameOfLife.GenerationTest do
  use ExUnit.Case, async: true

  setup _present_generation do
    {:ok, [
            with_three_cells_not_underpopulated: [{1,1},{1,2},{2,2},{2,0}],
            not_underpopulated:   [[{1,1},3],[{1,2},2],[{2,2},2]]
          ]
    }
  end

  test "A generation can kill off underpopulated cells", present_generation do 
    assert GameOfLife.Generation.kill_underpopulated_from(present_generation[:with_three_cells_not_underpopulated]) == present_generation[:not_underpopulated] 
  end
end