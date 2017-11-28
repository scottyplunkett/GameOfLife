# GameOfLife
Conway's Game of Life in Elixir Implementation using TDD

*Instructions assume you have Elixir installed*

## Instructions
To run:

### 1
clone repo to local machine
```bash
git clone https://github.com/scottyplunkett/GameOfLife.git
```

### 2
change directory into local repo copy
```bash
cd GameOfLife
```

### 3
compile app
```bash
mix compile 
```

### 4
open interactive elixir shell with compiled app
```bash
iex -S mix 
```

### 5 
have fun 
```elixir
almost_human = %{{-1,1}  => :alive, {0,1}  => :dead, {1,1}  => :alive,
                {-1,0}  => :dead, {0,0}  => :alive, {1,0}  => :alive, 
                {-1,-1} => :dead, {0,-1} => :dead, {1,-1} => :alive}

GameOfLife.tick(almost_human,25)
```

## Running Test

follow Instructions 1-3
then: 
```bash
mix test --trace
```

## Generate Coverage Report

follow Instructions 1-3
then: 
```bash
mix test --cover
```
```bash
cd cover
```
```bash
open Elixir.GameOfLife.html
```

