defmodule GameOfLife do
  def lives?(status,living_neighbor_count) do 
    if status == :alive do 
      living_neighbor_count >= 2 && living_neighbor_count <= 3
    else 
      living_neighbor_count === 3 
    end
  end 

  def northeast({col,row}) do 
    if row === 1 do 
      if col === 1, do: {-2,-2}, else: {1,-2}
    else 
      if col === 1, do: {-2,1}, else: {1,1}
    end
  end

  def southeast({col,row}) do 
    if row === -1 do 
      if col === 1, do: {-2,2}, else: {1,2}
    else 
      if col === 1, do: {-2,-1}, else: {1,-1}
    end
  end
  
  def northwest({col,row}) do 
    if row === 1 do 
      if col === -1, do: {2,-2}, else: {-1,-2}
    else 
      if col === -1, do: {2, 1}, else: {-1,1}
    end
  end
  
  def southwest({col,row}) do 
    if row === -1 do 
      if col === -1, do: {2,2}, else: {-1,2}
    else 
      if col === -1, do: {2,-1}, else: {-1,-1}
    end
  end

  def living_neighbors(world,{col,row}) do
    n  = if row   ==  1,  do: {0,-2}, else: {0,1} 
    s  = if row   == -1,  do: {0,2},  else: {0,-1}
    w  = if col == -1,  do: {2,0},  else: {-1,0}
    e  = if col ==  1,  do: {-2,0}, else: {1,0}
    ne = {col,row} |> northeast
    se = {col,row} |> southeast
    nw = {col,row} |> northwest
    sw = {col,row} |> southwest
    directions = [
                  nw,n,ne,
                   w,   e,
                  sw,s,se
                 ]
    neighbors = for {distance_h, distance_v} <- directions, do: 
      world[{col+distance_h,row+distance_v}]
    Enum.count(neighbors, fn(status) -> status == :alive end)
  end

  def tick(world,generations) do
    :timer.sleep 100
    if generations == 0 do 
      IO.inspect world 
    else
      IO.puts "\n"
      IO.puts "==============================="
      IO.puts "#{world[{-1,1}]}---#{world[{0,1}]}---#{world[{1,1}]}"
      IO.puts "#{world[{-1,0}]}---#{world[{0,0}]}---#{world[{1,0}]}"
      IO.puts "#{world[{-1,-1}]}---#{world[{0,-1}]}---#{world[{1,-1}]}"
      IO.puts "==============================="
      tick(Enum.into(world, %{},
        fn({pos,_}) -> 
          {pos,(if lives?(world[pos],living_neighbors(world,pos)) do
                :alive
              else 
                :dead
              end)} 
        end),generations-1)
    end
  end 
end