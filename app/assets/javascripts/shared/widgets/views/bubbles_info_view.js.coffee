R = React.DOM

# Renders bubbles info block
# @note is created in BubblesInfoController
@.app.BubblesInfoView = React.createClass
  getInitialState: ->
    {
      bubblesData: []
    }


  render: ->
    if @.state.bubblesData.length
      BubblesContainer(bubblesData: @.state.bubblesData)
    else
      R.h2(
        {},
        "Здесь будут показаны бабблы..."
      )


  # Whole container
  # @note is rendered in render
  BubblesContainer = React.createClass
    render: ->
      rootId = window.app.TreeInterface.getRootUnitId()
      allBubbles = window.app.TreeInterface.getNumberOfAllBubblesForUnitAndDescendants(rootId)

      R.div(
        {},
        [
          BubblesTotal(allBubbles: allBubbles)
          BubblesCategories(allBubbles: allBubbles)
        ]
      )


  # Renders amount of all bubbles
  # @note is rendered in BubblesContainer
  # @param allBubbles [JSON]
  BubblesTotal = React.createClass
    render: ->
      totalAmount = @.props.allBubbles.reduce (a, b) ->
        a + b

      totalText = window.app.Pluralizer.pluralizeString(totalAmount, "событие","события","событий")
      R.div(
        {className: "_bubbles__circle"},
        [
          R.span(
            {className: "_bubbles__circle__amount"},
            "#{totalAmount} #{totalText}"
          )
        ]
      )


  # Renders amount of each bubble type
  # @note is rendered in BubblesContainer
  # @param allBubbles [JSON]
  BubblesCategories = React.createClass
    render: ->
      accidentsAmount = 0 + parseInt @.props.allBubbles[0]
      workAmount = 0 + parseInt @.props.allBubbles[1]
      infoAmount = 0 + parseInt @.props.allBubbles[2]

      accidentText = window.app.Pluralizer.pluralizeString(accidentsAmount, "авария","аварии","аварий")
      workText = window.app.Pluralizer.pluralizeString(workAmount, "работа","работы","работ")
      infoText = window.app.Pluralizer.pluralizeString(infoAmount, "информация","информации","информаций")

      R.div(
        {className: "_bubbles__badges-container"},
        [
          R.div(
            {className: "_bubbles__badge _bubbles__badge--accident"},
            [
              R.span(
                {className: "_bubbles__badge__amount"},
                "#{accidentsAmount} #{accidentText}"
              )
            ]
          ),
          R.div(
            {className: "_bubbles__badge _bubbles__badge--work"},
            [
              R.span(
                {className: "_bubbles__badge__amount"},
                "#{workAmount} #{workText}"
              )
            ]
          ),
          R.div(
            {className: "_bubbles__badge _bubbles__badge--info"},
            [
              R.span(
                {className: "_bubbles__badge__amount"},
                "#{infoAmount} #{infoText}"
              )
            ]
          )
        ]
      )
