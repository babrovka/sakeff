require 'rails_helper'

describe Permission do

  describe 'title' do

    let(:permission) { build(:permission) }

    context 'format' do
      it 'valid' do
        permission.title = 'create_user'
        expect(permission.valid?).to be true
      end

      %w(CreateUser Create_user абракадабра create@ create-user create_user! ).each do |title|
        it 'invalid' do
          permission.title = title
          expect(permission.valid?).to be false
        end
      end
    end

  end


end