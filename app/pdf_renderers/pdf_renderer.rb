# Structure class for all pdf renderers
# @param permit [Permit]
class PDFRenderer < Prawn::Document
  include Implementer

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


  # Draws text for each text in array
  # @note is used in draw_document
  # @param texts [Array] 2d array of texts of structure
  #   [Symbol], [Integer], [Hash(optional)]
  # @example
  #   draw_texts([
  #     [:id, 295, { style: :bold, size: 16 }],
  #     [:last_name, 80]
  #   ])
  def draw_texts(texts)
    texts.each do |text|
      style_options = text[2] || {}
      draw_text(text[0], text[1], style_options)
    end
  end


  # Draws text at given location and style
  # @note is used in draw_texts
  # @param permit_data_field [Symbol] field name from permit_data
  # @param x_location [Integer] x coordinates of this text
  # @param style_options [Hash] styling options
  # @example
  #   draw_text(:id, 675, { style: :bold, size: 16 })
  # @see y_coordinates
  # @see permit_data
  def draw_text(permit_data_field, x_location, style_options = {})
    text_coordinates = [x_location, y_coordinates[permit_data_field]]
    text = permit_data[permit_data_field].to_s
    styles = {
      style: :normal,
      size: 12,
      font: 'OpenSans'
    }.merge(style_options)

    font styles[:font] do
      text_box text, at: text_coordinates, style: styles[:style], size: styles[:size]
    end
  end


  # Stores permit data which will be displayed on permit pdf itself
  # @note must be implemented
  # @note must be manually maintained
  # @note is called in draw_text
  def permit_data
    implement_me!
  end


  # Holds shared info for y coordinates for different permit_data fields
  # @note must be implemented
  # @note is used in draw_text and must be manually maintained
  def y_coordinates
    implement_me!
  end


  # Stores layout settings in a Hash
  # @note must be implemented
  # @note is called in initialize
  def layout_settings
    implement_me!
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
