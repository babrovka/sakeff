# Structure class for all pdf renderers
# @param data [Hash] data to be rendered on pdf
# @param layout_settings [Hash]
class PDFRenderer < Prawn::Document
  # @todo: pass Permit here
  def initialize
    super(layout_settings) # sets layout settings
    draw_document
  end


  # Default render options
  # @note is called in pdf rendering from controller
  def render_options
    {type: 'application/pdf', disposition: 'inline'}
  end


  private


  # Stores layout settings in a Hash
  # @note must be redeclared
  # @note is called in initialize
  def layout_settings
    fail NotImplementedError, "layout_settings must be implemented in this subclass"
  end


  # Renders resulting pdf in browser
  # @note must be redeclared
  # @note is called in initialize
  def draw_document
    fail NotImplementedError, "draw_document method must be implemented in this subclass"
  end
end
