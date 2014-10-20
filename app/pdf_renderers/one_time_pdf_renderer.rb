# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # Renders resulting pdf in browser
  def apply_data
    @pdf.text @data[:text]
  end
end
