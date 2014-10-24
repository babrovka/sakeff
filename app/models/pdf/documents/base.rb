# Struct which stores pdf document data for Prawn
# @note is used in Base
class Pdf::Documents::Base < Struct.new(:permit)
  extend AbstractMethods
  abstract_methods :fonts, :pages
end
