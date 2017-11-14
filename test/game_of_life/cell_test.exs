defmodule GameOfLife.CellTest do
  use ExUnit.Case, async: true

  test "A Cell can stay or come alive" do
    location = {1,1}
    dead_cell = %{location => :dead}
    living_cell = %{location => :alive}
    assert GameOfLife.Cell.live(dead_cell,location) == %{{1,1} => :alive}
    assert GameOfLife.Cell.live(living_cell,location) == %{{1,1} => :alive}
  end

  test "A Cell can stay or be dead" do
    location = {1,1}
    dead_cell = %{location => :dead}
    living_cell = %{location => :alive}
    assert GameOfLife.Cell.die(dead_cell,location) == %{{1,1} => :dead}
    assert GameOfLife.Cell.die(living_cell,location) == %{{1,1} => :dead}
  end

  test "A living Cell responds true to is_alive?" do
    location = {1,1}
    living_cell = %{location => :alive}
    assert GameOfLife.Cell.is_alive?(living_cell,location) == true
  end

  test "A dead Cell responds false to is_alive?" do
    location = {1,1}
    dead_cell = %{location => :dead}
    assert GameOfLife.Cell.is_alive?(dead_cell,location) == false
  end

end