require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage broadcast messages", js: true do

  let(:path){ messages_broadcast_path }
  let(:messages){ 10.times.map{ create(:message) } }


  let!(:user){ create(:user) }
  #read permission
  let!(:user2){ create(:user) }
  #no permission
  let!(:user3){ create(:user) }
  #write permission

  let!(:allowed_user) do
    user.permissions << Permission.where(title: 'read_broadcast_messages').first
    up = user.user_permissions.where(permission: Permission.where(title: :read_broadcast_messages)).first
    up.result = :granted
    up.save!
    user
  end
  let!(:allowed_user2) do
    user3.permissions << Permission.where(title: 'read_broadcast_messages').first
    up = user3.user_permissions.where(permission: Permission.where(title: :read_broadcast_messages)).first
    up.result = :granted
    up.save!
    user3.permissions << Permission.where(title: 'send_broadcast_messages').first
    up = user3.user_permissions.where(permission: Permission.where(title: :send_broadcast_messages)).first
    up.result = :granted
    up.save!


    user3
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

  describe 'view broadcast form' do

    context 'without write permission' do
      background do
        login_as(user2, :scope => :user)
        visit path
      end
      scenario 'no form' do
        #except(user.has_permission?(allow_write_broadcast)).to be false
        expect(page).to_not have_css  '._messages-broadcast__form'
      end
    end

    context 'with write permission' do
      background do
        login_as(user3, :scope => :user)
        visit path
      end
      scenario 'have form' do
        expect(page).to have_css  '._messages-broadcast__form'
      end
    end

  end

  describe 'send message with broadcast form' do


      background do
        login_as(user3, :scope => :user)
        visit path
      end
      scenario 'send message and check' do
        #expect(page).to have_css  '._messages-broadcast__form'
        fill_in 'im_message[text]', with: 'This is test message generate today'
        click_on 'Отправить'
        sleep 1
        visit path
        expect(page).to have_content 'This is test message generate today'
      end


  end


end