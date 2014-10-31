R = React.DOM

# Popover for permits print
# @note is used on permits index
@PermitPrintPopover = React.createClass
  mixins : [PopoverMixin]

  getDefaultProps : ->
    body : ''


  render : ->
    @.renderPopoverHtml(@.props.body)