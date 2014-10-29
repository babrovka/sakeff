`/** @jsx React.DOM */`

R = React.DOM

@DocumentsStatePopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''


  render : ->
    @.renderPopoverHtml(@.props.body)