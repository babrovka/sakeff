class CreateImDialogues < ActiveRecord::Migration
  def change
    create_table :im_dialogues, id: :uuid do |t|

      t.timestamps
    end
  end
end
