# Includes methods for permit index acceptance specs
module Features
  module PermitListMethods
    # Disactivates a certain permit
    # @param permit [Permit]
    # @note is used in index permits tests
    def disactivate_permit(permit)
      open_popover(permit)
      click_on_disactivate_permit
      permit.reload
    end


    # Finds a permit in permits list
    # @param permit [Permit]
    # @note is used in index permits tests
    def permit_element(permit)
      page.find(".block-table__tr[data-permit='#{permit.id}']")
    end


    # Attempts to open a popover of a certain permit
    # @param permit [Permit]
    # @note is used in index permits tests
    def try_to_open_popover(permit)
      within permit_element(permit) do
        page.find(".label-sea-green").click
      end
    end


    # Opens a popover of a certain permit and checks if everything is ok
    # @param permit [Permit]
    # @note is used in index permits tests
    def open_popover(permit)
      try_to_open_popover(permit)
      expect(page).to have_css ".m-active .js-permit-print-popover"
    end


  # Clicks on disactivation link
  # @note is used in index permits tests
    def click_on_disactivate_permit
      page.find(".m-active .js-permit-print-popover span", text: "Отменить пропуск").click
    end


    # Clicks on print link
    # @note is used in index permits tests
    def click_on_print_permit
      page.find(".m-active .js-permit-print-popover span", text: "Распечатать").click
    end
  end
end
