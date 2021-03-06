# Helper for dam status blocks
module ObjectStatusHelper

  # Renders a block with dam status
  # @note is used in users dashboard
  # @param block_id [String] css if of this block
  # @param object_name [String] name of this block/object
  # @param status_text [String] text of current block status
  # @param status_type [String] type of status
  # @param image_path [String] path to an image file
  # @example
  #   = object_status("global_object", "Статус КЗС", "Нормальный",
  #                   "normal", "pages/dashboard/kzs.jpg")
  def object_status(block_id, object_name, status_text, status_type, image_path)
    status_class = case status_type
                     when "alarm"
                       "text-red"
                     else
                       "text-green"
                   end
    content_tag(:div, class: "_object-status-block", id: block_id.camelize(:lower)) do
      content_tag(:h4) do
        object_name + ":"
      end +
      content_tag(:h2, class: status_class + " js-status-type") do
        status_text
      end +
      image_tag(image_path, alt: object_name) +
      content_tag(:div, class: "bg-box bg-box-black") do end
    end
  end

end