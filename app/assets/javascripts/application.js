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
    console.log("initializing properties");
    this.getProperties();
  },

  initFacets: function() {
    console.log("initializing facets");
    var self = this;
    /* load facets data */
    self.getFacets(self.initPagination);
    self.setCallbacks();
  },

  getFacets: function(optionalCallback) {
    console.log("getting facets");
    var self = this;
    $.post('/api/properties/facets', { facets: self.selectedFacets }, function(data) {
        console.log(data);
        self.returnedFacets = data;
        self.getProperties()
        self.setCallbacks();
        self.updateFacetValuesOnPage();
        if(typeof optionalCallback === 'function') {
          optionalCallback();
        }
      });
  },

  getProperties: function(page) {
    console.log("getting properties");
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
    console.log("setting callbacks");
    var self = this;
    /* set callbacks on types */
    $('.js-types-facet input[type=checkbox]').change(function() {
        self.selectedFacets.types = [];
      $('.js-types-facet input:checked').each(function(index,checkbox) {
        self.selectedFacets.types.push($(checkbox).val());
      });
      self.facetsChanged();
    });
    /* set callbacks on amenities */
    $('.js-amenities-facet input[type=checkbox]').change(function() {
        self.selectedFacets.amenities = [];
      $('.js-amenities-facet input:checked').each(function(index,checkbox) {
        self.selectedFacets.amenities.push($(checkbox).val());
      });
      self.facetsChanged();
    });
    /* set callbacks on locations */
    $('.js-locations-facet input[type=checkbox]').change(function() {
        self.selectedFacets.locations = [];
      $('.js-locations-facet input:checked').each(function(index,checkbox) {
        self.selectedFacets.locations.push($(checkbox).val());
      });
      self.facetsChanged();
    });
  },

  updateFacetValuesOnPage: function() {
    /* using rendering set up by stephen for facet columns*/
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
        $('#properties-list').append(propertyHtml);
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
