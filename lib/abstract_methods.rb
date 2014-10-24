# Adds methods for easier inheritance control of different classes
# @note is used in Pdf
module AbstractMethods
  # Dynamically initializes methods and causes them to fail
  # Forces classes which inherit from class with these methods to implement them
  # @param methods [Symbol] method name(s)
  def abstract_methods(*methods)
    methods.each do |method|
      define_method(method) do
        fail NotImplementedError,
             "Method #{method} method must be implemented in this class. Refer to #{self.class.superclass} class for more details."
      end
    end
  end
end
