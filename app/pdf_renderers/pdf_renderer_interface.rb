# Structure class for all pdf renderers
# @param permit [Permit]
# @todo in future: make PDFPage class with data, settings and background attr readers
class PDFRendererInterface < Prawn::Document
  include ActsAsInterface

  def initialize(permit)
    @permit = permit
    super(layout_settings) # sets layout settings
    init_fonts
    draw_document
  end


  # Default render options
  # @note is called in pdf rendering from controller
  def render_options
    {type: 'application/pdf', disposition: 'inline'}
  end


  private


  # Draws a page with settings, background and texts
  # @note is called in draw_document
  # @param page_data [Hash] page data with texts
  # @param page_settings [Hash] page layout settings
  # @param background [String] url to an image
  def draw_page(page_data, page_settings, background)
    change_background(background)
    start_new_page(page_settings)
    draw_texts(page_data)
  end


  # Changes current page background
  # @note is called in draw_page
  # @param url [String] to an image file
  # @param scale [Float] (optional) decimal scale
  def change_background(url, scale = 0.5)
    @background = url
    @background_scale = scale
  end


  # Draws text for each text in array
  # @note is used in draw_document
  # @param page_data [Array of Hash] all page texts
  def draw_texts(page_data)
    page_data.each do |text_data|
      draw_text(text_data)
    end
  end


  # Draws text at given location and style
  # @note is used in draw_texts
  # @param text_data [Hash] text data and styles
  def draw_text(text_data)
    text_data[:styles] ||= {}
    styles = {
      style: :normal,
      size: 12,
      align: :left,
      font: 'OpenSans'
    }.merge(text_data[:styles])

    # Fixes flawed Prawn color logic by setting new color and reverting it back after text render
    if styles[:color]
      previous_color = current_fill_color
      fill_color styles[:color]
    end

    # text_data[:coordinates].lasdfads
    font styles[:font] do
      text_box text_data[:text].to_s, at: text_data[:coordinates], style: styles[:style], size: styles[:size], align: styles[:align]
    end

    fill_color previous_color if previous_color
  end


  # Stores default all pages layout settings in a Hash
  def layout_settings
    {
      skip_page_creation: true
    }
  end


  # Enables fonts
  # @note must be implemented
  # @note is called in draw_document
  def init_fonts
    implement_me!
  end


  # Renders resulting pdf in browser
  # @note must be implemented
  # @note is called in initialize
  def draw_document
    implement_me!
  end
end
