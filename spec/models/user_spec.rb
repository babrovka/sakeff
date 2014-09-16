require 'rails_helper'

describe User do
  
  describe '#validate_dublicated_permissions' do
    let(:user) { create(:user) }

    context 'with dublicated permission' do
      it "not valid" do
        permission = create(:permission)
        user.user_permissions.build permission_id: permission.id, result: 'granted'
        user.user_permissions.build permission_id: permission.id, result: 'granted'
        expect(user.valid?).to eq false
      end
    end
  end

  describe '#permission_result' do
    let(:allowed_results) { [:default, :granted, :forbidden] }
    let(:user) { create(:user) }

    context 'without role' do
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
      context 'only role permissions' do
        let!(:permission) { create(:permission) }

        let!(:role) do
          r = create(:role)
          user.roles << r
          user.save!
          RolePermission.create(role_id: r.id, permission_id: permission.id)
          r
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
              role_permission = RolePermission.where(role_id: role.id, permission_id: permission.id).first
              role_permission.result = result
              role_permission.save!
              expect(user.permission_result(permission)).to eq result.to_s
            end
          end
        end

      end
    end

    context 'with permission and role-permission ' do
      let!(:permission) do
        p = create(:permission)
        user.permissions << p
        user.save!
        p
      end

      let!(:role) do
        r = create(:role)
        user.roles << r
        user.save!
        RolePermission.create(role_id: r.id, permission_id: permission.id)
        r
      end


      context 'without any actions on permissions' do
        it 'return <default>' do
          result = user.permission_result(permission)
          expect(result).to eq 'default'
        end
      end

      context 'with saved same result for permissions' do
        [:default, :forbidden, :granted].each do |result|
          it "return <#{result.to_s}>" do
            role_permission = RolePermission.where(role_id: role.id, permission_id: permission.id).first
            role_permission.result = result
            role_permission.save!

            user_permission = UserPermission.where(user_id: user.id, permission_id: permission.id).first
            user_permission.result = result.to_s
            user_permission.save!

            expect(user.permission_result(permission)).to eq result.to_s
          end
        end
      end

      context 'with saved varoius result for permissions' do
        context 'one <default> value' do

          context 'for role permission' do
            [:forbidden, :granted].each do |result|
              it 'return not <default>' do
                user_permission = UserPermission.where(user_id: user.id, permission_id: permission.id).first
                user_permission.result = result.to_s
                user_permission.save!

                expect(user.permission_result(permission)).to_not eq 'default'
              end
            end
          end


          context 'for direct permission' do
            [:forbidden, :granted].each do |result|
              it 'return not <default>' do
                role_permission = RolePermission.where(role_id: role.id, permission_id: permission.id).first
                role_permission.result = result.to_s
                role_permission.save!

                expect(user.permission_result(permission)).to_not eq 'default'
              end
            end
          end

        end

        context 'direct permission will primary' do

          [:forbidden, :granted].each do |result|
            it "return <#{result.to_s}>" do
              role_permission = RolePermission.where(role_id: role.id, permission_id: permission.id).first
              role_permission.result = ([:forbidden, :granted] - [result]).first
              role_permission.save!

              user_permission = UserPermission.where(user_id: user.id, permission_id: permission.id).first
              user_permission.result = result.to_s
              user_permission.save!

              expect(user.permission_result(permission)).to eq result.to_s
            end
          end

        end
      end
    end


  end
  
  describe '#has_permission?' do
    let(:allowed_results) { [:default, :granted, :forbidden] }
    let(:user) { create(:user) }
    let(:permission) { create(:permission) }
    
    it 'return true' do
      UserPermission.create!(user_id: user.id, permission_id: permission.id, result: 'granted')
      user.reload
      expect(user.has_permission?(permission.title)).to be true      
    end
    
    context 'result forbidden' do    
      it 'return false' do
        UserPermission.create!(user_id: user.id, permission_id: permission.id, result: 'forbidden')
        user.reload
        expect(user.has_permission?(permission.title)).to be false      
      end
    end
    
    context 'result default' do    
      it 'return false' do
        UserPermission.create!(user_id: user.id, permission_id: permission.id, result: 'default')
        user.reload
        expect(user.has_permission?(permission.title)).to be false      
      end
    end
  end



end