`/** @jsx React.DOM */`

R = React.DOM

@LibraryPpoverWithHtml = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''


  render : ->
    @.renderPopoverHtml(@.props.body)
