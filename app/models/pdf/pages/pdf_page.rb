# Struct which stores pdf page data for Prawn
# @note is used in PdfDocument
class Pdf::Pages::PdfPage < Struct.new(:permit)
  include ActsAsInterface

  # Stores page settings such as size, margin, etc
  # @note must be implemented
  def settings
    implement_me!
  end


  # Stores page text data
  # @note must be implemented
  def data
    implement_me!
  end


  # Stores page background
  # @note must be implemented
  def background
    implement_me!
  end
end
