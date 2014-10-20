# Structure class for all pdf renderers
# @param data [Hash]
class PDFRenderer
  include Prawn::View

  def initialize(data)
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
    redeclare_me
  end
end
