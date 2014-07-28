`/** @jsx React.DOM */`

###
  React Mixin для отрисовки popover окон

  интерфейс использования
    parent — класс родительского элемента, клики по которому активируют popover
    renderPopover(React.DOM) — метод для отрисовки popover с React.DOM объектом
    renderPopoverHtml(html) — метод для отрисовки popover с любым html контентом

###

R = React.DOM


@PopoverMixin =

  placement: null
  # API ZONE

  # обработка кликов снаружи всплывающего окна
  handleOutsideClick: (callback)->
    popover = @.refs.popover.getDOMNode()
    event = (e) =>
      el = $(e.target);
      unless el.closest(popover).length || el.closest(@.props.parent).length
        callback()
    document.body.addEventListener('click', event, false)


  # вешаем обработчики кликов на родителе или вне попапа
  popoverDidMount: ->
    $(document).on('click', @.props.parent, => @.handleParentClick() )
    @.handleOutsideClick(=> @.popoverHide())

  # убираем все ивенты при уничтожении компонента
  popoverDidUmnount: ->
    document.body.removeEventListener('click')

  # метод обрабатывающий клик по родительской кнопки для данного окна
  #
  # внутри также идет расчет местоположения текущего всплывающего окна,
  # т.к.возможно асинхронное поведение,
  # это когда всплывающее окно рисуется первее родительской кнопки
  handleParentClick: ->
    @._calculatePosition() if @.refs.hasOwnProperty('popover')
    @.setState opened: !@.state.opened


  # метод скрытия всплывающего окна
  popoverHide: (e=null)->
    e.preventDefault() if _.isObject(e)
    @.setState opened: false


  # переключаем состояние всплывающего окна
  popoverToggle: ->
    @.props.onPopoverToggle(@.state.opened)

  # рендерим попап и передаем готовый html внутрь
  renderPopoverHtml: (body) ->
    R.div({
      className: @._popoverClassName()
      ref: 'popover'
    },[
      R.span({className: 'arrow'}),
      R.span({className: 'popover-cancel-btn', onClick: @.popoverHide}),
      R.div({dangerouslySetInnerHTML: {__html: body}})
    ])

  # рендерим попап и передаем react-dom массив
  renderPopover: (body) ->
    R.div({
      className: @._popoverClassName()
      ref: 'popover'
    },[
      R.span({className: 'arrow'}),
      R.span({className : 'popover-cancel-btn', onClick : @.popoverHide}),
      R.div({},body)
    ])


  # ==================================================================================


  # DEFAULT ZONE

  # наклеиваем взаимодействие с пользователем, после того, как компонент отрисовался
  # в этот момент уже есть dom и к нему можно обращаться
  # тесты показали, что эти методы выполняются первее методов, вызванных из потомка, где подключается mixin
  componentDidMount: ->
    @.popoverDidMount()

  componenDidUnmount: ->
    @.popoverDidUmnount()

  # после перерисовки компонента отсылаем текущий статус всем компонентам,
  # которые подписаны на это свойство
  componentDidUpdate: ->
    @.popoverToggle()
    @._calculatePosition()
    @.popoverDidUpdate() if @.hasOwnProperty('popoverDidUpdate')

  getDefaultProps: ->
    parent: ''
    onPopoverToggle: ->

  getInitialState: ->
    opened: false

  propTypes:
    onPopoverToggle: React.PropTypes.func
    placement: React.PropTypes.string
    parent: React.PropTypes.string
    width: React.PropTypes.number

  # ==================================================================================


  # PRIVATE ZONE

  # возвращает css имя классов для контейнера всплывающего окна
  _popoverClassName: ->
    cx = React.addons.classSet
    className = cx(
      'm-active': @.state.opened == true
      'js-react-popover-component popover': true
    )

    className += " #{@.placement}"



  _calculatePosition: ->
