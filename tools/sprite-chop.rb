require 'rubygems'
require 'RMagick'

i = Magick::ImageList.new("explosion.gif")
  
m = i.montage do
  self.geometry = "+0+0"
  self.tile = "x1"
end

#t = m.transparent('black')

m.write("explosion-montage.png")