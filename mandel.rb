
def pixels_for_count(count)
  # count > 4 ? '#' : '.'
  [' ','.','-','/','|','<','{','%','&','@','#'][count % 10]
end

acorn = -2.4
bcorn = -1.2
size = 3.1
pixels = []
(1..150).each do |j|
  pixels[j-1] = []
  (1..150).each do |k|
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
    pixels[j-1][k-1] = pixels_for_count(count)
  end
end

puts pixels.transpose.map {|r| r.join}.join("\n")
