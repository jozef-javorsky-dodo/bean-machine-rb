require 'chunky_png'

class GaltonBoard
  DEFAULT_NUM_ROWS = 12
  DEFAULT_NUM_BALLS = 50_000
  DEFAULT_BOARD_WIDTH = 1000
  DEFAULT_BOARD_HEIGHT = 600
  PEG_RADIUS = 8
  BACKGROUND_COLOR = ChunkyPNG::Color.rgb(102, 51, 153)
  LEFT_HALF_COLOR = ChunkyPNG::Color.rgb(122, 122, 244)
  RIGHT_HALF_COLOR = ChunkyPNG::Color.rgb(122, 244, 122)

  def initialize(num_rows = DEFAULT_NUM_ROWS, num_balls = DEFAULT_NUM_BALLS, board_width = DEFAULT_BOARD_WIDTH, board_height = DEFAULT_BOARD_HEIGHT)
    @num_rows = num_rows
    @num_balls = num_balls
    @board_width = board_width
    @board_height = board_height
    @slot_counts = Array.new(board_width, 0)
    @image = ChunkyPNG::Image.new(board_width, board_height, BACKGROUND_COLOR)
  end

  def simulate
    @num_balls.times do
      @slot_counts[calculate_bin_index] += 1
    end
  end

  def generate_image
    draw_histogram
    @image
  end

  def save_image(filename = 'galton_board.png')
    generate_image.save(filename)  
  end

  private

  def calculate_bin_index
    bin_index = @board_width / 2
    @board_height.times do
      random_direction = [-1, 1].sample
      bin_index += random_direction
    end
    [[0, bin_index].max, @board_width - 1].min
  end

  def draw_histogram
    max_frequency = @slot_counts.max
    bar_width = @board_width / @slot_counts.count

    @slot_counts.each_with_index do |frequency, bin_index|
      draw_bar(frequency, bin_index, max_frequency, bar_width)
    end
  end

  def draw_bar(frequency, bin_index, max_frequency, bar_width)
    bar_height = calculate_bar_height(frequency, max_frequency)
    bar_height.times do |y_offset|
      bar_width.times do |x_offset|
        draw_pixel(bin_index, bar_width, x_offset, y_offset)
      end
    end
  end

  def calculate_bar_height(frequency, max_frequency)
    (frequency.to_f / max_frequency * @board_height).to_i
  end

  def draw_pixel(bin_index, bar_width, x_offset, y_offset)
    pixel_x = bin_index * bar_width + x_offset
    pixel_y = @board_height - y_offset - 1
    color = pixel_x < @board_width / 2 ? LEFT_HALF_COLOR : RIGHT_HALF_COLOR
    @image[pixel_x, pixel_y] = color
  end
end

def generate_galton_board
  board = GaltonBoard.new
  board.simulate  
  board.save_image
end

generate_galton_board

