@.app.CurrentUser =
  hasPermission: (title) ->
    result = false
    if typeof gon != 'undefined'
      if gon.hasOwnProperty('current_user_permissions') && gon.current_user_permissions.length
        permission = _.findWhere(gon.current_user_permissions, {title: title})
        if permission
          result = permission.value
    return result