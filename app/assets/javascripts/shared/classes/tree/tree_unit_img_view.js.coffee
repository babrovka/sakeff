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


  render : ->
    if @.state.imgUrl
      R.div({className: "#{EL_CLASS}__container"},
        R.img({ src: @.state.imgUrl })
      )

    else
      R.div({class: 'hidden'})
