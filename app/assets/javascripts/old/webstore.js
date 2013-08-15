$(function() {
  $('#buy_extra_include_extras').change(function() {
    if($(this).is(':checked')) {
      $('#webstore_extras').show();
    }
    else {
      $('#webstore_extras').hide();
    }
  });

  if($('#webstore-items').length > 0) {
    var container = $('#webstore-items');

    container.imagesLoaded(function(){
      $('#webstore-items').masonry({
        itemSelector : '.webstore-item',
        isResizable: true,
        columnWidth: function(containerWidth) {
          var columns;

          if(containerWidth == 870) { columns = 3; }
          else if(containerWidth == 700) { columns = 3; }
          else if(containerWidth == 538) { columns = 2; }
          else { columns = 1; }

          return containerWidth / columns;
        },
      });
    });
  }

  if($('#webstore-customise').length > 0) {
    var dislikes = $('#webstore-customise .dislikes_input');
    var likes = $('#webstore-customise .likes_input');

    dislikes.find('select').select2();//{maximumSelectionSize: dislikes.find('select').data('limits')});
    likes.find('select').select2();//{maximumSelectionSize: likes.find('select').data('limits')});
    likes.hide();

    $('#webstore-customisations').toggle(
      $('#webstore_customise_order_has_customisations').is(":checked")
    );

    $('#webstore_customise_order_has_customisations').click(function() {
      checkbox_toggle(this, $('#webstore-customisations'));
    });

    dislikes.change(function() {
      var likes_input    = $('#webstore-customisations').find('.likes_input');
      var dislikes_input = $(this);

      disable_the_others_options(dislikes_input, likes_input);

      if(!dislikes_input.is(':hidden') && dislikes_input.find('option:selected').length > 0) {
        likes_input.show();
      }
      else {
        likes_input.find('option:selected').removeAttr('selected');
        likes_input.find('select').trigger('liszt:updated');
        likes_input.find('select').select2("val", "");
        enable_all_options(dislikes_input);
        likes_input.hide();
      }
    });

    likes.change(function() {
      var likes_input    = $(this);
      var dislikes_input = $('#webstore-customisations').find('.dislikes_input');

      disable_the_others_options(likes_input, dislikes_input);

      if(dislikes_input.find('option:selected').length == 0) {
        likes_input.find('option:selected').each(function() {
          $(this).removeAttr('selected');
          likes_input.hide();

          likes_input.find('select').trigger("liszt:updated");
        });
      }
    });
  }

  if($('#webstore-extras').length > 0) {
    var extras_list = $("#webstore-extras .extras-row");
    extras_list.each(function() {
      var quantity = $(this).find("input").val();
      if (quantity > 0) {
        $(this).show();
      }
    });

    var extras_input = $('#webstore-extras select');
    extras_input.select2();
    extras_input.change(function() {
      var extras_input = $(this);
      var selected_extra = $(extras_input.find('option:selected')[0]);
      var extra_id = selected_extra.val();
      var quantity_input = $('#webstore_customise_order_extras_' + extra_id);

      quantity_input.val(1);
      quantity_input.closest('tr').show();

      selected_extra.attr('disabled', 'disabled');
      selected_extra.removeAttr('selected');
      selected_extra.closest('select').select2('val', '');
      selected_extra.closest('select').trigger("liszt:updated");

      total_options = extras_input.find('option').length - 1;
      disabled_options = extras_input.find('option:disabled').length;

      if(total_options == disabled_options) { extras_input.closest('tr').hide(); }
    });
  }

  if($('#webstore-login').length > 0) {
    function password_field_visibility() {
      var show_password_field = ($('#registered input[type=radio]:checked').val() != 'new');
      $('#password-field').toggle(show_password_field);
    }

    password_field_visibility();

    $('#registered input[type="radio"]').click(function() {
      password_field_visibility();
    });
  }

  if($('#webstore-route').length > 0) {
    var route_select = $('#route_select');
    var weeks = $('.route-schedule-inputs .order-days tr');

    weeks.hide();
    update_route_information(route_select.val());
    update_day_checkboxes_style();

    route_select.change(function() {
      update_route_information(route_select.val());
      update_days();
      update_day_checkboxes_style();
    });

    update_days();

    $('.route-schedule-frequency').change(update_days);

    $('.order-days input').click({weeks: weeks}, function(event) {
      var checkbox = $(event.target)
      var selected_week = checkbox.closest('tr');

      if (checkbox.is(':checked')) {
        // disable the other rows
        var other_weeks = event.data.weeks.not(selected_week);
        other_weeks.find('input').prop('disabled', 'true').removeAttr('checked');

      } else if (selected_week.find('input:checked').length == 0) {
        // enable all rows if this is the only checked day
        weeks.find('input:data(enabled)').removeAttr('disabled');
      }

      update_day_checkboxes_style();
    });

    $('.schedule-start-date').change(function() {
      var weeks = $('.route-schedule-inputs:visible .order-days tr');
      weeks.find('input:data(enabled)').removeAttr('disabled');
      update_day_checkboxes($(this));
    });
  }

  if($('#webstore-address').length > 0) {
    var webstore_address = $('#webstore-address');

    $('#webstore-address #edit-address').click(function() {
      $("#existing-address").hide();
      $("#update-address").show();
    });
  }
});

