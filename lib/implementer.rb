# Adds methods for easier inheritance control of different classes
# @note is used in PDFRenderer
module Implementer
  # Raises an error on not implemented methods which should be implemented
  # This way it forces a method to be implemented (re-declared) in an inherited class
  def implement_me!
    method_to_implement = caller_locations(1, 1)[0].label #caller method http://stackoverflow.com/questions/5100299/how-to-get-the-name-of-the-calling-method
    fail NotImplementedError, "#{method_to_implement} method must be implemented in this subclass. Refer to #{self.class.name} class for more details."
  end
end