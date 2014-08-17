var editor = ace.edit('editor');

if (editor) {
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

(function() {
  $('.btn-signup').click(function() {
    $slidebox = $('#slidebox');
    current_margin = $slidebox.css('margin-top').substring(0, $slidebox.css('margin-top').length - 2);
    if (current_margin > 0) {
      margin = '-266px';
    } else {
      margin = '30px';
    }

    $slidebox.animate({
      'margin-top': margin
    }, function() {
      $('input#name').focus();
      $('body').animate({scrollTop: $slidebox.offset().top});
    });
  });

  $(document).ready(function() {
    setTimeout(function() {
      $('#slidebox').toggle();
    }, 1000);
  });
})();
