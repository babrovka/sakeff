class Documents::ResourceController < BaseController
  inherit_resources

  helper_method :associations,
                :association_attributes,
                :attributes,
                :form_attributes,
                :sort_column,
                :sort_direction,
                :organizations,
                :current_organization_users,
                :current_organization,
                :documents_important,
                :pure_important

  respond_to :html, :js, :json
  has_scope :page, default: 1, only: [:index]

  private

  def sort_column
    column_names = resource_class.column_names
    column_names.include?(params[:sort]) ? params[:sort] : "updated_at"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

  def attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def form_attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

  def association_attributes
    associations(:belongs_to).map do |assoc|
      assoc.options[:foreign_key] || "#{assoc.name}_id"
    end
  end

  def associations(macro = nil)
    assoc = resource_class.reflect_on_all_associations
    assoc.select! { |a| a.macro == macro.to_sym } unless macro.blank?
    assoc
  end

  def organizations
    @all_organizations ||= Organization.order('short_title ASC')
  end

  def current_organization_users
    @current_organization_users ||=
        current_organization.users.order('first_name ASC')
  end

  def current_organization
    current_user.organization
  end

  def documents_important
    @documents_important ||= Documents::ImportantDecorator.new(pure_important)
  end

  def pure_important
    Documents::Document.with_notifications_for current_user
  end

  def notify
    resource.notify_interesants except: current_user
  end
end
