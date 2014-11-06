# Includes methods for permit form acceptance specs
module Features
  module PermitFormMethods
    def fill_form_by_permit(permit)
      %w(first_name last_name middle_name doc_number expires_at).each do |field|
        fill_in "permit[#{field}]", with: permit.send(field.to_sym)
      end
    end

    def submit_edit_form(permit)
      click_button "Сохранить"
      permit.reload
    end


    def fill_once_fields
      fill_in "permit_location", with: "location"
      fill_in "permit_person", with: "person"
    end


    def toggle_car_type
      trigger_custom_checkbox("permit_car")
    end

    def toggle_once_type
      trigger_custom_checkbox("permit_once")
    end

    def trigger_custom_checkbox(checkbox_id)
      page.find("##{checkbox_id}").trigger('click')
    end


    def car_input
      "permit_car_brand"
    end

    def once_input
      "permit_location"
    end

    def starts_at_input
      "permit[starts_at]"
    end
  end
end
