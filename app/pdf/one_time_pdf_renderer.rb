# Handles rendering of a one time permit
class OneTimePDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    page = OneTimePDFPage.new(@permit)
    draw_page(page)
  end


  private


  # @see PDFRenderer
  def init_fonts
    font_families.update(
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf",
        bold: "#{Rails.root}/app/assets/fonts/OpenSans_Bold/OpenSans-Bold-webfont.ttf"
      }
    )
  end
end
