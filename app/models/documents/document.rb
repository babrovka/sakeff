# coding: utf-8
# == Schema Information
#
# Table name: documents
#
#  id                        :uuid             not null, primary key
#  title                     :string(255)      not null
#  serial_number             :integer
#  body                      :text
#  confidential              :boolean          default(FALSE), not null
#  sender_organization_id    :uuid             not null
#  recipient_organization_id :uuid
#  approver_id               :uuid             not null
#  executor_id               :uuid             not null
#  state                     :string(255)
#  accountable_type          :string(255)      not null
#  accountable_id            :uuid             not null
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  approved_at               :datetime
#  creator_id                :uuid
#  read_at                   :datetime
#
# Indexes
#
#  index_documents_on_accountable_id_and_accountable_type  (accountable_id,accountable_type) UNIQUE
#  index_documents_on_approver_id                          (approver_id)
#  index_documents_on_executor_id                          (executor_id)
#  index_documents_on_recipient_organization_id            (recipient_organization_id)
#  index_documents_on_sender_organization_id               (sender_organization_id)
#

class Documents::Document < ActiveRecord::Base

  # Нотификации
  include Notifier

  acts_as_notifier do
    interesants :approver, :executor, :conformers, :receivers
  end

  has_many :document_attached_files, dependent: :destroy

  # Приложенные документы
  has_and_belongs_to_many :attached_documents,
                          class_name: "Documents::Document",
                          uniq: true,
                          join_table: "attached_documents_relations",
                          foreign_key: "document_id",
                          association_foreign_key: "attached_document_id"

  # Согласования
  has_many :conformations

  belongs_to :accountable, polymorphic: true
  after_destroy {|document| document.accountable.destroy }

  belongs_to :approver, class_name: 'User'
  belongs_to :executor, class_name: 'User'
  belongs_to :creator, class_name: 'User'
  has_and_belongs_to_many :conformers, class_name: 'User'

  belongs_to :sender_organization, class_name: 'Organization'
  belongs_to :recipient_organization, class_name: 'Organization'

  accepts_nested_attributes_for :document_attached_files, allow_destroy: true
  accepts_nested_attributes_for :attached_documents, allow_destroy: true

  alias_attribute :text, :body
  alias_attribute :sn,   :serial_number
  alias_attribute :sender, :sender_organization
  alias_attribute :recipient, :recipient_organization
  alias_attribute :organization_id, :sender_organization_id

  after_save :create_png

  validates_presence_of :title,
                        :sender_organization_id,
                        :approver_id,
                        :executor_id,
                        :body

  validates_presence_of :recipient_organization,
                        unless: :can_have_many_recipients?

  # Scope by state
  scope :draft,    -> { where(state: 'draft') }
  scope :prepared,  -> { where(state: 'prepared') }
  scope :approved,  -> { where(state: 'approved') }
  scope :not_draft, -> { where { state.not_eq('draft') } }

  # Scope by type
  scope :orders, -> { where(accountable_type: 'Documents::Order') }
  scope :mails,  -> { where(accountable_type: 'Documents::OfficialMail') }
  scope :reports, -> { where(accountable_type: 'Documents::Report') }

  scope :visible_for,  lambda { |org_id|
    where do
      sender_organization_id.eq(org_id) |
      (recipient_organization_id.eq(org_id) &
          state.in(%w(sent accepted rejected)))
    end
  }

  scope :to_org, ->(org) { where(recipient_organization_id: org) }
  scope :from_org, ->(org) { where(sender_organization_id: org) }

  amoeba do
    enable
  end

  def self.serial_number_for(document)
    "Д-#{document.sn}"
  end

  # title and unique-number together
  def unique_title
    "#{self.class.serial_number_for(self)} — #{title}"
  end

  # Stub out all missing methods
  def date
    approved_at
  end

  # TODO-prikha: stub out user_id to replace it properly
  def user_id
    User.first.id
  end

  # Возвращает список пользователей, согласовавших/не согласовавших документ
  # @example
  #   doc.conformed_users
  def conformed_users
    conformations.map(&:user)
  end

  # Возвращает true если все пользователи согласовали документ
  # @example
  #   doc.approvable?
  def approvable?
    (conformers.count == conformations.count) && conformations.pluck(:conformed).all?
  end

  def to_s
    "#{id}"
  end

  #  обнуляем все согласования
  def clear_conformations
    conformations.destroy_all
  end

  def pdf_link
    "/system/documents/document_#{id}.pdf"
  end

  def receivers
    recipient_organization.present? ? recipient_organization.users : []
  end
  
  # Generate the sequence no if not already provided.
  before_validation(:on => :create) do
    self.serial_number = next_seq unless attribute_present?("serial_number")
  end

  private
  
  def next_seq(column = 'serial_number')
    result = Documents::Document.connection.execute("SELECT nextval('documents_serial_number_seq')")

    result[0]['nextval']
  end

  def can_have_many_recipients?
    accountable_type == 'Documents::OfficialMail'
  end

  # TODO: remove this nightmare
  def create_png
    path = "public/#{pdf_link}"

    pdf = DocumentPdf.new(self, 'show')
    pdf.render_file path
    pdf = Magick::Image.read(path).first
    thumb = pdf.scale(400, 520)

    Dir.mkdir(path) unless File.exist?(path)
    thumb.write "public/system/documents/document_#{id}.png"
  end
end
