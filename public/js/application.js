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
