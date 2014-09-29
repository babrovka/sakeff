#
module Dialogues
  extend ActiveSupport::Concern

  private

   def collection
     unless @dialogues
       @dialogues = []
       dialogues_organizations = Organization.all - [current_organization]
       dialogues_organizations.each do |organization|
         dialogue = Im::Dialogue.new(current_user, :organization, organization.id)
         @dialogues.push dialogue
       end
       @dialogues.compact.flatten
     end
   end

   def d_collection
     @d_dialogues ||= Im::DialoguesDecorator.decorate collection
   end

   def check_read_permissions
     unless current_user.has_permission?(:read_organization_messages)
       redirect_to users_root_path, error: 'У вас нет прав на просмотр доступных диалогов'
     end
   end

end
