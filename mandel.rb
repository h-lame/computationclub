

require 'optparse'

options = { width: 600, height: 600, acorn: -2, bcorn: -2, size: 4, iterations: 100 }
OptionParser.new do |opts|
  opts.banner = "Usage: mandel.rb [options]"

  opts.on("-wWIDTH", "Output width") { |w| options[:width] = Integer(w) }
  opts.on("-hHEIGHT", "Output height") { |h| options[:height] = Integer(h) }
  opts.on("-aACORN", "Mandelbrot viewport top right corner x") { |a| options[:acorn] = Float(a) }
  opts.on("-bBCORN", "Mandelbrot viewport top right corner y") { |b| options[:bcorn] = Float(b) }
  opts.on("-sSIZE", "Mandelbrot viewport size") { |s| options[:size] = Float(s) }
  opts.on("-iITERATIONS", "Mandelbrot iterations") { |i| options[:iterations] = Integer(i) }

end.parse!

acorn = options[:acorn]
bcorn = options[:bcorn]
width = options[:width].to_f
height = options[:height].to_f
size = options[:size]
iterations = options[:iterations]

pixels = []
(1..width).each do |j|
  pixels[j-1] = []
  (1..height).each do |k|
    ca = acorn + ((j * size) / 150.0)
    cb = bcorn + ((k * size) / 150.0)
    count = zx = zy = 0
    begin
      count = count + 1
      zxx = zx * zx
      zyy = zy * zy
      xtemp = zxx - zyy
      zxy = zx * zy
      zy = (2 * zxy) + cb
      zx = xtemp + ca
    end while (count < 100) && ((zxx + zyy) < 4)
    pixels[j-1][k-1] = count
  end
end

PIXEL_DATA = ['.','-','/','|','<','{','%','&','@','#',' ']
pixel_for_count = ->(x) { PIXEL_DATA[(((PIXEL_DATA.size-1) * x) / iterations)] }

puts pixels.transpose.map { |r| r.map { |c| pixel_for_count[c] }.join }.join("\n")
