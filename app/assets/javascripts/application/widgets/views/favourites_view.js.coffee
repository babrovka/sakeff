R = React.DOM

#
# @note is created in BubblesInfoController
# Dialogues view which renders dialogues
# @note is created in DialoguesController
# @param componentDidMountCallback [Function] what will call after view render
@.app.widgets.FavouritesView = React.createClass
  getInitialState: ->
    {
      unitsData: []
    }


  render: ->
#    console.log "@.state.unitsData"
#    console.log @.state.unitsData
    favouriteUnits = _.where(@.state.unitsData, {is_favourite: true})
#    favouriteUnits = @.state.unitsData
    if favouriteUnits.length
      FavSelect(unitsData: favouriteUnits)
    else
      R.h2(
        {},
        "Здесь будет показаны избранные объекты"
      )


  #
  UnitOption = React.createClass
    render: ->
      R.option(
        {
          value: @.props.id
        },
        @.props.text
      )


  #
  FavSelect = React.createClass
    PLACEHOLDER_VALUE: "Выберите объект"

    #
    selectUnitOnTv: (e) ->
      unit_id = e.target.value
      unless unit_id == @PLACEHOLDER_VALUE
        PubSub.publish('unit.select', unit_id)

    render: ->
#      console.log "@.props.unitsData"
#      console.log @.props.unitsData
      select_options = _.map(@.props.unitsData, (unit) ->
        UnitOption(unit)
      )
      R.select(
        {
          name: "favourite_unit_id",
          onChange: @selectUnitOnTv
        },
        R.option(
          {
            selected: "selected"
          },
          @PLACEHOLDER_VALUE
        )
        {select_options}
      )

