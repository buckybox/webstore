$(document).ready(function() {
  NProgress.configure({ minimum: 0.2, trickleRate: 0.1, trickleSpeed: 500 });

  $('a:not([target="_blank"])').click(function() { NProgress.start(); });
  $('form').submit(function() { NProgress.start(); });

  $(window).load(function() { NProgress.done(); });
});

