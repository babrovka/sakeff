# Resets form and bubbles container for updated unit

console.log "updated bubble"

eval "<%= j raw render partial: 'unit_bubbles/reset_form' %>"
eval "<%= j raw render partial: 'unit_bubbles/get_unit' %>"
eval "<%= j raw render partial: 'unit_bubbles/reset_bubbles_container' %>"