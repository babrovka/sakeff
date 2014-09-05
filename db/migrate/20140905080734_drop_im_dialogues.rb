class DropImDialogues < ActiveRecord::Migration
  def change
    drop_table :im_dialogues
  end
end
