$ ->
  window.app.tasks =
    order_tasks_list:
      form: '.js-tasks-order-task-form'
      task: '.js-task'
    order_tasks_form:
      container: '.js-tasks-main-form'
      add_task_btn: '.js-tasks-add-task'

    task:
      container: '.js-task-container'
      remove_btn: '.js-task-remove'
      inputs_container: '.js-task-form-fields'
      html_container: '.js-task-form-inserted-values'

    create_modal:
      elem: '.js-tasks-add-modal'
      form_container: '.js-tasks-modal-form'
      cancel: '.js-tasks-modal-cancel-btn'
      submit: '.js-tasks-modal-save-btn'

    add_task_btn: '.js-tasks-add-task'
    task_remove_btn: '.js-task-remove'
    main_form_container: '.js-tasks-main-form'
    add_task_modal: '.js-tasks-add-modal'
    modal_task_container: '.js-tasks-modal-form'
    modal_cancel_btn: '.js-tasks-modal-cancel-btn'
    modal_add_new_btn: '.js-tasks-modal-add-new-task-btn'
    modal_save_btn: '.js-tasks-modal-save-btn'
    task_form:
      task_container: '.js-task-container'
      inputs_container: '.js-task-form-fields'
      html_container: '.js-task-form-inserted-values'



  T = app.tasks
  T.create_modal.$elem = $(T.create_modal.elem)
  T.create_modal.$form_container = $(T.create_modal.form_container)

  T.order_tasks_form.$container = $(T.order_tasks_form.container)

  T.$add_task_modal =  $(T.add_task_modal)
  T.$add_task_modal_task_container = T.$add_task_modal.find(T.modal_task_container)
  T.$main_form_container =  $(T.main_form_container)




  # hide all inputs by on after page loaded
  $(T.main_form_container).find('input, textarea, select').closest('.form-group').hide()


  # datepicket minData assigned

  if $('#new_documents_order').length

    target = $('.js-datepicker.js-deadline')

    d = new Date( JSON.parse(target[0].dataset.minDate) )

    leadZero = (number) ->
      length = 2
      number = "0" + number  while number.toString().length < length
      number

    day = leadZero (d.getDate())
    month = leadZero (d.getMonth()+1)
    year = d.getFullYear()
    opts = _.extend(global.datepicker, minDate: (day+'.'+month+'.'+year) )

    target.datepicker( "destroy" );

    target.datepicker opts


  #  $(document).on('click', '.js-datepicker.js-deadline', (e) ->
  #    console.log $(e.target)
  #    $(e.target).datepicker(opts)
  #  )
  # создание новой таски в модальном окне
  # при открытии модального окна, клонируем в него заготовку под форму.
  # и в этой заготовке управляем видимостью элементов
  $(document).on('click', T.order_tasks_form.add_task_btn, (e) ->
    e.preventDefault()
    # replace '0' to 'now timestamp' in task-form
    time = new Date().getTime()
    regexp = new RegExp($(this).data('id'), 'g')

    html_source = $(@).data('fields').replace(regexp, time)

    # вставляем обработанную форму заготовку код в модальное окно
    T.create_modal.$form_container.html(html_source)

    # показываем форму, скрываем все остальное
    T.create_modal.$form_container.find(T.task.html_container).hide()

    #  set_task_deadline: -> Собирает даду дедлайна, передает в глобал для пикеров зависимых от дедлайна
    date = $('.js-datepicker.js-deadline').datepicker('getDate')
    console.log date
    opts = _.extend(global.datepicker, maxDate: date)


    T.create_modal.$form_container.find('.js-datepicker').datepicker(opts)

    #    T.create_modal.$form_container.find(max_date_for_new_datepickers)
    T.create_modal.$form_container.find(T.task.inputs_container).show()

    T.create_modal.$elem.modal('show')
  )

  # при клике на кнопку сабмита
  # клонируем заготовку формы в форму распоряжения
  # клонируем выбранные значения из формы модального окна
  # уничтожаем форму в модальном окне
  $(document).on('click', T.modal_save_btn, (e) ->
    e.preventDefault()

    # клонируем форму заготовку в форму распоряжения
    task_form = T.create_modal.$form_container.html()
    T.order_tasks_form.$container.append(task_form)

    #    # клонируем все введенные значения в новую форму
    _$inputs = T.create_modal.$form_container.find('input, textarea, select')
    _.each(_$inputs, (input) ->
      $input = $(input)
      val = $input.val()
      id = $input.attr('id')

      # берем объект в форме документа, куда положить значение
      $target = T.order_tasks_form.$container.find("##{id}")
      $target.val(val)
      $target.attr('value', val)

      # переносим вбитые значения в поле отображения
      $target.closest(T.task.container).find(".#{$input.data('target')}").text(val)
    )

    # скрываем форму, показываем красивый html с задачей
    T.order_tasks_form.$container.find(T.task.html_container).show()
    T.order_tasks_form.$container.find(T.task.inputs_container).hide()

    T.$add_task_modal.modal('hide')
  )

  # удаляем задачу из формы документа
  $(document).on('click', T.task_remove_btn, (e) ->
    e.preventDefault()
    $(e.target).closest('.js-task-container').empty()
  )

  # скрываем модальное окно
  $(document).on('click', T.modal_cancel_btn, (e) ->
    e.preventDefault()
    $(T.add_task_modal).modal('hide')
  )

  # submit form on task checked over ajax
  $(document).on('ifChecked ifUnchecked', "#{T.order_tasks_list.form} input", (e) ->
    e.preventDefault()
    if e.type is 'ifChecked'
      $tasks = $(window.app.tasks.order_tasks_list.form + ' input[type=checkbox]')
      $completed_tasks = $(window.app.tasks.order_tasks_list.form + ' input[type=checkbox]:checked') #throw RuntimeException("exit")#('Ошибка!')
      if $tasks.length-$completed_tasks.length==0
        if confirm("Вы уверены? Отменить невозможно!")
          $(e.target).closest(window.app.tasks.order_tasks_list.task).addClass('m-task-completed')
          $form = $(e.target).closest(T.order_tasks_list.form)
          $form.submit()
        else
          location.reload()
      else
        $(e.target).closest(window.app.tasks.order_tasks_list.task).addClass('m-task-completed')
        $form = $(e.target).closest(T.order_tasks_list.form)
        $form.submit()
    else
      $(e.target).closest(window.app.tasks.order_tasks_list.task).removeClass('m-task-completed')
      $form = $(e.target).closest(T.order_tasks_list.form)
      $form.submit()
  )


