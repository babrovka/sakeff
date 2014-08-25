# Closes unit form after action
# @note Shared code for create/update bubbles actions
console.log "resetted form"

formContainer = $(".js-bubble-form")
formContainer.modal("hide")
formContainer.find("form")[0].reset()
formContainer.find("select").select2('val', "")