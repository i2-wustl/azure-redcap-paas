// remap jQuery to $
(function($){


/* trigger when page is ready */
$(document).ready(function (){
    $('#mobile-menu-icon').click(function() {
        $(this).toggleClass('active');
        $('#mobile-nav').slideToggle('fast').toggleClass('active');
        if($('#mobile-search-form').hasClass('active')) {
            $('#mobile-search-form').hide().toggleClass('active');
            $('#mobile-search-icon').removeClass('active');
        }
    });
    
    $('#mobile-search-icon').click(function() {
        $(this).toggleClass('active');
        $('#mobile-search-form').slideToggle('fast').toggleClass('active');
        if($('#mobile-nav').hasClass('active')) {
            $('#mobile-nav').hide().toggleClass('active');
            $('#mobile-menu-icon').removeClass('active');
        }
    });

    $('#mobile-nav').find('.page_item_has_children > a').each(function() {
        $(this).wrap( '<div></div>' );
    });

    $("#mobile-nav .page_item_has_children > div > a").each(function() {
        $(this).after( "<div class='dashicons dashicons-arrow-down-alt2 expand'></div>" );
    });

    $(".expand").click( function() {
        if( $(this).parent().parent().parent().parent().attr('id') == 'mobile-nav' ){
            $(".expanded").not($(this).parent().next()).removeClass("expanded").slideUp();
            $(".expand").not($(this)).addClass("dashicons-arrow-down-alt2").removeClass("dashicons-arrow-up-alt2");
        }
        $(this).parent().next().toggleClass("expanded").slideToggle('fast');
        $(this).toggleClass("dashicons-arrow-up-alt2 dashicons-arrow-down-alt2");
    });

    $("#mobile-nav .current_page_ancestor > .children").addClass("expanded").slideToggle();
    $("#mobile-nav .current_page_ancestor > div .dashicons-arrow-down-alt2").toggleClass("dashicons-arrow-up-alt2 dashicons-arrow-down-alt2");

    if($('#lists > div').length == 1) {
        $('#col1').css('width', 'auto');
    }

    (function(e){e.InFieldLabels=function(n,i,t){var a=this;a.$label=e(n),a.label=n,a.$field=e(i),a.field=i,a.$label.data("InFieldLabels",a),a.showing=!0,a.init=function(){var n;a.options=e.extend({},e.InFieldLabels.defaultOptions,t),a.options.className&&a.$label.addClass(a.options.className),setTimeout(function(){""!==a.$field.val()?(a.$label.hide(),a.showing=!1):(a.$label.show(),a.showing=!0)},200),a.$field.focus(function(){a.fadeOnFocus()}).blur(function(){a.checkForEmpty(!0)}).bind("keydown.infieldlabel",function(e){a.hideOnChange(e)}).bind("paste",function(){a.setOpacity(0)}).change(function(){a.checkForEmpty()}).bind("onPropertyChange",function(){a.checkForEmpty()}).bind("keyup.infieldlabel",function(){a.checkForEmpty()}),a.options.pollDuration>0&&(n=setInterval(function(){""!==a.$field.val()&&(a.$label.hide(),a.showing=!1,clearInterval(n))},a.options.pollDuration))},a.fadeOnFocus=function(){a.showing&&a.setOpacity(a.options.fadeOpacity)},a.setOpacity=function(e){a.$label.stop().animate({opacity:e},a.options.fadeDuration,function(){0===e&&a.$label.hide()}),a.showing=e>0},a.checkForEmpty=function(e){""===a.$field.val()?(a.prepForShow(),a.setOpacity(e?1:a.options.fadeOpacity)):a.setOpacity(0)},a.prepForShow=function(){a.showing||(a.$label.css({opacity:0}).show(),a.$field.bind("keydown.infieldlabel",function(e){a.hideOnChange(e)}))},a.hideOnChange=function(e){16!==e.keyCode&&9!==e.keyCode&&(a.showing&&(a.$label.hide(),a.showing=!1),a.$field.unbind("keydown.infieldlabel"))},a.init()},e.InFieldLabels.defaultOptions={fadeOpacity:.5,fadeDuration:300,pollDuration:0,enabledInputTypes:["text","search","tel","url","email","password","number","textarea"],className:!1},e.fn.inFieldLabels=function(n){var i=n&&n.enabledInputTypes||e.InFieldLabels.defaultOptions.enabledInputTypes;return this.each(function(){var t,a,o=e(this).attr("for");o&&(t=document.getElementById(o),t&&(a=e.inArray(t.type,i),(-1!==a||"TEXTAREA"===t.nodeName)&&new e.InFieldLabels(this,t,n)))})}})(jQuery);


    $("#search-form label").inFieldLabels({ fadeDuration: 0 });
    $('#search-btn').attr('disabled', 'disabled');
    $searchBox = $('#search-box');
    $searchBtn = $('#search-btn');
    $searchBox.keyup(function() {
        var empty = false;
        if ($searchBox.val() == '') {
            empty = true;
        }
        if (empty) {
            $searchBtn.attr('disabled', 'disabled');
        } else {
            $searchBtn.removeAttr('disabled');
        }
    });


    if($('.accordion-header')[0]) {
        $('.accordion-header').each(function() {
            $(this).html($(this).html() + "<div class='d'><span class='d1'></span><span class='d2'></span></div>");
        });

        $('.accordion-header').click(function() {
            if (!jQuery('.d1').is(':animated') ) {
                var $this = $(this);
                if ($this.next('.accordion-body-text').is(':hidden')) {
                    $this.find('.d1').animate({ top: 100 });
                    $this.next('.accordion-body-text').slideDown('fast');
                    $this.addClass('open-accordion');
                } else {
                    $this.find('.d1').animate({ top: 0 });
                    $this.next('.accordion-body-text').slideUp('fast');
                    setTimeout(function(){
                        $this.removeClass('open-accordion');
                    }, 200);
                }
            }
        });

        $('.expand-all').click(function() {
            if ( $(this).html() === 'Expand all' ) {
                $(this).html('Collapse all');
                $('.d1').animate({ top: 100 });
                $('.accordion-body-text').slideDown('fast');
                $('.accordion-header').addClass('open-accordion');
            } else {
                $(this).html('Expand all');
                $('.d1').animate({ top: 0 });
                $('.accordion-body-text').slideUp('fast');
                setTimeout(function(){
                    $('.accordion-header').removeClass('open-accordion');
                }, 200);
            }
        });
    }
});

})(window.jQuery);