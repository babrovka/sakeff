R = React.DOM

# Displays an interactive car number
# @note is used in CarNumberController
@.app.CarNumberView = React.createClass
  getInitialState: ->
    firstLetter: ""
    carNumbers: ""
    secondLetter: ""
    thirdLetter: ""
    region: ""


  render: ->
    CarNumber(
      firstLetter: @.state.firstLetter
      carNumbers: @.state.carNumbers
      secondLetter: @.state.secondLetter
      thirdLetter: @.state.thirdLetter
      region: @.state.region
    )


  # Car number itself
  # @note is rendered in CarNumberView
  # @note is updated in CarNumberController._bindInputs
  # @param number [String]
  # @param region [String]
  CarNumber = React.createClass
    getDefaultProps: ->
      firstLetter : ""
      carNumbers : ""
      secondLetter : ""
      thirdLetter : ""
      region : ""

    render: ->
      R.div(
        {},
        [
          R.div(
            {className: "_car-number__left"},
            [
              R.span(
                {className : "text"},
                @.props.firstLetter
              ),
              R.span(
                {className : "text"},
                @.props.carNumbers
              ),
              R.span(
                {className : "text"},
                @.props.secondLetter
              ),
              R.span(
                {className : "text"},
                @.props.thirdLetter
              ),
            ]
          ),
          R.div(
            {className : "_car-number__right"},
            R.span(
              {className : "text"},
              @.props.region
            )
          )
        ]
      )
