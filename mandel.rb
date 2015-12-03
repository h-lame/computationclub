

require 'optparse'

options = { complex: false, width: 600, height: 600, acorn: -2, bcorn: -2, size: 4, iterations: 100, bmp: false }
OptionParser.new do |opts|
  opts.banner = "Usage: mandel.rb [options]"

  opts.on("-c", "Use complex library") { options[:complex] = true }
  opts.on("-wWIDTH", "Output width") { |w| options[:width] = Integer(w) }
  opts.on("-hHEIGHT", "Output height") { |h| options[:height] = Integer(h) }
  opts.on("-aACORN", "Mandelbrot viewport top right corner x") { |a| options[:acorn] = Float(a) }
  opts.on("-bBCORN", "Mandelbrot viewport top right corner y") { |b| options[:bcorn] = Float(b) }
  opts.on("-sSIZE", "Mandelbrot viewport size") { |s| options[:size] = Float(s) }
  opts.on("-iITERATIONS", "Mandelbrot iterations") { |i| options[:iterations] = Integer(i) }
  opts.on("-p", "Output BMP") { options[:bmp] = true }

end.parse!

acorn = options[:acorn]
bcorn = options[:bcorn]
width = options[:width].to_f
height = options[:height].to_f
size = options[:size]
iterations = options[:iterations]

algorithm =
  if options[:complex]
    require 'complex'
    ->(j,k) {
      z = Complex(0)
      ca = acorn + ((j * size) / width)
      cb = bcorn + ((k * size) / height)
      c = Complex(ca, cb)
      count = zx = zy = 0
      begin
        count = count + 1
        xtemp = z.abs
        z = z**2 + c
      end while (count < iterations) && (xtemp <= 2)
      count
    }
  else
    ->(j,k) {
      ca = acorn + ((j * size) / width)
      cb = bcorn + ((k * size) / height)
      count = zx = zy = 0
      begin
        count = count + 1
        zxx = zx * zx
        zyy = zy * zy
        xtemp = zxx - zyy
        zxy = zx * zy
        zy = (2 * zxy) + cb
        zx = xtemp + ca
      end while (count < iterations) && ((zxx + zyy) < 4)
      count
    }
  end

pixels = []
(1..width).each do |j|
  pixels[j-1] = []
  (1..height).each do |k|
    count = algorithm.call(j,k)
    pixels[j-1][k-1] = count
  end
end

if options[:bmp]
  require './bumps'

  Bumps.new.make_from(pixels)
else
  PIXEL_DATA = ['.','-','/','|','<','{','%','&','@','#',' ']
  pixel_for_count = ->(x) { PIXEL_DATA[(((PIXEL_DATA.size-1) * x) / iterations)] }

  puts pixels.transpose.map { |r| r.map { |c| pixel_for_count[c] }.join }.join("\n")
end
