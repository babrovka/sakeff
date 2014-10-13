# Wizard, прикрепляющий документы к документам
class DocumentAttacher
  DOCUMENT_TYPES = [Documents::OfficialMail, Documents::Order, Documents::Report]

  def initialize object, session, current_user
    # Принимаем либо Document, либо любые Accountable
    unless is_accountable?(object) || object.kind_of?(Document)
      raise ArgumentError, "Document should be one of #{DOCUMENT_TYPES}, received #{object.class} instead"
    end

    @organization = current_user.organization
    
    # Внутри себя работаем с объектом класса Document, что бы не получили
    @document = is_accountable?(object) ? object.document : object

    @session = session

    @session[:docs_to_attach] ||= []
    @session[:docs_to_attach][@document.id] ||= []
    @session[:docs_to_detach] ||= []
    @session[:docs_to_detach][@document.id] ||= []

    # IDs элементов на добавление или удаление
    @pending_attaches = session[:docs_to_attach][@document.id]
    @pending_detaches = session[:docs_to_detach][@document.id]

    @real_attached_documents = @document.attached_documents
  end

  def attach object
    # Принимаем либо Fixnum (document id), либо Document, либо любые Accountable
    if object && object.is_a?(Numeric)
      id = object
    elsif is_accountable?(object)
      id = object.document.id
    elsif object && object.kind_of?(Document)
      id = object.id
    else
      raise ArgumentError, "Document should be a number, or the one of the #{DOCUMENT_TYPES}, received #{object.class} instead"
    end

    cleanup # Чистим pending_attaches и pending_detaches от элементов, которые больше не могут быть прикреплены/откреплены

    raise RuntimeError, "Can't attach document with id ##{id}" unless can_attach? id 

    # Если документ есть в списке на удаление - удаляем оттуда
    if @pending_detaches.include? id
      @pending_detaches.delete id
    else 
      # Иначе, добавляем нужный id в список на добавление, если уже не существует
      @pending_attaches << id unless @pending_attaches.include? id
    end
  end
    
  def detach object
    # Принимаем либо Fixnum (document id), либо Document, либо любые Accountable
    if object && object.is_a?(Numeric)
      id = object
    elsif is_accountable?(object)
      id = object.document.id
    elsif object && object.kind_of?(Document)
      id = object.id
    else
      raise ArgumentError, "Document should be a number, or the one of the #{DOCUMENT_TYPES}, received #{object.class} instead"
    end

    cleanup # Чистим pending_attaches и pending_detaches от элементов, которые больше не могут быть прикреплены/откреплены

    raise RuntimeError, "Can't detach document with id ##{id}" unless can_detach? id
    
    attached_documents = @document.attached_documents
    attached_ids = attached_documents.map{|i| i.id.to_i}

    if attached_ids.include? id
      # Если документ по-настоящему приложен - то нужно добавить в список на удаление
      @pending_detaches << id
    elsif @pending_attaches.include? id
      # Если же не приложен, но есть в списке на добавление - удаляем из этого списка  
      @pending_attaches.delete(id)
    end
    
    # Если нет ни там, ни там, нам пришел неверный id - ничего не делаем
  end

  # Возвращает документы, доступные для аттача на текущем этапе (для пользователя)
  # TODO: @predetective Refactor to re-use attached_documents() method
  def attachable_documents
    cleanup # Чистим pending_attaches и pending_detaches от элементов, которые больше не могут быть прикреплены/откреплены

    # Составляем список документов, которые будут показы пользователю как доступные для прикрепления, это:
    # - по-настоящему прикрепленные документы, если их нет в списке на удаление
    # - документы в списке на добавление
    # - сам документ
    excluded_ids = []
    excluded_ids.concat @real_attached_documents.map {|ad| ad.id unless @pending_detaches.include?(ad.id) }.compact
    excluded_ids.concat @pending_attaches
    excluded_ids << @document.id
    
    # Выбираем из видимых документов для организации, исключая ненужные id
    attachable_documents = Document.visible_for(@organization)
                              .not_draft
                              .where('id not in (?)', excluded_ids)
  end

  # Возвращает список уже прикрепленных документов на текущем этапе (для пользователя)
  #  - по-настоящему прикрепленные (в БД) документы, если их нет в списке на удаление
  #  - документы в списке на добавление
  def attached_documents
    cleanup # Чистим pending_attaches и pending_detaches от элементов, которые больше не могут быть прикреплены/откреплены
    
    attached_documents = @real_attached_documents.to_a.map {|ad| ad unless @pending_detaches.include?(ad.id) }.compact
    attached_documents.concat Document.where('id in (?)', @pending_attaches )
  end

  # Актуализирует данные 
  def confirm
    # Проверяем, есть ли в pending_attaches или pending_detaches элементы, с которыми нельзя сделать требуемую операцию
    # Если есть - сразу очищаем
    raise RuntimeError, "Some of the docs can't be attached ot detached" unless cleanup

    @document.attached_documents.delete(Document.where('id in (?)', @pending_detaches))
    @document.attached_documents.concat(Document.where('id in (?)', @pending_attaches))
  end

  # Сбрасывает данные
  def clear
    @pending_attaches.clear
    @pending_detaches.clear
  end

private
  # @prdetective TODO: move to helper or smth?
  def is_accountable? obj
    !!DOCUMENT_TYPES.map {|type| obj.kind_of? type}.index(true)
  end

  # Приаттачить документ можно, если он существует и не черновик
  def can_attach? id
    return false unless Document.exists?(id)
    
    # Также нужно ограничить прикрепление документов только видимыми из текущей организации,
    # Пока отключено, т.к. тесты не заточены под это
    # return false unless Document.visible_for(@organization).map {|d| d.id}.include? id
    doc = Document.find(id)
    doc.state != 'draft'
  end

  # Отвязать можно любой существующий документ, если он приаттачен по-настоящему
  def can_detach? id
    return false unless Document.exists?(id)
    doc = Document.find(id)

    @document.attached_documents.include? doc
  end

  
  # Проходим по массивам @pending_attaches и @pending_detaches и убеждаемся,
  # что каждый из элементов по прежнему пригоден для прикрепления/открепления
  #
  # Возвращает true, если после проверки чистка не потребовалась
  # Возвращает false, если какие-то элементы пришлось почистить
  def cleanup
    cant_attach = []
    cant_detach = []

    @pending_attaches.each do |attach_id|
      unless can_attach?(attach_id) 
        @pending_attaches.delete(attach_id)
        cant_attach << attach_id
      end
    end

    @pending_detaches.each do |detach_id|
      unless can_detach?(detach_id) 
        @pending_detaches.delete(detach_id)
        cant_detach << detach_id
      end
    end

    cant_attach.empty? && cant_detach.empty? 
  end
end