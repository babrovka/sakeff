R = React.DOM

# Renders bubbles info block
# @note is created in BubblesInfoController
# Dialogues view which renders dialogues
# @note is created in DialoguesController
# @param componentDidMountCallback [Function] what will call after view render
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
    render_char: ->
      lBlue = undefined
      lGreen = undefined
      lRed = undefined
      p180 = undefined
      p270 = undefined
      p360 = undefined
      p90 = undefined
      start = undefined
      sum = undefined

      accidentsAmount = 0 + parseInt @.props.allBubbles[0]
      workAmount = 0 + parseInt @.props.allBubbles[1]
      infoAmount = 0 + parseInt @.props.allBubbles[2]

      sum = accidentsAmount + workAmount + infoAmount
      lRed = accidentsAmount / sum * 360
      lBlue = workAmount / sum * 360
      lGreen = 360 - lRed - lBlue
      start = parseInt(225)
      p90 = parseInt(90)
      p180 = parseInt(180)
      p270 = parseInt(270)
      p360 = parseInt(360)
      if ((lRed <= p90) and (lBlue <= p90) and (lGreen >= p180)) or ((lRed <= p90) and (lBlue <= p90) and (lGreen <= p180))
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed) + "deg" +')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed <= p90) and (lBlue <= p180) and (lGreen >= p90)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 90) + "deg" +')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed <= p90) and (lBlue <= p270) and (lGreen < p180)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')', zIndex: '6')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 90) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 180) + "deg" +')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed <= p90) and ((lBlue > p270) || (lBlue < p360)) and (lGreen < p90)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')', zIndex: '6')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 90) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 180) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate('+ parseInt(start + lRed + 270) + "deg" +')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (((lRed <= p180) and (lBlue <= p90) and (lGreen > p90)) || ((lRed == p180) and (lBlue == p90) and (lGreen == p90)))
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if ((lRed <= p180) and (lBlue <= p180) and (lGreen <= p90)) or (Math.round(lRed) is Math.round(lBlue) is Math.round(lGreen)) or (((Math.round(lRed) is Math.round(lGreen)) && (p90 < lRed <= p180)))
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed + 90) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if ((lRed <= p270) and (lBlue <= p90) and (lGreen < p90)) or (lRed <= p270) and (lBlue < p90) and (lGreen <= p180)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed <= p270) and (lBlue <= p180) and (lGreen < p90)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed + 90) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed > p270) and (lBlue < p90) and (lGreen < p90)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '5')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(495deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')')})
        ]
      else if (lRed == p360)
        [
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(495deg)')}),
        ]
      else if (lBlue == p360)
        [
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(225deg)')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(495deg)')}),
        ]
      else if (lGreen == p360)
        [

        ]
      else if (lRed <= p360) and (lBlue < p90) and (lGreen < p90)
        [
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate(0deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(225deg)', zIndex: '7')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(315deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(405deg)')}),
          R.div({className: "_round-diagram__segment m-red", style: (transform: 'rotate(495deg)')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-blue", style: (transform: 'rotate(' + parseInt(start + lRed) + "deg" + ')', zIndex: '6')}),
          R.div({className: "_round-diagram__segment__border", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue - 224) + "deg" +')')}),
          R.div({className: "_round-diagram__segment m-green", style: (transform: 'rotate('+ parseInt(start + lRed + lBlue) + "deg" +')', zIndex: '7')})
        ]


    render: ->
      totalAmount = @.props.allBubbles.reduce (a, b) ->
        a + b

      totalText = window.app.Pluralizer.pluralizeString(totalAmount, "событие","события","событий")
      R.div({className: "_round-diagram"},
        [
          R.div({className: "_round-diagram__main"}, @render_char()),
          R.div({className: "_round-diagram__white-bg"},
            [
              R.div(
                {className: "_bubbles__circle"},
                [
                  R.div(
                    {className: "_bubbles__circle__amount__number"},
                    "#{totalAmount}"
                  )
                  R.div(
                    {className: "_bubbles__circle__amount__text"},
                    "#{totalText}"
                  )
                ]
              )
            ]
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
              R.div(
                {className: "_bubbles__badge__circle"},
                [
                  R.div(
                    {className: "_bubbles__badge__amount__number"},
                    "#{accidentsAmount}"
                  )
                ]
              )
              R.div(
                {className: "_bubbles__badge__amount__text"},
                "#{accidentText}"
              )
            ]
          ),
          R.div(
            {className: "_bubbles__badge _bubbles__badge--work"},
            [
              R.div(
                {className: "_bubbles__badge__circle"},
                [
                  R.div(
                    {className: "_bubbles__badge__amount__number"},
                    "#{workAmount}"
                  )
                ]
              )
              R.div(
                {className: "_bubbles__badge__amount__text"},
                "#{workText}"
              )
            ]
          ),
          R.div(
            {className: "_bubbles__badge _bubbles__badge--info"},
            [
              R.div(
                {className: "_bubbles__badge__circle"},
                [
                  R.div(
                    {className: "_bubbles__badge__amount__number"},
                    "#{infoAmount}"
                  )
                ]
              )
              R.div(
                {className: "_bubbles__badge__amount__text"},
                "#{infoText}"
              )
            ]
          )
        ]
      )
