# Renders a passed document
# @note is used in permits controller
# @param document [PdfDocument]
class Pdf::Renderers::BasePdfRenderer < Prawn::Document
  def initialize(document)
    super(layout_settings) # sets layout settings
    init_fonts(document.fonts)
    draw_document(document)
  end


  # Default render options
  # @note is called in pdf rendering from controller
  def render_options
    {type: 'application/pdf', disposition: 'inline'}
  end


  private


  # Renders resulting pdf in browser
  # @note is called in initialize
  # @param document [PdfDocument]
  def draw_document(document)
    document.pages.each do |page_symbol|
      # converts :one_time to OneTimePdfPage
      page_class = "Pdf::Pages::#{page_symbol.to_s.camelize}".constantize
      page = page_class.new(document.permit)
      draw_page(page)
    end
  end


  # Draws a page with settings, background and texts
  # @note is called in draw_document
  # @param page [PDFPage] Struct with background, settings and data
  def draw_page(page)
    change_background(page.background)
    start_new_page(page.settings)
    draw_texts(page.data)
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
  # @param page_data [Array of Hash] page texts
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

    font styles[:font] do
      text_box text_data[:text].to_s, at: text_data[:coordinates], style: styles[:style], size: styles[:size], align: styles[:align]
    end

    fill_color previous_color if previous_color
  end


  # Stores default all pages layout settings in a Hash
  # @note is set in initialize
  def layout_settings
    {
      skip_page_creation: true
    }
  end


  # Enables fonts
  # @note is called in initialize
  # @param fonts [Hash]
  def init_fonts(fonts)
    font_families.update(fonts)
  end
end
