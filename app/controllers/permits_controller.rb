# Contains methods for permits views rendering
class PermitsController < BaseController
  inherit_resources
  before_action :authenticate_user!
  
  before_action :check_edit_permission, only: [:edit, :update, :destroy]
  before_action :check_view_permission, only: [:index, :show]
  
  
  def destroy
    permit = Permit.where(id: params[:id]).first
    permit.expires_at = (Time.now - 1.day) 
    permit.save
    redirect_to root_path, alert: 'Пропуск успешно удален'
  end
  
  
  def check_edit_permission
    unless current_user.has_permission?(:edit_permits)
      redirect_to root_path, alert: 'У вас нет прав редактировать пропуска'
    end
  end
  
  def check_view_permission
    unless current_user.has_permission?(:view_permits)
      redirect_to root_path, alert: 'У вас нет прав просматривать пропуска'
    end
  end

  # Renders one time permission pdf
  def one_time
    data = {
      text: "Hello BITCHES"
    }

    # TODO: походу дела, view внутри документа не пашет. Придется иначе организовать рендер

    pdf = Prawn::Document.new(:page_size => "A4", :page_layout => :landscape) do
      formatted_text [{ :text => "xxx.org", :styles => [:bold], :size => 30 }]
      move_down 20
      text "Please proceed to the following web address:"
      move_down 20
      text "http://xxx.org/finder"
      move_down 20
      text "and enter this code:"
      move_down 20
      formatted_text [{ :text => token, :styles => [:bold], :size => 20 }]
    end.render

    send_data(pdf, :filename => "output.pdf", :type => "application/pdf")

    # @renderer = OneTimePDFRenderer.new(data)
    # render_pdf
  end

  def human
    data = {
      text: "Hello DICKHEADS"
    }

    @renderer = HumanPDFRenderer.new(data)
    render_pdf
  end

  def transport

  end


  private


  # Renders resulting pdf
  # @note is called in action methods
  def render_pdf
    send_data @renderer.render, @renderer.render_options
  end
  
end