# Struct which stores pdf page data for Prawn
# @note is used in PdfDocument
class Pdf::Pages::BasePdfPage < Struct.new(:permit)
  extend AbstractMethods
  abstract_methods :settings, :data, :background
end
