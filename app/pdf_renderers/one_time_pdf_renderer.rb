# Handles rendering of a one time permit renderer
class OneTimePDFRenderer < PDFRenderer
  # Renders resulting pdf in browser
  def draw_document
    this = self
    Prawn::Document.new(page_size: "A4", page_layout: :landscape) do
      this.say_goodbye("fucker")
      this.say_hello
    end
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
