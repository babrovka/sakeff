`/** @jsx React.DOM */`

R = React.DOM

@ReactPopoverComponent = React.createClass
  mixins: [PopoverMixin]

  getDefaultProps: ->
    body: ''


  render: ->
    @.renderPopover(@.props.body)
