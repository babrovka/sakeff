require 'acceptance_helper'

feature "User interacts with units", js: true do

  let(:user) { create(:user) }
  let!(:unit) { create(:unit) }
  let!(:child_unit) { create(:child_unit) }
  let!(:grandchild_unit) { create(:grandchild_unit) }

  describe 'on index page' do
    before do
      login_as(user, :scope => :user)
      visit units_path
    end

    describe 'at start' do
      it 'has just one node' do
        expect(page.all(".jstree-node").count).to eq(1)
      end
    end

    describe 'clicking on them' do
      before { first(".jstree-ocl").click }

      it 'gets a new node' do
        expect(page.all(".jstree-node").count).to eq(2)
      end

      it 'hides a node' do
        first(".jstree-ocl").click

        expect(page.all(".jstree-ocl").count).to eq(1)
      end
    end
  end
end