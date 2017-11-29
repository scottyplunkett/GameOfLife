defmodule GameOfLife do

  def iconify(cell) do if cell == :alive, do: " \u2619 ", else: " \u2620 " end

  def grid(world) do 
    (for {{_x,_y},status} <- Enum.sort(Map.to_list(world)), do: status) 
    |> Enum.chunk_every(trunc(:math.sqrt(map_size(world)))) |> Enum.reverse
  end

  def lives?(:alive,count) do count >= 2 && count <= 3 end
  def lives?(_,count)  do count === 3 end

  def living_neighbors(world,location) do
    Enum.count((for position <- neighbors(location), do: world[position]), 
                    fn(status) -> status == :alive end) 
  end

  def clear_screen do IO.puts "\e[2J" end 

  def print(world) do 
    clear_screen()
    for row <- grid(world), do: (for cell <- row, do: iconify(cell)) 
    |> IO.puts 
  end

  def regenerate(world,pos) do 
    if lives?(world[pos],living_neighbors(world,pos)), do: :alive, else: :dead
  end

  def neighbors({col,row},d\\[-1,0,1]) do 
    for x <- d, y <- d, {x,y} != {0,0}, do: {col + x, row + y}
  end

  def next(world) do 
    (for {{x,y},_} <- world, do: neighbors({x,y})) 
    |> List.flatten |> Enum.uniq |> List.flatten
    |> Enum.into(%{},fn(pos) -> {pos,regenerate(world, pos)} end) 
  end

  def tick(world,generations) do
    :timer.sleep 200
    print(world)
    unless generations == 0, do: tick(next(world),generations-1)
  end 
end