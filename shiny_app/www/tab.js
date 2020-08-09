$('.menu .item')
  .tab()
;

$(document).on('shiny:sessioninitialized', 
function(event) {Shiny.onInputChange('",id, "_tab', '", active_tab, "');}); 
var previous_tab;
$('#", id, ".menu .item').tab({onVisible: function(target) {if (previous_tab) {$(this).trigger('hidden');}    $(window).resize();
$(this).trigger('shown');
previous_tab = this;
Shiny.onInputChange('",id, "_tab', $(this).attr('data-tab'))}});