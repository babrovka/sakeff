class LibraryMenu
  constructor: () ->
    div = document.getElementsByTagName('body')[0]
    div.appendChild(this.create());
    return

  create: () =>
    that = this
    menu_container = document.createElement("div")
    _.each document.getElementsByClassName('js-library-row'), (item, key) ->
      console.log(this)
      level1 = document.createElement('div')
      level1.appendChild( that.createLink($(item).find('.js-library-header')[0]) )
      menu_container.appendChild(level1)

      _.each $(item).find('.js-library-subheader'), (item) ->
        level2 = document.createElement('div')
        level2 = that.createLink(item)
        menu_container.appendChild(level2)

    menu_container.className = 'library-menu'
    return menu_container

  createLink: (obj) =>
    link = document.createElement('a')
    link.href = '#'+obj.id
    linkText = document.createTextNode(obj.innerText);
    link.title= obj.innerText
    link.className = obj.className
    link.appendChild(linkText)
    return link


$ ->
  window.app.LibraryMenu = new LibraryMenu()