function update_days() {
  var frequency = $('.route-schedule-frequency:visible').val();
  var weeks = $('.route-schedule-inputs:visible .order-days tr');
  var week_numbers = weeks.find('td:first-child');
  var other_weeks = $('.route-schedule-inputs:not(:visible) .order-days tr')
  other_weeks.find('input').prop('disabled', 'true').removeAttr('checked');

  if (!frequency || frequency === 'single') {
    weeks.hide();
  } else if (frequency === 'monthly') {
    week_numbers.show();
    weeks.show();
  } else {
    week_numbers.hide();
    weeks.slice(1).hide();
    weeks.first().show();
  }

  weeks.find('input:data(enabled)').removeAttr('disabled');
  var route_id = $('#route_select').val();
  var route_schedule = $('#route-schedule-inputs-' + route_id);
  update_day_checkboxes(route_schedule.find('.schedule-start-date'));
}

function update_day_checkboxes_style() {
  $('.order-days:visible input[type="checkbox"]').each(function() {
    var checkbox = $(this);
    var td = checkbox.closest('td');

    if (checkbox.is(':checked') || checkbox.data('enabled')) {
      td.removeClass('disabled');
    } else {
      td.addClass('disabled');
    }
  });
}

function update_day_checkboxes(start_date) {
  var date = new Date(start_date.val());
  var route_schedule_inputs = start_date.closest('.route-schedule-inputs');

  route_schedule_inputs.find('input[type="checkbox"]:not([data-enabled])').prop('checked', false);

  var frequency = route_schedule_inputs.find('.route-schedule-frequency').val();
  var weeks = route_schedule_inputs.find('.order-days tr');

  if (frequency !== 'monthly') {
    weeks.slice(1).find('input[type="checkbox"]').prop('checked', false);
  }

  // pre-select first day if none already picked
  if (weeks.find('input[type="checkbox"]:checked').length == 0) {
    var checkbox_selector = '#day-' + date.getDay() + ' input[type="checkbox"]';
    selected_checkbox = route_schedule_inputs.find(checkbox_selector);
    selected_checkbox.prop('checked', true);
  }
}

function update_route_information(route_id) {
  $('.route-info').hide();
  $('#route-info-' + route_id).show();

  var all_route_schedule_inputs = $('.route-schedule-inputs');
  all_route_schedule_inputs.hide();
  all_route_schedule_inputs.find('select').prop('disabled', true);
  all_route_schedule_inputs.find('input[type="checkbox"]').prop('disabled', true);

  var route_schedule = $('#route-schedule-inputs-' + route_id);
  route_schedule.show();
  route_schedule.find('.order-days').show();
  route_schedule.find('select').prop('disabled', false);
  $.each(route_schedule.find('input[type="checkbox"]'), function(index, value) {
    var day = $(value);
    if(day.data('enabled')) { day.prop('disabled', false); }
  });
  update_day_checkboxes(route_schedule.find('.schedule-start-date'));
}

function checkbox_toggle(checkbox, div) {
  if(checkbox.checked) {
    div.show();
  }
  else {
    div.hide();
  }
}
