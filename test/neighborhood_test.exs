defmodule GameOfLife.NeighborhoodTest do
  use ExUnit.Case, async: true

  setup _the_list do
    {:ok, [
            of_two_living_cells: [{1,1},{1,2}],
            of_three_living_cells: [{1,1},{1,2},{2,2}],
            of_four_living_cells: [{1,1},{1,2},{2,2},{2,0}],
            of_neighbors_of_two_living_cells:  [{2, 1}, {2, 2}, {1, 2}, {0, 2}, {0, 1}, {0, 0}, {1, 0}, {2, 0}, {2, 2}, {2, 3}, {1, 3}, {0, 3}, {0, 2}, {0, 1}, {1, 1}, {2, 1}]
          ]
    }
  end

  test "A neighborhood can gather all locations adjacent to all cells in a list", the_list do 
    assert GameOfLife.Neighborhood.get_all_neighbors_of(the_list[:of_two_living_cells]) == the_list[:of_neighbors_of_two_living_cells] 
  end

  test "A neighborhood can count number of neighbors of each live cell that are also live cells", the_list do 
    assert GameOfLife.Neighborhood.count_live_neighbors_of(the_list[:of_two_living_cells]) == [[{1,1},1],[{1,2},1]]
    assert GameOfLife.Neighborhood.count_live_neighbors_of(the_list[:of_three_living_cells]) == [[{1,1},2],[{1,2},2],[{2,2},2]]
    assert GameOfLife.Neighborhood.count_live_neighbors_of(the_list[:of_four_living_cells]) == [[{1,1},3],[{1,2},2],[{2,2},2],[{2,0},1]]
  end

end

