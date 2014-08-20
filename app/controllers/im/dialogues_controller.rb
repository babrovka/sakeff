class Im::DialoguesController < BaseController

  helper_method :collection, :d_collection

  def index
  end

  def show
  end

  private

  def collection
    @dialogues ||= Im::Dialogue.order('updated_at ASC')
  end

  def d_collection
    @d_dialogues ||= Im::DialoguesDecorator.decorate(collection)
  end


end