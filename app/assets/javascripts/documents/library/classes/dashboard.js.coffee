# constant and variables

url =
  meteo:
    spb: 'http://api.openweathermap.org/data/2.5/weather?id=498817&mode=json&units=metric'
    krn: 'http://api.openweathermap.org/data/2.5/weather?id=540771&mode=json&units=metric'
  positions: '/dashboard.json'
  save: '/save_desktop_configuration'

default_widgets= [
  {"col":1,"row":1,"size_x":1,"size_y":1,"name":"Документы","class":"widget-docs","href":"/documents"},
  {"col":2,"row":1,"size_x":1,"size_y":1,"name":"Пропуска","class":"widget-admission","href":"/permits"},
  {"col":3,"row":1,"size_x":1,"size_y":1,"name":"Организации и сотрудники","class":"widget-org","href":"/organizations"},
#  {"col":5,"row":2,"size_x":2,"size_y":2,"name":"Погода","class":"widget-weather","meteo":"",'href':'/meteo'},
  {"col":1,"row":3,"size_x":1,"size_y":1,"name":"Задачи","class":"widget-tasks","href":"/tasks"},

#  {"col":4,"row":1,"size_x":1,"size_y":1,"name":"Библиотека","class":"widget-library m-demo", 'href': '/drive'},
#  {"col":5,"row":1,"size_x":1,"size_y":1,"name":"Охрана","class":"widget-security m-demo", 'href': '/guard'},
#  {"col":4,"row":3,"size_x":1,"size_y":1,"name":"Профиль","class":"widget-profile m-demo",'href':'/profile'},
#  {"col":1,"row":2,"size_x":1,"size_y":1,"name":"Чат","class":" widget-chat m-demo", 'href': '/im'},
#  {"col":2,"row":3,"size_x":1,"size_y":1,"name":"Объекты","class":"widget-obj m-demo", 'href': '/objects'},
#  {"col":3,"row":3,"size_x":1,"size_y":1,"name":"Диспетчер","class":"widget-disp m-demo", 'href': '/dispatcher'},
#  {"col":2,"row":2,"size_x":1,"size_y":1,"name":"Склад","class":"widget-store m-demo", 'href': '/storehouse'},
#  {"col":3,"row":2,"size_x":1,"size_y":1,"name":"ТО и ТР","class":"widget-main m-demo", 'href': '/maintenance'},
#  {"col":4,"row":2,"size_x":1,"size_y":1,"name":"Маневры","class":"widget-maneuv m-demo ", 'href': '/maneuvers'},
#  {"col":6,"row":1,"size_x":1,"size_y":1,"name":"Настройка","class":"widget-setting m-demo", 'href': '/settings'},
#  {"col":1,"row":4,"size_x":1,"size_y":1,"name":"Обучение","class":"widget-educ m-demo", 'href': '/education'},
#  {"col":2,"row":4,"size_x":1,"size_y":1,"name":"Администрирование","class":"widget-admin m-demo", 'href':'/administration'},
#  {"col":3,"row":4,"size_x":1,"size_y":1,"name":"Трафик через С-1","class":"widget-traffic m-demo", 'href':'/important_traffic'},
#  {"col":4,"row":4,"size_x":1,"size_y":1,"name":"Новости","class":"widget-news m-demo ",'href':'/news'},

]
template =
  widget: "<li class='{{class}} widget'>{{#href}}<a href='{{href}}'>{{/href}}<span class='widget-name'>{{name}}</span>{{#href}}</a>{{/href}}</li>"
# functions

window.widgets = {                  # This object contains references to widgets
}


sendRequest = (url, type, protect, data) ->

  if protect
    $.ajaxSetup beforeSend: (xhr) ->
      xhr.setRequestHeader "X-CSRF-Token", $("meta[name=\"csrf-token\"]").attr("content") #settings?
      return

  _request = $.ajax(
    url: url
    type: type
    dataType: "json"
    data: (if type=='POST' then {'data': data} else '')
  )

  _request                       #TODO: done - need?

# Classes

class Dashboard
  settings:
    widget_margins: [10, 10]
    widget_base_dimensions: [140, 140]
    max_size_x: 6
    max_cols: 6
    min_cols: 6
    resize:
      enabled: true
    avoid_overlapped_widgets: true
    autogenerate_stylesheet: true
    widget_selector: 'li'

  constructor: (dom) ->
    this.body = dom.gridster(     #body == object gridster || widgets == grister.widgets
      this.settings
    ).data('gridster')
    this.loading()
    this.editoff()

    #this.datainit()

  save: =>
    newData = (this.body.serialize()) #JSON.stringify

    _.each default_widgets, (a) ->

    _.each newData, (widget, wKey) ->
      _.each widget, (prop, key) ->
        default_widgets[wKey][key] = prop

    sendRequest(url.save, 'POST', true, JSON.stringify(default_widgets))

    this.editoff()
    (callback = () ->
      $('.js-btns .btn').toggle()
    )()

  addwidget: (widget) ->

    html = Mustache.to_html(template.widget, widget)
    this.body.add_widget(html, widget.size_x,widget.size_y,widget.col,widget.row)

  get: (n) =>                   #n  - number dashboard
    $.when(sendRequest(url.positions, 'GET', true))#.then (data, textStatus) ->

  loading: =>
    that = this

    $.when(sendRequest(url.positions, 'GET', true)).done (data, textStatus) ->

      if data.desktop_conf is null
        a = default_widgets
      else
        a = data.desktop_conf
      _.each a, (widget)->
        that.addwidget(widget)
      _.each that.body.$widgets, (w) ->

        window.widgets[w.classList[0]] = w

      that.datainit()                                                   #callback for initialization -data function.

    (->
      $('.js-btns .js-dashboard-save').hide()                         #hide buttons
      $('.js-btns .js-dashboard-cancel').hide()
    )()
                  #TODO: weater disable

  datainit: =>
    datablock = $('.hidden-data-block')

    new_docs_badge = datablock.find('.data-new_docs')[0].innerHTML
    window.widgets['widget-docs'].innerHTML += new_docs_badge

  editon: =>

    this.body.enable()
    this.body.enable_resize()
    $('.widget a').on 'click', (e) ->
      e.preventDefault()
      #return false

    (callback = () ->
      $('.js-btns .btn').toggle()
    )()

    $('h1').html('Режим редактирования')
  editoff: =>

    this.body.disable() if $(".gridster > ul")
    this.body.disable_resize() if this.body.disable_resize()
    $('h1').html('Главный рабочий стол')


    $('.widget a').on 'click', (e) ->
      console.log(this.href)
      document.location = this.href
  cancel: =>

    this.editoff()
    (callback = () ->
      $('.js-btns .btn').toggle()
    )()



# start flow
$ ->

  if document.location.pathname == "/"
    dashboard = new Dashboard($(".gridster > ul"))

    $('.js-dashboard-edit').on 'click', dashboard.editon
    $('.js-dashboard-save').on 'click', dashboard.save
    $('.js-dashboard-cancel').on 'click', dashboard.cancel