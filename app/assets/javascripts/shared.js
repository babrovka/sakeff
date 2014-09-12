// Глобальный манифест
// загружает все-все плагины и классы
// инициализацией кода занимаются отдельные манифесты
// по имени лэйаутов, из которых они вызываются.
//
//
//
//= require_self
//
// для работы тестов нужен хук
//= require poltergeist_hook
//
//
// Plugins
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require select2
//= require select2_locale_ru
//= require i18n
//= require i18n/translations
//= require private_pub
//= require moment
//= require moment/ru.js
//= require underscore
//= require bootstrap
//= require jquery_nested_form
//
//= require plugins/three-d/three.min
//= require_tree ./plugins
//
//
// Backbone models
// =require plugins/backbone/exoskeleton
// =require plugins/backbone/backprop
//= require models/base
//= require_directory ./models
//
//
// React components
//
//= require react
//= require react_ujs
//= require_tree ./react_components
//
//
//= require shared/settings
//= require_tree ./shared


// Определяем пространство имен
window.app || (window.app = {});
