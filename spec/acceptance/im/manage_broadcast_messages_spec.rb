require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage broadcast messages", js: true do

  let(:path){ messages_broadcast_path }
  let(:messages){ 10.times.map{ create(:message) } }


  let!(:user){ create(:user) }
  let!(:user2){ create(:user) }
  let!(:allowed_user) do
    user.permissions << Permission.where(title: 'read_broadcast_messages').first
    up = user.user_permissions.where(permission: Permission.where(title: :read_broadcast_messages)).first
    up.result = :granted
    up.save!
    user
  end

  #let(:allow_read_broadcast) { :read_broadcast_messages }
  #let(:allow_write_broadcast) { :send_broadcast_messages }
  #


  describe 'view broadcast messages' do
    context 'with allow permission' do
      pending 'render messages list' do
        user.set_permission(allow_read_broadcast)
        except(user.has_permission?(allow_read_broadcast)).to be true
        visit path
        messages.each do |message|
          except(page).to have_content message.text
          except(page).to have_content message.sender.first_name
        end
      end
    end

    context 'without permission' do
      pending 'redirect out' do
        except(user.has_permission?(allow_read_broadcast)).to be false
        messages.each do |message|
          except(page).to_not have_content message.text
        end
        except(current_path).to_not eq path
      end
    end
  end

  describe 'view broadcast with using direct link, and with menu-item' do
    context 'with allow permission' do
      background do
        login_as(user, :scope => :user)
        visit path
      end
      it 'using direct link' do
        expect(current_path).to eq path
        expect(page.find('.js-left-menu')).to have_content 'Сообщения'
      end

    end

    context 'without permission' do
      background do
        login_as(user2, :scope => :user)
        visit path
      end
      it 'by direct link' do
        expect(current_path).to_not eq path
        expect(page.find('.js-left-menu')).to_not have_content 'Сообщения'
      end
    end
  end

  describe 'write broadcast messages' do
    context 'with allow permission' do
      pending 'using rendered form' do
        user.set_permission(allow_write_broadcast)
        except(user.has_permission?(allow_write_broadcast)).to be true
        visit path
        within '.spec-message-form' do
          expect(page).to have_content 'отправить'
        end
      end
    end

    context 'without permission' do
      pending 'not allowed' do
        except(user.has_permission?(allow_write_broadcast)).to be false
        expect(page).to_not have_css  '.spec-message-form'
        expect(page).to_not have_content 'отправить'
      end
    end
  end

end