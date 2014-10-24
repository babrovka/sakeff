# Struct which stores pdf document data for Prawn
# @note is used in BasePdfRenderer
class Pdf::Documents::BasePdfDocument < Struct.new(:permit)
  extend AbstractMethods
  abstract_methods :fonts, :pages
end
