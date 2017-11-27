defmodule GameOfLife do
  def lives?(status,count) do 
    if status == :alive do 
      count >= 2 && count <= 3
    else 
      count === 3 
    end
  end

  def neighbors({col,row}) do 
    for dx <- [-1, 0, 1], dy <- [-1, 0, 1], {dx,dy} != {0,0}, do: 
      {col + dx, row + dy}
  end

  def living_neighbors(world,location) do
    Enum.count((for position <- neighbors(location), do: 
      world[position]), fn(status) -> status == :alive end)
  end

  def new_world(old_world) do 
    List.flatten(for {{x,y},_} <- old_world, do: neighbors({x,y}) 
    |> List.flatten  
    |> Enum.uniq)
    |> Enum.into(%{},fn(pos) -> 
      {pos,(if lives?(old_world[pos],living_neighbors(old_world,pos)) do
              :alive
            else 
              :dead
            end)}
          end) 
  end

  def tick(world,generations) do
    :timer.sleep 100
    world |> print
    IO.puts "\n"      
    unless generations == 0 do 
      tick(new_world(world),generations-1)
    end
  end 

  def grid(world) do 
    Enum.reverse(Enum.chunk_every((for {{_x,_y},status} <- Enum.sort(Map.to_list(world)), do: if status === :alive, do: " \u2619 ", else: " \u2620 "), trunc(:math.sqrt(map_size(world)))))
  end

  def print(world) do 
    IO.puts "\e[H\e[J"
    for row <- world |> grid, do: row |> IO.puts 
  end
end