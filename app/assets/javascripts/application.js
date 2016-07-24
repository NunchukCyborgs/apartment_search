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
//= require_tree ../../../vendor
//= require turbolinks
//= require cocoon
//= require_tree .

$(function(){ $(document).foundation(); });

var offsetPct = null;

Facetr = {
  properties: [],
  selectedFacets: {
    min_price: 0,
    max_price: null,
    min_bedrooms: 0,
    min_bathrooms: 0,
    max_lease_length: null,
    locations: [],
    amenities: [],
    types: [],
  },
  returnedFacets: { },

  initProperties: function() {
    this.getProperties();
  },

  initFacets: function() {
    var self = this;
    /* load facets data */
    self.getFacets(self.initPagination);
    self.setCallbacks();
  },

  getFacets: function(optionalCallback) {
    var self = this;
    $.post('/api/properties/facets', { facets: self.selectedFacets }, function(data) {
        console.log(data);
        self.returnedFacets = data;
        self.getProperties()
        /*self.setCallbacks();*/
        if(typeof optionalCallback === 'function') {
          optionalCallback();
        }
      });
  },

  getProperties: function(page) {
    var self = this;
    var page = typeof page !== 'undefined' ? page : 1;
    $.post('/api/properties/filtered_results', { facets: self.selectedFacets }, function(data) {
      console.log(data);
      self.properties = data;
      $('#properties-list').empty();
      self.renderPropertyData(data);
    });
  },

  setCallbacks: function() {
    Callbackr.setAllCallbacks();
  },

  /* gets updated whe na facet is selected on page */
  facetsChanged: function() {
    var self = this;
    /* updates facets lists */
    /* then updates properties lists */
    /* then re-sets callbacks */
    self.getFacets()
  },

  renderPropertyData: function(data) {
    data.forEach(function(property) {
      if(typeof renderedProperty == 'function') {
        var propertyHtml = $.parseHTML(renderedProperty());
        $(propertyHtml).find('.js-address-line-1').html(property["address1"]);
        $(propertyHtml).find('.js-address-line-2').html(property["address2"]);
        $(propertyHtml).find('.js-description').html(property["bedrooms"] + " Bedroom " + property["bathrooms"] + " Bath");
        $(propertyHtml).find('.js-price').html(number_to_currency(property["price"]));
        $(propertyHtml).find('.js-property-link').attr("href", "/properties/"+property["id"]);
        $('#properties-list').append(propertyHtml);
      }
      if(typeof Facetr.map !== 'undefined') {
        var marker = new RichMarker({
          map: Facetr.map,
          position:  new google.maps.LatLng(property["latitude"], property["longitude"]),
          anchor: new google.maps.Size(-20, -30),
          content: '<span class="map-marker tooltip top" title="">$' + property["price"] + '</span>'
        });
      }
    });

  },

  initPagination: function() {
    $(".js-pagination").pagination({
        items: Facetr.returnedFacets.total_count,
        itemsOnPage: 16,
        cssStyle: 'light-theme',
        onPageClick: function(pageNumber, event) {
          Facetr.getProperties(pageNumber)
        }
    });
  }

}

Callbackr = {

  setAllCallbacks: function() {
    var self = this
    self.setCallbacksOnPriceSlider();
    self.setCallbacksOnTypes();
    self.setCallbacksOnBedrooms();
    self.setCallbacksOnLocations();
    self.setCallbacksOnAmenities();
    self.setFacetReductionCallbacks();
  },

  setCallbacksOnPriceSlider: function() {
    $("body").on("changed.zf.slider", function() {
      Facetr.selectedFacets.min_price = parseInt($('input#sliderOutput1').val());
      Facetr.selectedFacets.max_price = parseInt($('input#sliderOutput2').val());
      Facetr.facetsChanged();
    });
  },

  setCallbacksOnTypes: function() {
    $('.js-types-facet a.button').click(function() {
      var button = $(this);
      var type = button.text()
      if(button.hasClass('selected')) {
        button.removeClass('selected');
        new_array = jQuery.grep(Facetr.selectedFacets.types, function(value) {
          return value != type;
        })
        Facetr.selectedFacets.types = new_array
      } else {
        button.addClass('selected')
        Facetr.selectedFacets.types.push(type);
      }
      Facetr.facetsChanged();
    });
  },

  setCallbacksOnBedrooms: function() {
    $('.js-bedrooms-facet a.button').click(function() {
      var button = $(this);
      var min_bedrooms = button.data('value');
      /* remove selected from all other bedroom buttons */
      $('.js-bedrooms-facet a.button').removeClass('selected');
      /* add 'selected' to clicked button and add to facets*/
      button.addClass('selected')
      Facetr.selectedFacets.min_bedrooms = min_bedrooms
      Facetr.facetsChanged();
    });
  },

  setCallbacksOnLocations: function() {
    $('.js-locations-facet input[type=checkbox]').change(function() {
        Facetr.selectedFacets.locations = [];
      $('.js-locations-facet input:checked').each(function(index,checkbox) {
        Facetr.selectedFacets.locations.push($(checkbox).val());
      });
      Facetr.facetsChanged();
    });
  },

  setCallbacksOnAmenities: function() {
    $('.js-amenities-facet input[type=checkbox]').change(function() {
        Facetr.selectedFacets.amenities = [];
      $('.js-amenities-facet input:checked').each(function(index,checkbox) {
        Facetr.selectedFacets.amenities.push($(checkbox).val());
      });
      Facetr.facetsChanged();
    });
  },

  /* reduce selection boxes when they no longer apply to previously selected facets */
  setFacetReductionCallbacks: function() {

  }
}
