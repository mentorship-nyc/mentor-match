function githubLink(username) {
  return '<a href="https://github.com/' + username + '" rel="external" target="_blank">' + username + '</a>';
}

function profileTitle($element) {
  var segments = [];

  segments.push('<div class="btn-group"><button type="button" class="btn btn-default">Contact</button></div>');
  segments.push($element.data('name'));
  segments.push('<p>' + $element.data('role') + '</p>');

  return segments.join('');
}

function profileContent($element) {
  var sections = []

  sections.push(profileSection('Bio', $element.data('bio')));
  sections.push(profileSection('Availability', $element.data('availability')));
  sections.push(profileSection('Github', githubLink($element.get(0).id)));
  sections.push(profileList('Skills', $element.data('skills').split(',')));

  return sections.join('');
}

function profileList(title, list) {
  var segments = [];

  segments.push('<h5>' + title + '</h5>');

  segments.push('<div class="list">');
  $(list).each(function(index, item) {
    segments.push('<p><span class="fa fa-tag"></span>' + item.trim() + '</p>');
  });
  segments.push('</div>')

  return segments.join('');
}

function profileSection(title, content) {
  return '<h5>' + title + '</h5>' + '<p class="' + title.toLowerCase() + '">' + content + '</p>';
}

$('.spotlight .profile .img').each(function(index, element) {
  $profile = $(element).parents('.profile');

  $profile.popover({
    container: '#' + $profile.attr('id'),
    content: profileContent($profile),
    html: true,
    placement: 'auto right',
    title: profileTitle($profile),
    trigger: 'hover'
  });

  $profile.on('shown.bs.popover', function() {
    var left = $profile.find('.popover').css('left').slice(0, -2);
    $profile.find('.popover').css('left', (left - 10) + 'px');
  });
});

$('a[rel=external]').each(function(index, element) {
  $(element).attr('target', '_blank');
});

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
