$(function() {
  $('#item_category_id').change(function() {
    var url = '/admin/settings/'+$(this).val()+'.json?namespace='+$(this).attr('data-namespace')+'&type=categories&info=true';

    $.getJSON(url, function(data) {
      $('#item_letter').html(
        $.map(data['alpha'], function(value, index) {
          return '<option value="'+value['letter']+'">'+'Letter: '+value['letter']+' Items: '+value['items']+'</option>';
        })
      );
    });
  });

  $('#item_letter').change(function() {
    var category_select = $('#item_category_id');
    var base_url = '/admin/settings/'+category_select.val()+'.json';
    var query = '?namespace='+category_select.attr('data-namespace')+'&type=categories&letter='+$(this).val()+'&page=1&info_items=true';

    $.getJSON(base_url+query, function(data) {
      var items_table = $('#items-table');

      items_table.attr('data-total', data['total']);
      items_table.attr('data-page', 1);

      if(data['total'] > 12) {
        $('#item-page-next').removeClass('disabled');
        $('#item-page-next').attr('data-next', 2);
      }

      $('#items-table tbody').html(
        $.map(data['items'], function(value, index) {
          return '<tr class="item" data-item-id="'+value['id']+'"><td><img src="'+value['icon']+'"/></td><td>'+value['name']+'</td></tr>';
        })
      );
    });
  });

  $('#item-page-next').click(function(e) {
    e.preventDefault();

    if($('#items-table tbody').is(':empty') || $(this).hasClass('disabled')) {
      return false;
    }

    var category_select = $('#item_category_id');
    var page = parseInt($(this).attr('data-next'));
    var base_url = '/admin/settings/'+category_select.val()+'.json';
    var query = '?namespace='+category_select.attr('data-namespace')+'&type=categories&letter='+$('#item_letter').val()+'&page='+page+'&info_items=true';

    $.getJSON(base_url+query, function(data) {
      var items_table = $('#items-table');

      items_table.attr('data-total', data['total']);
      items_table.attr('data-page', page);

      $('#item-page-prev').attr('data-prev', page - 1);
      $('#item-page-prev').removeClass('disabled');

      if(data['total'] > page * 12) {
        $('#item-page-next').addClass('disabled');
      } else {
        $('#item-page-next').removeClass('disabled');
        $('#item-page-next').attr('data-next', page + 1);
      }

      $('#items-table tbody').html(
        $.map(data['items'], function(value, index) {
          return '<tr class="item" data-item-id="'+value['id']+'"><td><img src="'+value['icon']+'"/></td><td>'+value['name']+'</td></tr>';
        })
      );
    });

  });

  $('#item-page-prev').click(function(e) {
    e.preventDefault();

    if($('#items-table tbody').is(':empty') || $(this).hasClass('disabled')) {
      return false;
    }

    var category_select = $('#item_category_id');
    var page = parseInt($(this).attr('data-prev'));
    var base_url = '/admin/settings/'+category_select.val()+'.json';
    var query = '?namespace='+category_select.attr('data-namespace')+'&type=categories&letter='+$('#item_letter').val()+'&page='+page+'&info_items=true';

    $.getJSON(base_url+query, function(data) {
      var items_table = $('#items-table');

      items_table.attr('data-total', data['total']);
      items_table.attr('data-page', page);

      $('#item-page-next').attr('data-next', page + 1);
      $('#item-page-next').removeClass('disabled');

      if(page == 1) {
        $('#item-page-prev').addClass('disabled');
      } else {
        $('#item-page-prev').removeClass('disabled');
        $('#item-page-prev').attr('data-prev', page - 1);
      }

      $('#items-table tbody').html(
        $.map(data['items'], function(value, index) {
          return '<tr class="item" data-item-id="'+value['id']+'"><td><img src="'+value['icon']+'"/></td><td>'+value['name']+'</td></tr>';
        })
      );
    });
  });

  $('#items-table').on('click', 'tr', function() {
    $('#items-table tr').removeClass('info');
    $(this).addClass('info');
    $('#item_item_id').val($(this).attr('data-item-id'));
  });
});

