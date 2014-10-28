class window.NotificationView
  params:
    module:
      tasks: '.js-sidebar-notification-tasks-module'


  constructor: (data) ->
    @.$sidebar_tasks_container = $(@.params.module.tasks)
    console.error 'not find sidebar container' unless @.$sidebar_tasks_container.length
    if data.hasOwnProperty('notifications')
      @.process_data(data.notifications)



  process_data: (notifications) ->
    if notifications.hasOwnProperty('tasks_module')
      @.render_notification(@.$sidebar_tasks_container, notifications.tasks_module)


  render_notification: ($elem, data) ->
    $elem.text(data).velocity('transition.bounceIn', {duration: 300})

