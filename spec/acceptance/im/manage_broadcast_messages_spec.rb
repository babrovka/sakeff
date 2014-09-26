require 'acceptance_helper'
require 'support/behaviours/units_tree_viewable'

feature "User manage and view broadcast messages", js: true do

  let(:path){ messages_broadcast_path }
  let(:messages){ 10.times.map{ create(:message) } }

  let!(:user_without_permission){ create(:user) }

  let!(:user_with_read_permission) do
    user = create(:user)
    user.set_permission(:read_broadcast_messages, :granted)
    user
  end
  let!(:user_with_write_permission) do
    user = create(:user)
    user.set_permission(:read_broadcast_messages, :granted)
    user.set_permission(:send_broadcast_messages, :granted)
    user
  end

  describe 'view broadcast page' do
    context 'with allow permission' do
      background do
        login_as(user_with_read_permission, scope: :user)
        visit path
      end

      context 'using direct link' do
        it 'be success' do
          expect(page.find('.js-left-menu')).to have_content 'Сообщения'
          expect(current_path).to eq path
        end
      end

    end

    context 'without permission' do
      background do
        login_as(user_without_permission, scope: :user)
        visit path
      end
      context 'using direct link' do
        it 'be failed' do
          expect(current_path).to_not eq path
          expect(page).to_not have_content 'Message text'
          expect(page.find('.js-left-menu')).to_not have_content 'Сообщения'
        end
      end
    end
  end

  describe 'view broadcast form' do

    context 'without write permission' do
      background do
        login_as(user_without_permission, scope: :user)
        visit path
      end
      scenario 'no form' do
        expect(page).to_not have_css  '.spec-broadcast-form'
      end
    end

    context 'with write permission' do
      background do
        login_as(user_with_write_permission, scope: :user)
        visit path
      end
      scenario 'have form' do
        expect(page).to have_css  '.spec-broadcast-form'
      end
    end

  end

  describe 'send message with broadcast form' do


      background do
        login_as(user_with_write_permission, scope: :user)
        visit path
      end
      scenario 'render message for all organizations' do
        fill_in 'im_message[text]', with: 'This is test message generate today'
        click_on 'Отправить'
        sleep 1
        visit path
        expect(page).to have_content 'This is test message generate today'
        sign_out
        login_as(user_with_read_permission, scope: :user)
        visit path
        expect(page).to have_content 'This is test message generate today'
        expect(user_with_write_permission.organization.id).to_not eq user_with_read_permission.organization.id
      end


  end


end