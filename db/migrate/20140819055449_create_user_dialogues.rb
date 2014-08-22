class CreateUserDialogues < ActiveRecord::Migration
  def change
    create_table :user_dialogues, :id => false do |t|
      t.uuid :user_id
      t.uuid :dialogue_id
    end
  end
end
