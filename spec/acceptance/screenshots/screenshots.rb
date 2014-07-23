require 'acceptance_helper'

feature "All pages are created correctly" do

  let(:super_user) { create(:super_user) }
  let(:permission) { create(:permission) }
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }

  let(:routes) do
    [
     { path: new_user_session_path, role: :guest, file_name: "user_login" },
     { path: root_path, role: :guest, file_name: "root" },
     { path: new_super_user_session_path, role: :guest, file_name: "super_user_login" },
     { path: super_user_root_path, role: :super_user, file_name: "super_user_root" },
     # { path: library_path, role: :super_user, file_name: "library" }
    ]
  end

  context 'on guest pages', js: true do
    it "successfully opens and creates screenshots for them" do
      routes.select{|hash| hash[:role] == :guest}.each do |route|
        if route[:model_id].present?

        else
          visit route[:path]
          screenshot_name = "#{route[:file_name]}.jpeg"
          screenshot_path = "#{Rails.root.join("test_images", "screenshots")}/#{screenshot_name}"
          page.save_screenshot(screenshot_path, full: true)

          expect(current_path).to eq route[:path]
        end
      end
    end
  end

  context 'on super_user pages', js: true do
    before { login_as(super_user, :scope => :super_user) }

    it "successfully opens and creates screenshots for them" do
      routes.select{|hash| hash[:role] == :super_user}.each do |route|
        if route[:model_id].present?

        else
          visit route[:path]
          screenshot_name = "#{route[:file_name]}.jpeg"
          screenshot_path = "#{Rails.root.join("test_images", "screenshots")}/#{screenshot_name}"
          page.save_screenshot(screenshot_path, full: true)

          expect(current_path).to eq route[:path]
        end
      end
    end
  end
end