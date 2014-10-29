// TODO: @tagir need refactor. This code must have a default modificator value instead of two modificators.
/**
* Created by shine on 28.01.14.
*/
$(document).ready(function(){

        var actions = {
            append: function(elem, target){
                $('.js-info').removeClass('tr-slim');
                $('.js-more-info').hide();
                target.show();
                elem.addClass('tr-slim');
                target.addClass('tr-slim');
            },
            replace: function(elem, target){
                $('.tr-slim').removeClass('tr-slim');
                $('.js-info').show();
                $(".js-more-info").hide();

                elem.toggle();

                target.closest('tr').addClass('tr-slim');
                target.toggle();
            }
        };
        $(document).on('click', '.js-row-clickable tr', function(e) {

          // не раскрываем,если кликнули на особой кнопке
          // где она и как никого не волнует
          if(!$(e.target).hasClass('js-row-clickable-skip')) {
            var $elem, $target, id;

            $elem = $(this).find($('.js-info'));
            $elemAppend = $(this).closest($('.js-info'));

            id = $(this).data('id');
            $target = $(this).find(".js-more-info");
            $targetAppend = $(this).next();


            if (($(this).closest('.table')).hasClass('m-table-append')) {
              actions.append($elemAppend, $targetAppend);
            } else {

              actions.replace($elem, $target);

            }
          }
        });
});

