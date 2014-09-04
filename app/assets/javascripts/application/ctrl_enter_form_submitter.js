$.fn.ctrlEnterFormSubmitter = function (fn) {
    var $form = $(this);
    $form.on('keydown','input, select, textarea', function (e) {
        if ((e.keyCode === 13 && e.ctrlKey) || (e.keyCode === 13 && e.metaKey)) {
            e.preventDefault();
            $form.submit()
        }
    });

};