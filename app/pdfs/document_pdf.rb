# coding: utf-8
# Need to install ImageMagick and Ghostscript
class DocumentPdf < Prawn::Document
  include ActionView::Helpers::SanitizeHelper

  def remove_html(string)
    sanitize(string, :tags => {}).gsub(/&quot;/i,"").gsub(/&nbsp;/i,"") # empty tags hash tells it to allow no tags
  end
  
  def initialize(document, view)
    super(top_margin: 30)
    @document = document
    @organization = @document.sender_organization
    
    @sender = User.find(@document.user_id)
    
    @view = view
    russian_font
    logo
    move_down 60
    text "#{@organization.title}", :align => :right, :size => 15
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "<color rgb='989898'>В #{@document.recipient_organization.try(:title)}", :align => :right, :size => 10, :inline_format => true
    move_down 30

    case @document.accountable_type.to_s
      when 'Documents::OfficialMail' then text( "Письмо", :align => :center, :size => 20)
      when 'Documents::Order' then text( "Предписание", :align => :center, :size => 20)
      when 'Documents::Report' then text( "Акт", :align => :center, :size => 20)
    end

    move_down 10
    float {text "<color rgb='989898'>Номер документа: #{@document.serial_number}</color>", :size => 10, :inline_format => true}
    text "<color rgb='989898'>г. Санкт-Петербург</color>", :align => :right, :size => 10, :inline_format => true
    # TODO: @justvitalius код ниже вызывает ошибку.
    if @document.date
      text "<color rgb='989898'>От #{@document.date.strftime('%d.%m.%Y')}</color>", :size => 10, :inline_format => true
    end
    move_down 30
    text "#{remove_html(@document.body)}", :size => 10, :inline_format => true, :indent_paragraphs => 60, :align => :justify
    move_down 30
    writ_tasks
    move_down 60
    float {text "Генеральный директор", :size => 10, :inline_format => true}
    move_down 10
    text "#{@organization.title}", :size => 10
    move_down 20
    if @document.executor_id
      @executor = User.find(@document.executor_id)
      text "<color rgb='989898'>Исп: #{@executor.last_name_with_initials}", :size => 10, :inline_format => true
    end
  end
  
  def writ_tasks
    if @document.accountable_type == 'Documents::Order'
      order = @document.accountable
      if order.task_list.present? && order.tasks.present?
        order.tasks.each.with_index(1) do |task, i|
          text "#{i}) #{task.title}", :size => 10, :inline_format => true, :indent_paragraphs => 60
        end
      end
    end
  end
  
  def russian_font
    font_families.update(
      "Verdana" => {
        :bold => "#{Rails.root}/app/assets/fonts/verdanab.ttf",
        :italic => "#{Rails.root}/app/assets/fonts/verdanai.ttf",
        :normal  => "#{Rails.root}/app/assets/fonts/verdana.ttf" })
    font "Verdana"
  end
  
  def logo
    begin
      float {image "#{@organization.logo.path(:pdf) || ''}", :width => 123}
    rescue
      nil
    end
  end
end