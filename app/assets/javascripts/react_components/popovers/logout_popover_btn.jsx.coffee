`/** @jsx React.DOM */`

R = React.DOM

@LogoutPopoverBtn = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''


  render : ->
    @.renderPopover(@.props.body)
