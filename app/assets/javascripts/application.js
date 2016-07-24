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

Facetr = {
  properties: [],
  facets: {
    min_price: 0,
    max_price: null,
    min_bedrooms: 0,
    min_bathrooms: 0,
    max_lease_length: null,
    locations: [],
    amenities: [],
    types: [],
  },
  currentPage: 1,

  initProperties: function() {
    console.log("initializing properties");
    this.getProperties();
  },

  initFacets: function() {
    console.log("initializing facets");
    var self = this;
    /* load facets data */
    self.getFacets();
    self.setCallbacks();
  },

  getFacets: function() {
    console.log("getting facets");
    var self = this;
    $.post('/api/properties/facets', self.facets, function(data) {
        console.log(data);
        self.facets = data;
        self.getProperties()
        self.setCallbacks();
        self.updateFacetValuesOnPage();
      });
  },

  getProperties: function(page) {
    console.log("getting properties");
    var self = this;
    var page = typeof page !== 'undefined' ? page : self.currentPage;
    $.post('/api/properties/filtered_results', self.facets, function(data) {
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
      $('.js-types-facet input:checked').each(function(index,checkbox) {
        self.facets.types.push($(checkbox).val());
      });
      self.facetsChanged(types);
    });
  },

  updateFacetValuesOnPage: function() {
  },

  /* gets updated whe na facet is selected on page */
  facetsChanged: function(types) {
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

  numPages: function() {
    return this.facets.numPages;
  }

}

Paginatr = {

  moveToPage: function(pageNumber) {
    if(pageNumber === 1) {
      var html = this.firstPageNumberListItemHtml();
    } else if(pageNumber === Facetr.numPages) {
      var html = this.lastPageNumberListItemHtml();
    } else {
      var html = this.pageNumberListItemHtml(pageNumber);
    }
    $(".js-pagination").html(html);
  },

  lastPageNumberListItemHtml: function() {
    var html = "<li>";
  },

  firstPageNumberListItemHtml: function() {
    var html = "<li>";
  },

  pageNumberListItemHtml: function() {
    var html = "<li>";
  }


}
