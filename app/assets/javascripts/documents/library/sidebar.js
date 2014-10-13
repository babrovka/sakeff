$(document).ready(function () {

    var panel = $('.l-page__column');           //определяем панель

    $('#main-b').on('click', function (e) {         //логика главной кнопки
        e.preventDefault();
//        panel.closest('.js-sidebar').toggleClass('m-open');
        if (panel.closest('.js-sidebar').hasClass('m-open')) {
            document.location.href = '/';
        }
        else {
            panel.closest('.js-sidebar').addClass('m-open');
        }

    });

    var removeId = 0;

    function closeSidebar() {

        removeId = setTimeout(function() {
            $('.l-page__column').closest('.js-sidebar').removeClass('m-open');
            $('.menu-dir').removeClass('open');
            $('.child-dir').css({'height': '0px'});

        }, 2000)
    }

    panel.mouseleave(function(){
        closeSidebar()  //  вавтоскрытие
        }
    );

    panel.mouseenter(function(){clearTimeout(removeId)
    })

    $('.menu-dir .sidebar-header').click(function (e) {                //логика работы раскрывающихся папок
        e.preventDefault();
        var childDir = $(this).parent().next();
        if (panel.closest('.js-sidebar').hasClass('m-open')) {
            if (childDir.parent().hasClass('open')) {
                console.log(1);
                childDir.parent().toggleClass('open');
                childDir.css({'height': 0});
            }
            else {
                childDir.parent().toggleClass('open');
                var counter = childDir.children('.menu-link').length;
                childDir.css({'height': ((counter + 1) * 55) + 'px'});
            }
        }
        else {
            document.location.href = $('.sidebar-header ')[0].getAttribute('href');
        }
    });

});