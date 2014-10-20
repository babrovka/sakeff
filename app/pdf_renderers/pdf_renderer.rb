# Structure class for all pdf renderers
# @param data [Hash]
class PDFRenderer

  def initialize(data = nil)
    @pdf = Prawn::Document.new
    @data = data

    apply_data
  end


  # Renders contents
  # @note is called in pdf rendering from controller
  def render_contents
    @pdf.render
  end


  # Default render options
  # @note is called in pdf rendering from controller
  def render_options
    {type: "application/pdf", disposition: 'inline'}
  end


  private


  # Renders resulting pdf in browser
  # @note must be redeclared
  # @note is called in initialize
  def apply_data
    redeclare_me
  end
end
