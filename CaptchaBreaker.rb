# Author: Hugo Ribeira
# 13 Aug 2014

require 'RMagick'
require 'rtesseract'

class CaptchaBreaker
  def initialize(image_string)
    @image = Magick::Image.from_blob(image_string).first
    @image = @image.quantize(3, Magick::GRAYColorspace)
  end

  def break
    @image = binarize_image(@image)
    2.times { @image = erode(@image) }
    3.times { @image = dilate(@image) }

    # Use tesseract to read the characters
    @image.format = 'JPEG'
    tesseract = RTesseract.new('')
    tesseract.from_blob @image.to_blob

    tesseract.to_s_without_spaces
  end

  private

  def get_pixels(image)
    image.dispatch(0, 0, image.columns, image.rows, 'R')
  end

  def image_from_pixels(pixels)
    pixels = pixels.map{ |px| [px,px,px] }.flatten # Replicate channels to create an rgb image
    Magick::Image.constitute(@image.columns, @image.rows, 'RGB', pixels)
  end

  def binarize_image(image)
    # Filter out the white line in the captcha and make the image binary
    pixels = get_pixels(image)
    colors = pixels.uniq.sort
    pixels = pixels.map { |px| px == colors.last ? 0 : px }
    image  = image_from_pixels(pixels)
    image  = image.quantize(2, Magick::GRAYColorspace)
  end

  def erode(image, action = :erode)
    pixels = get_pixels(image)

    if action == :erode
      white = pixels.uniq.sort.last
    else
      white = pixels.uniq.sort.first
    end

    pixels.each_with_index do |px, i|
      next if px == white # skip white pixels
      pixels[i] = 1 if pixels[i + 1] == white ||
                           pixels[i - 1] == white ||
                           pixels[i + image.columns] == white ||
                           pixels[i - image.columns] == white
    end
    pixels.each_with_index do |px, i|
      pixels[i] = white if px == 1
    end

    image_from_pixels(pixels)
  end

  def dilate(image)
    # Dilating is eroding if you exchange the blacks with whites and vice versa
    erode(image, :dilate)
  end
end
