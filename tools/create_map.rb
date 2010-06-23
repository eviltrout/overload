require 'rubygems'
require 'csv'

WIDTH = 20
HEIGHT = 8

TILES = {
  :left => {:up => 4, :down => 5, :left => 2},
  :right => {:up => 3, :down => 6, :right => 2},
  :up => {:up => 1, :left => 6, :right => 5},
  :down => {:down => 1, :left => 3, :right => 4}
}


DIRECTIONS = [:up, :down, :left, :right]
OPPOSITE = {
  :up => :down,
  :down => :up,
  :left => :right,
  :right => :left
}

map = []

HEIGHT.times do |y|
  map[y] ||= []
  WIDTH.times do |x|
    map[y][x] = 0
  end
end

def border_spot
  case (rand * 4).floor
    when 0 then [0, (rand * WIDTH).floor, :down]
    when 1 then [HEIGHT-1, (rand * WIDTH).floor, :up]
    when 2 then [(rand * HEIGHT).floor, 0, :right]
    when 3 then [(rand * HEIGHT).floor, WIDTH-1, :left]
  end
end

3.times do
  y, x, t = border_spot
    
  map[y][x] = ((x==0) or (x == WIDTH-1)) ? 2 : 1
  
  30.times do
    x = x - 1 if t == :left
    x = x + 1 if t == :right
    y = y - 1 if t == :up
    y = y + 1 if t == :down
    
    next if x < 0 or y < 0 or x >= WIDTH or y >= HEIGHT
    
    possible = DIRECTIONS
    possible = possible - [OPPOSITE[t]]
    possible = possible - [:left] if x == 0 or map[y][x - 1] != 0
    possible = possible - [:right] if x == (WIDTH - 1) or map[y][x + 1] != 0
    possible = possible - [:down] if y == (HEIGHT - 1) or map[y+1][x] != 0
    possible = possible - [:up] if y == 0 or map[y-1][x] != 0
    
    next if possible.empty?
    
    new_t = (possible)[(rand * possible.size).floor]

    
    
    map[y][x] = TILES[t][new_t]
    t = new_t
    
  end
end

File.open("data/map.txt", "w") do |f|
  map.each do |r|
    f << r.join(",") + "\n"
  end
end