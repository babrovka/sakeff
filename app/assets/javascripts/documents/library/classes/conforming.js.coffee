# класс для работы согласований документов
# ограничения
# — на странице только одно голосование (для данного человека)
#
# сценарии
# — вначале видим кнопку без голосования
# — если нажали голосовать, то показываем попап для ввода мнения (меняем заголовки там)
# — если в попапе нажали «отмена», то сбрасываем мнение в нейтральное
# — после подтверждения попапа не даем голосовать
# — после успешного голосования показываем текст в общем списке

class window.ConformingView
  params:
   agree_btn: '.js-document-conform-agree-btn'
   deny_btn: '.js-document-conform-deny-btn'
   conformation_alert: '.js-document-conform-alert'
   conformation_form: '.js-document-conform-modal-form'
   conform_type: '.js-document-conform-type'
   conform_txt: '.js-document-conform-txt'
   conformations: '.js-document-conform-list'

   debug: '.js-document-debug'
   is_debug: false

  constructor: ->
    @.$debug = $(@.params.debug)
    @.send_without_validate = false # переменная для определения,можем ли мы без валидации отправить форму на сервер

    @.init(@.$agree_btn = $(@.params.agree_btn))
    @.init(@.$deny_btn = $(@.params.deny_btn))
    @.init(@.$conformation_alert = $(@.params.conformation_alert))
    @.init(@.$conformation_form = $(@.params.conformation_form))
    @.init(@.$conformation_form_submit = $(@.params.conformation_form).find('input[type=submit]'))
    @.init(@.$conformation_form_title = $(@.params.conformation_form).find('h4'))
    @.init(@.$conform_type = $(@.params.conform_type))
    @.init(@.$conform_txt = $(@.params.conform_txt))
    @.init(@.$conformations = $(@.params.conformations))


    @.$agree_btn.on('click', (e) => @.agree() )

    @.$deny_btn.on('click', (e) => @.deny() )

    # обрабатываем ввод букв в окне с комментарием
    @.$conform_txt.on('keyup', (e) =>
      clearTimeout(@.timer_id)
      @.timer_id = setTimeout( =>
        if @.can_send_form()
          @.debug 'can send conform set to TRUE'
          @.$conformation_form_submit.prop('disabled', '')
        clearTimeout(@.timer_id)
      , 300)
    )

    # глобальная переменная для данного голосования,чтобы обработать jquery-ujs ответы
    window.conformation = @

    @.init_ajax_create_conform()
    @.debug 'conforming view created'

  # пишем в результат инициализаций
  init: (obj) ->
    if @.params.is_debug
      if obj.length
        str = "<p class='text-success'>#{obj.selector} init</p>"
      else
        str = "<p class='text-danger'>#{obj.selector} non init</p>"
      @.$debug.html(@.$debug.html() + str)

  # пишем в дебаг
  debug: (str) ->
    @.$debug.html(@.$debug.html() + "<p>#{str}</p>") if @.params.is_debug


  # обработка клика по кнопке «согласен»
  agree: () ->
    @.debug 'agree clicked'
    @.$conform_type.val(true)
    @.send_without_validate = true
    @.$conformation_form.slideDown(300)
    @.$conformation_form_submit.prop('disabled', '')
    @.$conformation_form_title.text('Добавьте комментарий (необязательно)')


  # обработка клика по кнопке «не очень согласен»
  deny: () ->
    @.debug 'deny clicked'
    @.$conform_type.val(false)
    @.$conformation_form.slideDown(300)
    @.$conformation_form_title.text('Добавьте комментарий (обязательно)')
    # если комментарий пустой,то дизэйблим кнопку сабмита формы
    unless @.can_send_form()
      @.$conformation_form_submit.prop('disabled', 'disabled')


  # вешаем событие и прерывание отправки формы на сервер с вариантом голосования
  init_ajax_create_conform: ->
    @.debug 'ajax conform inited'
    @.$conformation_form.on('ajax:before', =>
      @.debug 'before ajax send form'
      # проверяем нужен ли комментарий
      if @.can_send_form() || @.send_without_validate
        @.debug 'can send conform'
        return true
      else
        @.debug 'can not send conform'
        return false
    )


  # что делаем в случае успешного ответа от сервера
  # данный метод вызывается из js-файла в ответе от сервера через ujs.
  success_ajax_send: ->
    @.$conformation_form.slideUp(100).find('input').val('');
    @.$conformation_alert.hide()
    @.$agree_btn.prop('disabled', 'disabled')
    @.$deny_btn.prop('disabled', 'disabled')


  # вставляем комментарий в общий список комментариев
  append_conformations: (html) ->
    @.$conformations.html(html)

  # проверяет можно ли отправить форму.
  # возвращаем false если комментарий пустой
  # возвращаем true если есть хотя бы 1 символ в комментарии
  can_send_form: ->
    @.$conform_txt.val().length*true






