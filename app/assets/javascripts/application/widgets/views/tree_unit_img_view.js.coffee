`/** @jsx React.DOM */`

R = React.DOM

EL_CLASS = '_units-content-img'

# рисуем много циркулярных сообщений
@.app.TreeUnitImgView = React.createClass
  getInitialState : ->
    imgUrl: null

  componentDidMount : ->
    PubSub.subscribe('unit.select', @checkContentInUnit)


  # меняем стейт объкта при наличии адреса к плоской картинке
  # вызывается в тот момент, когда выделена нода
  # если у выделенного объекта есть тип контента plain
  # то меняем стейт,что приводит к отрисовке картинки
  checkContentInUnit: (channel, unitId) ->
    type = app.TreeInterface.getFileTypeByUnitId(unitId)
    if type == 'plain'
      imgUrl = app.TreeInterface.getModelURLByUnitId(unitId)
      @setState(imgUrl : imgUrl)
    else
      @setState(imgUrl: null)

  componentDidUpdate: ->
    $container = $(@.refs.container.getDOMNode())
    $container.css(height: $container.outerHeight())
    if @.state.imgUrl
      $container.parent().addClass('m-active')
    else
      $container.parent().removeClass('m-active')

  render : ->
    if @.state.imgUrl
      body = R.img({ src: @.state.imgUrl })
    else
      body = R.div({class: 'hidden'})

    R.div({className : "#{EL_CLASS}__container", ref : 'container'}, body)
