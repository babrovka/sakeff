R = React.DOM

#
# @note is created in BubblesInfoController
# Dialogues view which renders dialogues
# @note is created in DialoguesController
# @param componentDidMountCallback [Function] what will call after view render
@.app.FavouritesView = React.createClass
  getInitialState: ->
    {
      unitsData: []
    }


  render: ->
#    console.log "@.state.unitsData"
#    console.log @.state.unitsData
#    favouriteUnits = _.where(@.state.unitsData, {is_favourite: true})
    favouriteUnits = @.state.unitsData
    if favouriteUnits.length
      FavSelect(favouriteUnits)
    else
      R.h2(
        {},
        "Здесь будет показаны избранные объекты"
      )


  #
  UnitOption = React.createClass
    render: ->
      console.log @.props
      R.option(
        {
          value: @.props.id
        },
        @.props.text
      )


  #
  # TODO: look at bubble creation form
  FavSelect = React.createClass
    render: ->
      select_options = _.map(@.props.unitsData, (unit) ->
        UnitOption(unit)
      )
      R.select(
        {},
        {select_options}
      )
