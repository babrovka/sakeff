require 'acceptance_helper'

feature "User view dashboard", %q() do

  let!(:user) { create(:user) }
  let(:path) { profile_path }

  describe 'with authorization' do
    background do
      login_as(user, scope: :user)
      visit path
    end

    it 'success', js: true do
      expect(current_path).to eq path
      expect(page).to have_content user.first_name
      expect(page).to have_content user.last_name
      expect(page).to have_content user.title
    end
  end

  describe 'without authorization' do
    before do
      visit path
    end

    it 'failed' do
      expect(page).to_not have_content user.first_name
      expect(page).to_not have_content user.last_name
      expect(page).to_not have_content user.title
    end
  end

end

