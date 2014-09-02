require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage broadcast messages", js: true do

  let(:path){ broadcast_messages_path }
  let(:im){  }

  describe 'check permissions to view broadcast messages' do
    context 'with allow permission' do
      scenario 'render messages list' do
      end
    end

    context 'without permission' do
      scenario 'redirect to root path' do
      end
    end
  end

  describe 'check permissions to write broadcast messages' do
    context 'with allow permission' do
      scenario 'render form' do
      end
    end

    context 'without permission' do
      scenario 'not render form' do
      end
    end
  end

end