jQuery(document).ready(function() {
    if (jQuery('#event_search_form').length > 0) search_toggle();
    if (jQuery('.toggler').length > 0) mobile_toggle();
    if (jQuery('.calendar.list').length > 0) infinite_setup();
});

function mobile_toggle() {
    jQuery('.choose').click(function(e) {
        jQuery(this).parent().toggleClass('hover');
        e.preventDefault()
    });
}

function search_toggle() {
    jQuery('#mobile_search').click(function(e) {
        if (jQuery('#event_search_form input[type="text"]').val() !== 'Search calendar') {
            jQuery('#event_search_form').submit();
        } else {
            jQuery('#event_search_form').toggleClass('open');
        }
        e.preventDefault();
    });
    jQuery('#event_search_form #s').focus(function() {
        jQuery(this).addClass('focus');
    });
    jQuery('#event_search_form #s').blur(function() {
        jQuery(this).removeClass('focus');
    });
}