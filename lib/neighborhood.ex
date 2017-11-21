defmodule GameOfLife.Neighborhood do

@doc """
  get_all_neighbors_of(cells): 
    Behavior: 
    Unlike the Cell.find_neighbor_locations function,
    which is given a single cell & returns that cells adjacent locations, 
    this function gets ALL neighbors, from ALL given cells in a list...   
    Steps-
    1. From a given list of cell locations, enumerate over each cell and 
       call the Cell.find_neighbor_locations on it.
    2. Once all cells have been mapped to their neighbors, transform to a list, and 
       flatten, so that all the neighbors of all the cells originally passed in 
       are reduced to a single dimension list.
""" 

  def get_all_neighbors_of(cells) do
    List.flatten(Enum.map(cells, 
      fn({x,y}) -> 
        GameOfLife.Cell.find_neighbor_locations({x,y}) 
      end))
  end

@doc """
  count_live_neighbors_of(cells):
    Behavior: Uses tail recursion & pattern matching to count occurences 
    of LIVE neighbors from a given list of Cells... 
    Motivation: This function enables the conditionals neccessary for generational rules... By having a count of the live neighbors for each specific cell, we can filter out cells that meet the criteria for under/overpopulation
    Steps-
    1. Pipe a given list of cells into the recursive function 
       w/ all neighbors as the 2nd argument, 
       and an empty list as 3rd argument for accumulation.
    2. Recursive Function w/ Pattern Matching...
        A. BASE CASE: 
           A call to the function with an empty list of cells, 
           an aliased list of neighbors, and the accumulator, live_neighbors, 
           which is returned. 
        B. RECURSION: 
           I.   Use pattern matching to split the head cell location, ([{x,y}|...) 
                and the tail (...|other_living_cells]) 
           II.  Enumerate through our list of neighbors counting the times we encounter a neighbor location 
                that is the same as our head cell location and then adding it to our accumulator as a sublist
           III. Recurse and call again on the tail of the list (other_living_cells)
""" 

  def count_live_neighbors_of(cells) do 
    cells |> count_live_neighbors_of(get_all_neighbors_of(cells),[]) 
  end
  def count_live_neighbors_of([],_,live_neighbors) do live_neighbors end 
  def count_live_neighbors_of([{x,y}|other_living_cells],neighbors,live_neighbors) do 
    live_neighbor_count = live_neighbors ++ [[{x,y},
      Enum.count(neighbors, 
        fn({a,b}) ->
          {a,b} == {x,y}
        end)]]
    other_living_cells |> count_live_neighbors_of(neighbors,live_neighbor_count)
  end

end