#    parent =  @.props.parent
    if  @.props.target_position
      if $(@.props.target_position).is(':visible')
      then  parent = @.props.target_position
      else parent =  @.props.parent
    else
      parent =  @.props.parent
    $parent = $(parent)
    $popover = $(@.refs.popover.getDOMNode())

    setWidth = @.props.width || 500
    $popover.css({width: setWidth + 'px'})

    activeBtnHeight = $parent.outerHeight()
    activeBtnWidth = $parent.outerWidth()
    activeBtnOffset = $parent.offset()

    currentTop = activeBtnOffset.top
    currentLeft = activeBtnOffset.left

    popoverCloneOffset = $popover.offset()
    popoverHeight = $popover.outerHeight()
    popoverWidth = $popover.outerWidth()
    docHeight = $(document).outerHeight()
    docWidth = $(document).outerWidth()

    # Определение класса позиционирования при вертикальной композиции
    vert = 0.5 * docHeight - currentTop
    vertBalance = docHeight - currentTop
    vertPlacement = (if vert > 0 then "bottom" else  "top")

    # Определение класса позиционирования при горизонтальной композиции
    horiz = 0.5 * docWidth - currentLeft
    horizBalance = docWidth - currentLeft
    horizPlacement = (if horiz > 0 then "right" else "left")

    # Определение класса позиционирования при композиции "наискось"
    aslantPlacement = (
      if currentLeft > horizBalance and currentTop > vertBalance
        "top-left"
      else if currentLeft > horizBalance and currentTop < vertBalance
        "bottom-left"
      else if currentLeft < horizBalance and currentTop > vertBalance
        "top-right"
      else
        "bottom-right"
    )

    # Установка класса позиционирования в заисимости от композиции
    placement = (
      # Если popover выходит за рамки window
      if docHeight - (popoverCloneOffset.top + popoverHeight) < 0 || docHeight - (vertBalance + popoverHeight) < 0 || docWidth - (popoverCloneOffset.left + popoverWidth) < 0 || docWidth - (horizBalance + popoverWidth) < 0
        aslantPlacement
      else
        if Math.abs(horiz) > Math.abs(vert)
          horizPlacement
        else
          vertPlacement
    )

    #положение можно задать напрямую в placement = "right" например
    @.placement = @.props.placement || placement

    #arrow position formula
    popArrow = $popover.find('.arrow')
    balancePopoverWidth = popoverWidth - activeBtnWidth
    arrowPosRight = balancePopoverWidth + activeBtnWidth / 2
    arrowPosLeft = popoverWidth - balancePopoverWidth - activeBtnWidth / 2
    arrowWidth = popArrow.outerWidth()

    if $popover.hasClass('bottom')
      $popover.css
        top: currentTop + activeBtnHeight + "px"
        left: (currentLeft + activeBtnWidth / 2) - popoverWidth / 2 + "px"

    else if $popover.hasClass('top')
      $popover.css
        top: currentTop - activeBtnHeight / 2 - popoverHeight + "px"
        left: (currentLeft + activeBtnWidth / 2) - popoverWidth / 2 + "px"

    else if $popover.hasClass('right')
      $popover.css
        top: currentTop - popoverHeight / 2 + activeBtnHeight / 2 + "px"
        left: currentLeft + activeBtnWidth + activeBtnHeight / 2 + "px"

    else if $popover.hasClass('left')
      $popover.css
        top: currentTop - popoverHeight / 2 + activeBtnHeight / 2 + "px"
        left: currentLeft - popoverWidth - activeBtnHeight / 2 + "px"

    else if $popover.hasClass('bottom-left')
      $popover.css
        top: currentTop + activeBtnHeight + "px"
        left: (currentLeft - popoverWidth) + activeBtnWidth + "px"
      popArrow.css
        left: arrowPosRight + "px"

    else if $popover.hasClass('bottom-right')
      $popover.css
        top: currentTop + activeBtnHeight + "px"
        left: currentLeft + "px"
      popArrow.css
        left: arrowPosLeft + "px"

    else if $popover.hasClass('top-left')
      $popover.css
        top: currentTop - activeBtnHeight / 2 - popoverHeight + "px"
        left: (currentLeft - popoverWidth) + activeBtnWidth + "px"
      popArrow.css
        left: arrowPosRight + "px"

    else if $popover.hasClass('top-right')
      $popover.css
        top: currentTop - activeBtnHeight / 2 - popoverHeight + "px"
        left: currentLeft + "px"
      popArrow.css
        left: arrowPosLeft + "px"

    if arrowWidth > activeBtnWidth
      if $popover.is('.bottom-right, .top-right')
        $popover.css
          marginLeft: - arrowWidth/2 + "px"
        popArrow.css
          marginLeft: "0px"
      if $popover.is('.bottom-left, .top-left')
        $popover.css
          left: popoverCssLeft + arrowWidth + "px"

  # ==================================================================================

