// манифест файл для библиотеки
//
//= require_self

// убираем стандартные клики по ссылкам, которые перемещают вначало страницы
$(document).ready(function(){
    $('.lib-example a').on('click', function(e){e.preventDefault()});
    $(document).checkboxes_and_radio()

    $('.js-select2').select2(global.select2);
    $('select.js-select2-nosearch').select2(global.select2_nosearch);
});

