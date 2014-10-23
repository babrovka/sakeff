# Handles rendering of a human permit
class HumanPDFRenderer < PDFRenderer
  # @see PDFRenderer
  def draw_document
    page = HumanPDFPage.new(@permit)
    draw_page(page)
  end


  private


  # @see PDFRenderer
  def init_fonts
    font_families.update(
      'OpenSans' => {
        normal: "#{Rails.root}/app/assets/fonts/OpenSans_Regular/OpenSans-Regular-webfont.ttf"
      }
    )
  end
end
