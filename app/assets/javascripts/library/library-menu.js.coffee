# НЕИСПОЛЬЗУЕМЫЙ КОД
# БЫЛ ЗАМЕНЕН НА reactjs КОМПОНЕНТ
#
#
#$ ->
#  ( ->
#    # find all top-heading h2
#    # and render main link.
#    # by each top-heading find subheading h5
#    # and for each subheading render sub-link.
#    # $('h2').not('.bs-example h2').first().parent('div').find('h5').not('.bs-example h5')
#
#    window.library = {}
#    window.library.$menu = $('.js-library-menu')
#    menu = [] # this html will be rendered
#
#    # set width of menu to parent width.
#    # because of it position will set to fixed after scrolling
#    library.$menu.width(library.$menu.parent().width())
#
#    # generate link into 'li'-tag with 'id' and 'title'
#    library.link_to = (id, title) ->
#      id = id ? '#'
#      id = id.replace('#','') ? ''
#      "<li><a href='##{id}'>#{title}</a></li>"
#
#    # all top-headers
#    $headers = $('h2').not('.bs-example h2')
#
#    menu.push('<ul>')
#
#    # construct headers-link and sub-headers link
#    _.each($headers, (h) ->
#      $h = $(h)
#      menu.push( library.link_to($h.attr('id'), $h.text()) )
#
#      # find and construct submenu links
#      $subhs = $h.parents('.row').first().find('h3').not('.bs-example h3')
#      if $subhs.length > 0
#        menu.push('<li><ul>')
#        _.each($subhs, (subh) ->
#          $subh = $(subh)
#          menu.push( library.link_to($subh.attr('id'), $subh.text()) )
#        )
#        menu.push('</ul></li>')
#    )
#
#    menu.push('</ul>')
#    # render menu
#    library.$menu.html(menu.join(''))
#  )()
