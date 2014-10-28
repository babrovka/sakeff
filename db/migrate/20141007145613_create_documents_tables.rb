class CreateDocumentsTables < ActiveRecord::Migration
  def change
    create_table "attached_documents_relations", id: :uuid do |t|
      t.uuid "document_id"
      t.uuid "attached_document_id"
    end

    create_table "conformations", id: :uuid do |t|
      t.uuid  "document_id"
      t.uuid  "user_id"
      t.boolean  "conformed"
      t.string   "comment"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "conformations", ["document_id", "user_id"], :name => "index_conformations_on_document_id_and_user_id", :unique => true

    create_table "document_attached_files", id: :uuid do |t|
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.uuid  "document_id"
      t.datetime "created_at",              :null => false
      t.datetime "updated_at",              :null => false
    end

    create_table "documents", id: :uuid do |t|
      t.string   "title",                                        :null => false
      t.string   "serial_number"
      t.text     "body"
      t.boolean  "confidential",              :default => false, :null => false
      t.uuid     "sender_organization_id",                       :null => false
      t.uuid     "recipient_organization_id"
      t.uuid     "approver_id",                                  :null => false
      t.uuid     "executor_id",                                  :null => false
      t.string   "state"
      t.string   "accountable_type",                             :null => false
      t.uuid     "accountable_id",                               :null => false
      t.datetime "created_at",                                   :null => false
      t.datetime "updated_at",                                   :null => false
      t.datetime "approved_at"
      t.uuid  "creator_id"
      t.datetime "read_at"
    end

    add_index "documents", ["accountable_id", "accountable_type"], :name => "index_documents_on_accountable_id_and_accountable_type", :unique => true
    add_index "documents", ["approver_id"], :name => "index_documents_on_approver_id"
    add_index "documents", ["executor_id"], :name => "index_documents_on_executor_id"
    add_index "documents", ["recipient_organization_id"], :name => "index_documents_on_recipient_organization_id"
    add_index "documents", ["sender_organization_id"], :name => "index_documents_on_sender_organization_id"

    create_table "official_mails", id: :uuid do |t|
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "official_mails_organizations", :id => false do |t|
      t.uuid "official_mail_id", :null => false
      t.uuid "organization_id",  :null => false
    end

    create_table "orders", id: :uuid do |t|
      t.datetime "deadline"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.datetime "started_at"
    end

    create_table "reports", id: :uuid do |t|
      t.uuid  "order_id",   :null => false
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index "reports", ["order_id"], :name => "index_reports_on_order_id"

    create_table "documents_users", :id => false do |t|
      t.uuid "document_id", :null => false
      t.uuid "user_id",     :null => false
    end

    create_table "task_lists", id: :uuid do |t|
      t.uuid  "order_id"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
      t.datetime "deadline"
    end

    add_index "task_lists", ["order_id"], :name => "index_task_lists_on_order_id"

    create_table "tasks", id: :uuid do |t|
      t.uuid  "task_list_id"
      t.text     "title"
      t.boolean  "completed",                :default => false
      t.datetime "created_at",                                  :null => false
      t.datetime "updated_at",                                  :null => false
      t.uuid  "document_id"
      t.uuid  "executor_organization_id"
      t.uuid  "sender_organization_id"
      t.datetime "deadline"
      t.uuid  "executor_id"
      t.uuid  "creator_id"
      t.uuid  "approver_id"
      t.text     "executor_comment"
      t.text     "body"
    end
  end
end
