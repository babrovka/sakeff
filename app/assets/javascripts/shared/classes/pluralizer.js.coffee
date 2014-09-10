# Allows to get correct pluralize word from from its count
# @note is used on bubbles tooltips
# @param i [Integer] number of objects
# @param str1 [String] word for single object
# @param str2 [String] word for a couple of objects
# @param str3 [String] word for many objects objects
# @example
#   window.app.Pluralizer.pluralizeString(10, "товар","товара","товаров") // 10 товаров
# @note source: http://blog.rayz.ru/javascript-russian-plural.html
@.app.Pluralizer =
  pluralizeString: (i, str1, str2, str3) ->
    plural = (a) ->
      if a % 10 is 1 and a % 100 isnt 11
        0
      else if a % 10 >= 2 and a % 10 <= 4 and (a % 100 < 10 or a % 100 >= 20)
        1
      else
        2
    switch plural(i)
      when 0
        str1
      when 1
        str2
      else
        str3