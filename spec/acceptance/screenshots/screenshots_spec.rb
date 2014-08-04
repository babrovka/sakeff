require 'acceptance_helper'
include Features::RoutesHelper

feature "All pages are created correctly", js: true, screenshots: true do

  let(:super_user) { create(:super_user) }
  let(:permission) { create(:permission) }
  let(:organization) { create(:organization) }
  let(:role) { create(:role) }
  let(:user) { create(:user) }
  let!(:unit) { create(:unit) }
  let!(:child_unit) { create(:child_unit) }
  let!(:grandchild_unit) { create(:grandchild_unit) }
  let(:routes) { routes_array }

  shared_examples :screenshottable do |access|
    it "successfully opens pages and creates screenshots" do
      routes.select{|hash| hash[:access] == access}.each do |route|
        visit route[:path]
        route[:action].call if route[:action]

        screenshot_name = "#{route[:file_name]}.jpeg"
        screenshot_path = "#{Rails.root.join("test_images", "screenshots")}/#{screenshot_name}"
        page.save_screenshot(screenshot_path, full: true)

        expect(File.exists? screenshot_path).to be
      end
    end
  end

  context 'on guest pages' do
    it_behaves_like :screenshottable, :guest
  end

  context 'on user pages' do
    before { login_as(user, scope: :user) }

    pending "Because phantomjs doesn't support webgl" do
      it_behaves_like :screenshottable, :user
    end
  end

  context 'on super_user pages' do
    before { login_as(super_user, scope: :super_user) }

    it_behaves_like :screenshottable, :super_user
  end
end