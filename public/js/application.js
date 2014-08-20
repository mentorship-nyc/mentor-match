
if (typeof editorNeeded != 'undefined') {
  var editor = ace.edit('editor');
  editor.setTheme('ace/theme/xcode');
  editor.getSession().setTabSize(2);
  //editor.setKeyboardHandler('ace/keyboard/vim');
  editor.getSession().setMode('ace/mode/ruby');
  editor.focus();

  var languages = $('select#language-select');
  languages.select2({
    width: 'element'
  });

  languages.change(function() {
    editor.getSession().setMode(this.value);
    editor.focus();
  });

  var keyboards = $('select#keyboard-select');
  keyboards.select2({
    width: 'resolve'
  })

  keyboards.change(function() {
    editor.setKeyboardHandler(this.value);
    editor.focus();
  });
}
