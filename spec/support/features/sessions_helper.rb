# coding: utf-8
module Features
  module SessionsHelper

    def sign_in_with(email, password='password')
      within '.spec-login-form' do
        fill_in 'user[login]', with: email
        fill_in 'user[password]', with: password
        click_on 'Вход'
      end
    end

    def sign_out
      visit destroy_user_session_path
    end

    def skip_welcome
      execute_script(%Q!$(document).ready(function(){$('.js-welcome-screen, .modal-backdrop-white').remove()})!)
    end

    def sign_out_js
      visit destroy_user_session_path
    end

  end
end
