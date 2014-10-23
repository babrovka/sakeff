# Struct which stores pdf document data for Prawn
# @note is used in PdfRenderer
class Pdf::Documents::PdfDocument < Struct.new(:permit)
  include ActsAsInterface

  # Stores document fonts
  # @note must be implemented
  def fonts
    implement_me!
  end


  # Stores pages which must be rendered in an array
  # @note must be implemented
  def pages
    implement_me!
  end
end
