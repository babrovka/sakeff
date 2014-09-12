@.app.CurrentUser =
  hasPermission: (title) ->
    if gon.current_user_permissions.length == 0
      return false
    else
      permission = _.findWhere(gon.current_user_permissions, {title: title})
      if permission
        return permission.value
      else
        return false