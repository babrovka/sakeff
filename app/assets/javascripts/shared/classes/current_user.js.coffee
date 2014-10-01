@.app.CurrentUser =

  id : ->
    unless gon? || gon.hasOwnProperty('current_user')
      throw new Error('необходима передача current_user.id в Gon')
    gon.current_user.id

  hasPermission: (title) ->
    result = false
    if gon?
      if gon.hasOwnProperty('current_user_permissions') && gon.current_user_permissions.length
        permission = _.findWhere(gon.current_user_permissions, {title: title})
        if permission
          result = permission.value
    result


