# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # Renders resulting pdf in browser
  def draw_document
    say_goodbye("fucker")
    say_hello
  end


  def say_goodbye(name)
    font("Courier") do
      text "Goodbye, #{name}!"
    end
  end


  def say_hello
    text "Wooo, #{@data[:text]}!"
  end
end
