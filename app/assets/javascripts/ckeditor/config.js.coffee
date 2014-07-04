CKEDITOR.editorConfig = (config) ->
  config.toolbar_Pure = [
    { name: 'basicstyles', items: [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
    { name: 'paragraph',   items: [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-' ] },
  ]
  config.toolbar = 'Pure'
  config.width = 540;
  config.removePlugins = 'elementspath';
  true