# Structure class for all pdf renderers
# @param data [Hash] data to be rendered on pdf
# @param layout_settings [Hash]
class PDFRenderer < Prawn::Document

  def initialize(layout_settings, data)
    super(layout_settings) # sets layout settings

    @data = data
    draw_document
  end


  # Renders contents
  # @note is called in pdf rendering from controller
  def render_contents
    render
  end


  # Default render options
  # @note is called in pdf rendering from controller
  def render_options
    {type: 'application/pdf', disposition: 'inline'}
  end


  private


  # Renders resulting pdf in browser
  # @note must be redeclared
  # @note is called in initialize
  def draw_document
    fail NotImplementedError, "draw_document method must be implemented in this subclass"
  end
end
