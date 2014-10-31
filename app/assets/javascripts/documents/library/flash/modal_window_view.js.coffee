# Модальное окно
# варианты отрисовки/работы
# confirm - окно с двумя кнопками «согласен» и «отмена»

class window.app.ModalWindowView
  defaults:
    container: '.js-modal-window'
    txt_container: '.js-modal-window-txt'
    confirm_btn: '.js-modal-window-confirm-btn'
    cancel_btn: '.js-modal-window-cancel-btn'

    theme: 'warning'
    confirm_txt: 'да'

    css:
      active: 'm-show'

    is_debug: false

  constructor: (params) ->
    @.d = new ConsoleDebug @.defaults.is_debug
    @.d.init(@.$container = $(@.defaults.container))
    @.d.init(@.$txt_container = $(@.defaults.txt_container))
    @.d.init(@.$confirm_btn = $(@.defaults.confirm_btn))

    @.$container.on('click', @defaults.cancel_btn, => @.cancel_confirm())

    @.keypress_listener = new window.keypress.Listener()
    @.keypress_listener.simple_combo("esc", => @.cancel_confirm())

    @.apply_params(params)

  # применяем внешние параметры инициализации
  # применение происходит путем замещения дефолтных параметров пришедшими
  apply_params: (params) ->
    @.defaults.confirm_txt = @.$confirm_btn.text()
    @.defaults = _.defaults(params, @.defaults, params)

  # показываем модальное окно
  show_modal: ->
    @.$container.addClass(@.defaults.css.active)

  # выход из модального окна
  cancel_confirm: ->
    @.$container.removeClass(@.defaults.css.active)
    @.destroy

  # обработчик для окна confirm,
  # где есть две кнопки «подтвердить» и «отменить»
  # после нажатия на «подтвердить» исполняем callback переданный в метод
  confirm: (message, callback) ->
    if message
      @.set_theme()
      @.show_modal()
      @.$txt_container.html(message)
      @.$container.one('click', @.defaults.confirm_btn, ->
        callback()
      )

  # применяем тему
  # в тему входят все параметры, которые влияют на кастомизацию модальных окон
  # это и ЦВЕТ и ТЕКСТ кнопки «подтвердить»
  set_theme: ->
    @.$confirm_btn.text(@.defaults.confirm_txt)
    @.$container.removeClass('m-warning m-danger m-info').addClass("m-#{@.defaults.theme}")

  # удаление всего класса
  # безопасное очищение и обнуление всех событий
  destroy: ->
    @.$container.off('click', @.defaults.confirm_btn)
    @.$container.off('click', @.defaults.cancel_btn)
    @.keypress_listener.stop_listening()
    @.keypress_listener.unregister_combo('esc')
    delete @
