// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); });

function initProperties() {
  $.post('/api/properties/filtered_results', {}, function(data) {
    renderPropertyData(data);
  });
}

function initFacets() {
  $('.js-types-facet input[type=checkbox]').change(function() {
    var types = [];
    $('.js-types-facet input:checked').each(function(index,checkbox) {
      types.push($(checkbox).val());
    });
    facetsChanged(types);
  });
}

function facetsChanged(types) {
  $.post('/api/properties/filtered_results', { "types" : JSON.stringify(types) }, function(data) {
    $('#properties-list').empty();
    renderPropertyData(data);
  });
}

function renderPropertyData(data) {
  data.forEach(function(property) {
    if(typeof renderedProperty == 'function') {
      var propertyHtml = $.parseHTML(renderedProperty());
      $(propertyHtml).find('.js-address-line-1').html(property["address1"]);
      $(propertyHtml).find('.js-address-line-2').html(property["address2"]);
      $('#properties-list').append(propertyHtml);
    }
  });
}
