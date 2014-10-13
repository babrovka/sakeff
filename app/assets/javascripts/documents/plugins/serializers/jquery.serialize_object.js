/*
сериализуем параметры формы в объект
получаем объект типа
object = {
    input_name: input_value,
    input_name: [input_val1, input_val2]
}

если в input записано свойство multiple, то преобразуем value из '1,2,3' в [1,2,3]

*/
$.fn.serializeObject = function () {
    var o = {};
    var a = this.serializeArray();
    var self = this;
    $.each(a, function () {
        var $elem = self.find('[name="'+this.name+'"]'),
            is_multiple = false,
            value = '';

        if ($elem.attr('multiple')=='multiple'){
            is_multiple = true;
        }

        value = ( (is_multiple)? this.value.split(',') : this.value );

        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(value || '');
        } else {
            o[this.name] = value || '';
        }
    });
    return o;
};