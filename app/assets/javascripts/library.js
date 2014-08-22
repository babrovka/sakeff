//
//= require_self

// убираем стандартные клики по ссылкам, которые перемещают вначало страницы
$(document).ready(function(){
    $('.lib-example a').on('click', function(e){e.preventDefault()});
});