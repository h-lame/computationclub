# FILE hdr + IMAGE hdr + COLOR table + PIXEL data
# -- FILE hdr --
# TYPE          2bytes = "BM"
# SIZE          4bytes = 14 + 40 + colortable + pixel data
# RESERVED_1    2bytes = 0
# RESERVED_2    2bytes = 0
# PIXEL_OFFSET  4bytes = offest to start of pixel data
# -- IMAGE chunk --
# SIZE          4bytes = 40
# WIDTH         4bytes = width of image
# HEIGHT        4bytes = height of image
# PLANES        2bytes = 1
# BITCOUNT      2bytes = bits per pixel: 1,2,4,8,16,24,32
#                        NOTE: 16 & 32 mean a weird colour table, don't use them
# COMPRESSION   4bytes = compression type: 0
# SIZEIMAGE     4bytes = image size: 0 for uncompressed
# X_RESOLUTION  4bytes = preferred pixels per meter (X)
# Y_RESOLUTION  4bytes = preferred pixels per meter (Y)
# COLOURS_USED  4bytes = number of used colours (0 for 24bit)
# COLOURS_IMP   4bytes = number of important colours (0 for 24bit)
# -- COLOR table --
# Repeat the following for each colour (e.g. BITCOUNT of 8 = 256 colours)
# Blue          1byte = red value
# Green         1byte = green value
# Red           1byte = blue value
# Unused        1byte = 0
# -- PIXEL data --
# Data          .....
# Scan Lines must be multiples of 4-bytes, so we may have to pad with
# 0,1,2 or 3 null bytes for each line in the file.
# Scan Line = WIDTH * BITCOUNT
# NOTE - data rows are back to front - e.g. first row of data is bottom
# row of picture.

# TODO: some kinda callback registration so we can know what's happening
# during the various steps
require './genus'

class Bumps < Genus
  attr_accessor :bit_count

  def self.valid_bit_count(bit_count)
    # bits per pixel: 1,2,4,8,16,24,32
    # NOTE: 16 & 32 mean a weird colour table, don't use them
    bc = bit_count.to_i
    if [1,2,4,8,24].include? bc
      bc
    elsif bc < 1
      1
    elsif bc == 3
      4
    elsif (bc > 4 && bc < 8)
      8
    elsif (bc > 8 && bc < 24)
      24
    else
      24
    end
  end

  def initialize
    @bit_count = 8
  end

  def make_from(pixels)
    xy_pixels = pixels.transpose.reverse
    pixel_count = pixels.flatten.size
    width = xy_pixels.size
    height = xy_pixels.first.size
    line_pad_bits = scan_line_pad(width)
    image_details = [pixel_count, 0, [width, height], 0, line_pad_bits]
    bump_header = make_bump_header(image_details)
    write_genus_file('mandel', image_details, bump_header) do |file_part, bump_file, data_file, image_details, bump_header|
      if file_part == :header
        write_bump_header(bump_file, *bump_header)
      elsif file_part == :data
        write_bump_data(bump_file, xy_pixels, *image_details)
      end
    end
  end

  protected
  def genus_extension
    'bmp'
  end

  def colour_table_size
    if bit_count == 24
      0
    else
      colours = colour_count
      colours * 4
    end
  end

  def colour_count
    @_colour_count ||= 2 ** bit_count
  end

  def make_bump_header(img_details)
    (pixel_count, final_pixel_pad_bytes, (width, height), pad_pixels, line_pad_bytes) = img_details

    bump_size = 54 # header
    bump_size += colour_table_size # color table
    offset = bump_size
    image_size = (((width * bit_count) / 8) + line_pad_bytes) * height # pixel data
    bump_size += image_size

    file_header = "BM"
    file_header += [bump_size, 0, 0, offset].pack("Vv2V")

    image_header = [40, width, height, 1, bit_count, 0, 0].pack("V3v2V2")
    # I can honestly say that whilst I know what these mean, I don't
    # know if these default values can affect the stored data or not
    image_header += [96, 96].pack('V2')

    if bit_count == 24
      image_header += [0,0].pack('V2')
    else
      image_header += [2**bit_count,0].pack('V2')
    end

    colour_table = if bit_count == 24
                     nil
                   else
                     get_colour_table
                   end
    [file_header, image_header, colour_table]
  end

  def write_bump_header(bump_file, file_header, image_header, colour_table)
    bump_file.write(file_header)
    bump_file.write(image_header)
    unless colour_table.nil?
      colours = colour_table.flatten
      bump_file.write(colours.pack('c%d' % colours.size))
    end
    bump_file.flush()
  end

  def get_colour_table
    # I'm not super sure how exactly we do this.  I think we might want to use
    # the file data for this, which means we should do nothing here, but
    # change the calculations of stuff to take it into account.
    case bit_count
    when 1
      [[0x00,0x00,0x00,0x00], [0xFF,0xFF,0xFF,0x00]] #black and white
    when 2
      [[0x00,0x00,0x00,0x00], [0xFF,0xFF,0xFF,0x00],
       [0x00,0x00,0xFF,0x00], [0xFF,0x00,0x00,0x00]] #black, white, red, blue
    when 4 # standard windows 16-bit colours... CGA?
      [[0x00,0x00,0x00,0x00], [0x00,0x00,0x80,0x00], [0x00,0x80,0x00,0x00], [0x00,0x80,0x80,0x00],
       [0x80,0x00,0x00,0x00], [0x80,0x00,0x80,0x00], [0x80,0x80,0x00,0x00], [0xC0,0xC0,0xC0,0x00],
       [0x80,0x80,0x80,0x00], [0x00,0x00,0xFF,0x00], [0x00,0xFF,0x00,0x00], [0x00,0xFF,0xFF,0x00],
       [0xFF,0x00,0x00,0x00], [0xFF,0x00,0xFF,0x00], [0xFF,0xFF,0x00,0x00], [0xFF,0xFF,0xFF,0x00]]
    when 8
      grid = ((0..7).inject([]) do |rows, row_num|
        row = ((0..7).inject([]) do |row, chunk_num|
          (0..3).inject(row) do |row_again, cell_in_chunk_num|
            row_again << [(0+(36*chunk_num)), (0+(36*row_num)), (0+(85*cell_in_chunk_num)), 0x00]
            row_again
          end
        end)
        rows << row
        rows
      end)
      grid[7][31] = [0xff,0xff,0xff,0x00] # white, not the 0xfc,0xfc,0xff off-white the above will generate
      grid
    when 24
      nil
    end
  end

  def scan_line_pad(width)
    spare = ((width * @bit_count) % 32)
    if spare == 0
      spare
    else
      (32 - spare) / 8
    end
  end

  def write_bump_data(bump_file, pixels, pixel_count, final_pixel_pad_bytes, dimensions, pad_pixels, line_pad_bytes)
    (width, height) = dimensions

    line_pad = [].pack("x%d" % line_pad_bytes)

    # write data
     pixels.each do |row|
      bump_file.write(row.pack("C%d" % row.size))
      bump_file.write(line_pad)
    end
    bump_file.flush()

    #write final padding - I'm pretty sure this *could* go bad for a bit_count of less than a byte
    pad_data_row = pad_pixels % width
    data_row = [].pack("x%d" % pad_data_row) + line_pad
    bump_file.write(data_row)
    bump_file.flush()

    pad_rows = pad_pixels / width
    pad_row = [].pack("x%d" % ((width * bit_count) / 8)) + line_pad
    pad_rows.times do
      bump_file.write(pad_row)
    end
  end
end
