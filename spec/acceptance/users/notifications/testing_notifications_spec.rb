require 'acceptance_helper'

feature "Special User can send all notifications" do

  let!(:user) { create(:user) }
  let!(:special_user) { create(:user, username: 'special_test_user') }
  let(:path) { websockets_test_path }


  describe 'Signing only for special user' do

    scenario 'access deny' do
      login_as(user, :scope => :user)
      visit path
      expect(current_path).to_not eq path
    end

    scenario 'access allow' do
      login_as(special_user, :scope => :user)
      visit path
      expect(current_path).to eq path
    end

  end

  describe 'Special user has all permissions' do
    scenario 'storage in db' do
      login_as(special_user, :scope => :user)
      visit path
      special_user.reload
      permissions_diff = Permission.all - special_user.permissions
      expect(Permission.count).to be >= 0
      expect(permissions_diff).to be_empty
    end
  end

end