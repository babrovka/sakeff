R = React.DOM

# Displays an interactive car number
# @note is used in CarNumberController
@.app.CarNumberView = React.createClass
  getInitialState: ->
    number: ""
    region: ""


  render: ->
    CarNumber(
      number: @.state.number
      region: @.state.region
    )


  # Car number itself
  # @note is rendered in CarNumberView
  # @note is updated in CarNumberController._bindInputs
  # @param number [String]
  # @param region [String]
  CarNumber = React.createClass
    getDefaultProps: ->
      number : ""
      region : ""

    render: ->
      R.div(
        {},
        [
          R.div(
            {className: "_car-number__left"},
            R.span(
              {className : "text"},
              @.props.number
            )
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
