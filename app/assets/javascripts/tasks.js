$(function() {
  $('#task_due_date').change(function () {
    $('.due-date-select').prop('disabled', !$(this).prop('checked'));
  });
});