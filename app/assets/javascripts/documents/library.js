// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require_self
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require i18n
//= require i18n/translations
//= require bootstrap
//= require jquery_nested_form
//= require private_pub
//= require chosen-jquery
//= require react
//= require react_ujs
//= require select2
//= require moment
//= require moment/ru.js
//= require ckeditor/init
//= require_tree ./plugins
//= require ckeditor/ckeditor
//= require_tree ./library
//= require_tree ./react_widgets

(function() {

    var Ap = Array.prototype;
    var slice = Ap.slice;
    var Fp = Function.prototype;

    if (!Fp.bind) {
        // PhantomJS doesn't support Function.prototype.bind natively, so
        // polyfill it whenever this module is required.
        Fp.bind = function(context) {
            var func = this;
            var args = slice.call(arguments, 1);

            function bound() {
                var invokedAsConstructor = func.prototype && (this instanceof func);
                return func.apply(
                    // Ignore the context parameter when invoking the bound function
                    // as a constructor. Note that this includes not only constructor
                    // invocations using the new keyword but also calls to base class
                    // constructors such as BaseClass.call(this, ...) or super(...).
                        !invokedAsConstructor && context || this,
                    args.concat(slice.call(arguments))
                );
            }

            // The bound function must share the .prototype of the unbound
            // function so that any object created by one constructor will count
            // as an instance of both constructors.
            bound.prototype = func.prototype;

            return bound;
        };
    }

})();
