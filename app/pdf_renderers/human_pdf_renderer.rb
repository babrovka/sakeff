# Handles rendering of a human permit card
class HumanPDFRenderer < PDFRenderer
  def apply_data
    @pdf.text @data[:text]
  end
end
