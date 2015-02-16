// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
  $('.content-slider .fa-chevron-left').click(function() {
    $('.content-slider .sliding-panel.active').hide('slide', {duration: 2000, direction: 'left', easing: 'easeInOutQuad', complete: function() {
      $(this).removeClass('active').addClass('inactive');
    }});
    $('.content-slider .sliding-panel.inactive').show('slide', {duration: 2000, direction: 'right', easing: 'easeInOutQuad', complete: function() {
      $(this).removeClass('inactive').addClass('active');
    }});
  });

  $('.content-slider .fa-chevron-right').click(function() {
    $('.content-slider .sliding-panel.active').hide('slide', {duration: 2000, direction: 'right', easing: 'easeInOutQuad', complete: function() {
      $(this).removeClass('active').addClass('inactive');
    }});
    $('.content-slider .sliding-panel.inactive').show('slide', {duration: 2000, direction: 'left', easing: 'easeInOutQuad', complete: function() {
      $(this).removeClass('inactive').addClass('active');
    }});
  });

});