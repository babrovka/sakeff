require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage broadcast messages", js: true do

  let(:path){ broadcast_messages_path }
  let(:messages){ 10.times.map{ create(:message) } }
  let(:user){ create(:user, organization: messages.last.organization) }

  let(:allow_read_broadcast) { 'blah' }
  let(:allow_write_broadcast) { 'blah' }

  background do
    login_as(user, :scope => :user)
    visit path
    except(current_path).to eq path
  end

  describe 'view broadcast messages' do
    context 'with allow permission' do
      scenario 'render messages list' do
        user.set_permission(allow_read_broadcast)
        visit path
        messages.each do |message|
          except(page).to have_content message.text
          except(page).to have_content message.sender.first_name
        end
      end
    end

    context 'without permission' do
      scenario 'redirect to root path' do
        except(user.has_permission?(allow_read_broadcast)).to be false
        messages.each do |message|
          except(page).to_not have_content message.text
        end
        except(current_path).to_not eq path
      end
    end
  end

  describe 'write broadcast messages' do
    context 'with allow permission' do
      scenario 'throught rendered form' do
      end
    end

    context 'without permission' do
      scenario 'not allowed' do
      end
    end
  end

end