// back to top js
$("#back-top").hide();
$(document).ready(function () {
  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
      $('#back-top').fadeIn();
    } else {
      $('#back-top').fadeOut();
    }
  });
  $('#back-top a').click(function () {
    $('body,html').animate({
      scrollTop: 0
    }, 800);
    return false;
  });
});

// toc js
$(function () {
  $('.content').toc({
    minItemsToShowToc: 0,
    renderIn: '#renderIn',
    contentsText: "Table of Content",
    hideText: 'Collapse',
    showText: 'Expand',
    showCollapsed: true
  });
});