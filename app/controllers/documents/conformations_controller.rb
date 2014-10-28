class Documents::ConformationsController < Documents::ResourceController

  def create
    doc = get_document(params)
    if conformation_params
      if conformed?
        @conform = current_user.conform doc, comment: conformation_params[:comment]
      else
        @conform = current_user.deny doc, conformation_params[:comment]
      end
      # TODO-vladimir: как-то не красиво выглядит эта связь, надо уже и в контроллерах писать «релоад» согласований
      @conformations = doc.conformations.reload

      # Если все согласовали положительно
      if @conformations.where(conformed: true).count == doc.conformers.count
        begin
          # NotificationMailer.document_conformed(doc).deliver!
        rescue
          # Nothing
        end
        doc.reload.notify_interesants only: :approver, exclude: current_user
      end

      respond_to { |format| format.js { render layout: false } }
    end
  rescue Exception => e
    render json: e.message

  # данная строчка добавлена для тестирования работы фронтенда при многократном отсылании голосований
  #respond_to { |format| format.js { render layout: false } }
  end

  private

  def conformed?
    (conformation_params[:conformed] == 'true')? true : false
  end

  def conformation_params
    params.require(:documents_conformation).permit(:conformed, :comment)
  end

  def get_document(params)
    if (id = params[:official_mail_id])
      Documents::OfficialMail.find(id).document
    elsif (id = params[:report_id])
      Documents::Report.find(id).document
    elsif (id = params[:order_id])
      Documents::Order.find(id).document
    end
  end

end