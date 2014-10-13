# coding: utf-8

module DocumentsHelper
  def pdf_to_png(document, width, height)

    #TODO: in production after clear database this code "unless...end" must remove
    # unless File.file?("./tmp/document_#{document.id}.pdf")
    #   pdf = DocumentPdf.new(document, 'show')
    #   pdf.render_file "tmp/document_#{document.id}.pdf"
    #   pdf = Magick::Image.read("tmp/document_#{document.id}.pdf").first
    #   thumb = pdf.scale(400, 520)
    #   thumb.write "public/system/documents/document_#{document.id}.png"
    # end
    image_tag "/system/documents/document_#{document.id}.png", class: 'table-img-md'
  end

  # TODO-tagir: данный метод более не используется. И стили переписаны на _document классы с использованием декораторов.
  # данный код можно удалять.
  def attach_doc(doc)
    ('<div class="b-doc-attach j-doc-attach"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAABUCAMAAADphaR3AAAApVBMVEXu8vPb29v9/f3Y2Nj////u8vP+/v7u8vPu8vMAAADn5+fh4eH5+fnl5eX4+Pjs7Oz29vbq6ur7+/vj4+Pt7e3Q0NDd3d3T09PMzMzx8fHf39/U1NTW1tbz8/PV1dXe3t7FxcX09PTv7+/u7u7y8vL7tLbsCRD1en9vb2//19f9xcWdnZ35lZe4uLhbW1v8pqb98vKnp6ewsLCSkpKFhYX+4+PvMTcDKDyQAAAACnRSTlPy////////q0AAT9qTZAAAA7pJREFUWMPVmItu2yAUhnOgox0Y21yMCcYX7GTNet2l2/s/2k6rttqWRG0cdVr/WEQGfTr/OQYss/h4drr4MEOL07OPi7MPs3W2OJ0Pny7QM5sldH6f78ksIXgPs6d7/QX1Spb9DV/8PP+5nguvP51/uj0GXjOm2Qkj8+DP6/XFxfrzLPjq4ur29vZqF2yHoVK+Cwb6dhv+cX51fvUDw36+2AWL75ff6svLr98uv5ot+BA9w9mzCGMnmpxgyYhGZRr7/hglWEgcIjjwCGvyqEIuR65M4EpKrorRKqvJsxT2KSmwKXgi+m/bnArulBAmL8syz1D6N6PZfWdpjBECxu2ci16q8aUKECWkSkcV7M3hh6wzNg/mX78N19fZPJgoJdVEXgEz9szovanilrEbtsYuC26Xxo372MTVxLnYXhhklBBBAIwZ25tHnpEsK/V2ZELKNmV5yf6D5/zuYJ0/tOWJzh472OvhrPFNXTVdA9FTiJUP5ADbetWmVU6S1ssyT23SL9rWBJuXtny2L3KkJtAeKsE7AFCURidUE52LvTQxQl9LSX3cAXMnah9oXXdVrCpKqw4qD7WX0FUVIBqxDF0s2nYbZqLqajDgIoTOgxMUTGxEiIlDE0UEFSgADeU+24UKKxumyU6tKsZyZTOrrDFjYa1aqrHlxbSnYCoY12DMgDEBgqMhBAEu9CI4BxhaAOaUdsLMNMhwKq0UaDD0WDgKdR8oFgt6HDUhgCt3R5ZCcYsmpZStVVKFSRalRPNGr6S1xbgsOrVvGwIfu66LEScWrSIMwlAHkVK0C3WEuo5eZvtgEV1weAEAEhImGUNf440RPYTQIb96q1VFmiqiQxnQZ5MfCGfeN/5ewzD4ZRptdgBcTqPC6gori7GQxg3mEDjEikKgPIAIUR5mu6Wdj47GEGlvaCizlFT5WjjhozFj5QBZR2mHi2wQb78BspTKVD5c+GuzMqU8T6i8bFv9EgwRPG1qaKgBWvMeFzEmT6OD6OURthl7KXI7jqu05Fmr+Niq5UE5E1P7CNVgZePrzsO/e92QdlQrJRhT1rSWlwfBWsYmdENGelM30U/v8RX7fmBGXsmxHbDuaReEU75qqnwvmsfoB7Nt21/7AeXsstB7YZJSa9ttmIuVcAZm5fz0f78XLLMDYSILFYy0nKuxOBRmuIzVNM5cVatx4sv5k4Qx9qYzTF0PzcDnwjc3mxs5E7abu7tNORMOm83mJsyE8fv9+91c21kiT9U+6njnqIOlo460jjpMO+oY7xfVApS4vVAerwAAAABJRU5ErkJggg==">
<span class="attach-title link">Предписание №321</span>
<span class="attach-nav"><a href="#" class="link link-muted">ООО Циклон</a><span class="fa fa-long-arrow-right text-muted"></span> <a href="#" class="link link-muted">ФКП Дирекция КЗС Минрегиона России</a><span>
</div>
<div class="b-doc-attach  j-doc-attach"><img src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADwAAABUCAMAAADphaR3AAAApVBMVEXu8vPb29v9/f3Y2Nj////u8vP+/v7u8vPu8vMAAADn5+fh4eH5+fnl5eX4+Pjs7Oz29vbq6ur7+/vj4+Pt7e3Q0NDd3d3T09PMzMzx8fHf39/U1NTW1tbz8/PV1dXe3t7FxcX09PTv7+/u7u7y8vL7tLbsCRD1en9vb2//19f9xcWdnZ35lZe4uLhbW1v8pqb98vKnp6ewsLCSkpKFhYX+4+PvMTcDKDyQAAAACnRSTlPy////////q0AAT9qTZAAAA7pJREFUWMPVmItu2yAUhnOgox0Y21yMCcYX7GTNet2l2/s/2k6rttqWRG0cdVr/WEQGfTr/OQYss/h4drr4MEOL07OPi7MPs3W2OJ0Pny7QM5sldH6f78ksIXgPs6d7/QX1Spb9DV/8PP+5nguvP51/uj0GXjOm2Qkj8+DP6/XFxfrzLPjq4ur29vZqF2yHoVK+Cwb6dhv+cX51fvUDw36+2AWL75ff6svLr98uv5ot+BA9w9mzCGMnmpxgyYhGZRr7/hglWEgcIjjwCGvyqEIuR65M4EpKrorRKqvJsxT2KSmwKXgi+m/bnArulBAmL8syz1D6N6PZfWdpjBECxu2ci16q8aUKECWkSkcV7M3hh6wzNg/mX78N19fZPJgoJdVEXgEz9szovanilrEbtsYuC26Xxo372MTVxLnYXhhklBBBAIwZ25tHnpEsK/V2ZELKNmV5yf6D5/zuYJ0/tOWJzh472OvhrPFNXTVdA9FTiJUP5ADbetWmVU6S1ssyT23SL9rWBJuXtny2L3KkJtAeKsE7AFCURidUE52LvTQxQl9LSX3cAXMnah9oXXdVrCpKqw4qD7WX0FUVIBqxDF0s2nYbZqLqajDgIoTOgxMUTGxEiIlDE0UEFSgADeU+24UKKxumyU6tKsZyZTOrrDFjYa1aqrHlxbSnYCoY12DMgDEBgqMhBAEu9CI4BxhaAOaUdsLMNMhwKq0UaDD0WDgKdR8oFgt6HDUhgCt3R5ZCcYsmpZStVVKFSRalRPNGr6S1xbgsOrVvGwIfu66LEScWrSIMwlAHkVK0C3WEuo5eZvtgEV1weAEAEhImGUNf440RPYTQIb96q1VFmiqiQxnQZ5MfCGfeN/5ewzD4ZRptdgBcTqPC6gori7GQxg3mEDjEikKgPIAIUR5mu6Wdj47GEGlvaCizlFT5WjjhozFj5QBZR2mHi2wQb78BspTKVD5c+GuzMqU8T6i8bFv9EgwRPG1qaKgBWvMeFzEmT6OD6OURthl7KXI7jqu05Fmr+Niq5UE5E1P7CNVgZePrzsO/e92QdlQrJRhT1rSWlwfBWsYmdENGelM30U/v8RX7fmBGXsmxHbDuaReEU75qqnwvmsfoB7Nt21/7AeXsstB7YZJSa9ttmIuVcAZm5fz0f78XLLMDYSILFYy0nKuxOBRmuIzVNM5cVatx4sv5k4Qx9qYzTF0PzcDnwjc3mxs5E7abu7tNORMOm83mJsyE8fv9+91c21kiT9U+6njnqIOlo460jjpMO+oY7xfVApS4vVAerwAAAABJRU5ErkJggg==">
<span class="attach-title link">Предписание №321</span>
<span class="attach-nav"><a href="#" class="link link-muted">ООО Циклон</a><span class="fa fa-long-arrow-right text-muted"></span> <a href="" class="link link-muted">ФКП Дирекция КЗС Минрегиона России</a><span>
</div>
<script>$( document ).ready(function() {
    $(".j-doc-attach").on("click", function(e){alert("Данный раздел находится в разработке");})
});</script>').html_safe
  end

  def humanize_documents_menu_item_name(key)
    I18n.t("shared.documents.menu_items.#{key}")
  end

end
