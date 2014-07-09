`/** @jsx React.DOM */`

###
menu_obj =
  [
    id: header_id
    title: header_text
    parent: parent_header_id
  ]


  Рендер подразумевает следующую структуру документа
  .js-library-row
    ... (some elements)
      .js-library-header TITLE
      .js-library-subheader TITLE
      ...
        .js-library-subheader TITLE
###
R = React.DOM

@LibrarySidebarMenu = React.createClass

  mixins: [React.addons.LinkedStateMixin]


  # выделяем два объекта menu_obj и menu_items
  # menu_obj хранит полное дерево меню, выступает в качестве кэша
  # menu_items — текущие пункты меню для отрисовки
  getInitialState: ->
    {
      menu_obj: {}
      menu_items: {}
      search_str: ''
    }

  build_menu_obj: ->
    # выбираем заголовки только те, что относятся к заголовкам разделам, но не примерам
    headers =  $('.js-library-header')
    subheaders = $('.js-library-subheader')
    # главные ноды в меню
    new_menu_obj = []
    _.each(headers,  (el) ->
      obj =
        id: el.id
        title: el.textContent
        parent_id: null

      new_menu_obj.push obj
    )

    _.each(subheaders, (el) ->
      obj =
        id: el.id
        title: el.textContent
        parent_id: $(el).closest('.js-library-row').find('.js-library-header')[0].id
      new_menu_obj.push obj
    )


    @.setState
      menu_obj: new_menu_obj
      menu_items: new_menu_obj


  # выстраиваем меню после монтирования компонента в проекте
  componentDidMount: ->
    @.build_menu_obj()


  # обрабатываем ввод символов в поисковый инпут
  # сортируем пункты меню,которые будем рендерить
  handleSearchStrChange: (new_str) ->
    new_menu_items = []
    @.state.menu_obj.forEach( (item) ->
      if item.title.toLowerCase().indexOf(new_str.toLowerCase()) > -1
        new_menu_items.push(item)
    )

    @.setState
      search_str: new_str
      menu_items: new_menu_items



  render: ->
    items = []

    if _.isArray(@.state.menu_obj)
      items = @.state.menu_items.map((el, i) =>
        # вначале рисуем родительский элемент меню
        if el.parent_id == null
          content = []
          content.push R.a({href: "##{el.id}"}, el.title)

          # ищем потомков в объекте меню и рисуем их
          submenu = _.where(@.state.menu_items, {parent_id: el.id})
          if submenu.length
            content.push R.ul({}, submenu.map((sub_el) =>
              R.li({}, R.a({href: "##{sub_el.id}"}, sub_el.title))
            ))

          R.li({}, content)

        # особый рендер потомков, если в коллекции нет родителя.
        # это актуально, когда работает поиск
        else if el.parent_id != null && _.where(@.state.menu_items, {id: el.parent_id}) < 1
          content = []
          content.push R.a({href: "##{el.id}"}, el.title)
          R.li({}, content)
      )

    inputValue =
      value: @.state.search_str
      requestChange: @.handleSearchStrChange

    R.div({}, [
      R.input({valueLink: inputValue})
      items
    ])