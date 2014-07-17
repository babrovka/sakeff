require 'rails_helper'

describe User do

  describe '#permission_result' do
    let(:user) { create(:user) }
    context 'without role' do
      context 'when exist 5 permissions and one is forbidden' do
        let!(:permission) do
          p = create(:permission)
          user.permissions << p
          user.save!
          p
        end

        context 'without any actions on permissions' do
          it 'return <default>' do
            result = user.permission_result(permission)
            expect(result).to eq 'default'
          end
        end

        context 'with saved result for permission' do
          [:default, :forbidden, :granted].each do |result|
            it "return <#{result.to_s}>" do
              user_permission = UserPermission.where(user_id: user.id, permission_id: permission.id).first
              user_permission.result = result.to_s
              user_permission.save!
              expect(user.permission_result(permission)).to eq result.to_s
            end
          end
        end
      end

      context 'with role' do
      end

    end
  end


end