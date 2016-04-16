(function($){
    //$.fn.triggerPanel = function() {
    //    function init(elem){
    //        //prevent adding two butto with same id
    //        var elementId = $(elem).attr("id");
    //        if($("[id|='"+ elementId + "']").length > 1){
    //            console.log("TTT: W:" + "You may have added two element with same id");
    //        }
    //
    //        var filterPanel = $("#" + $(elem).data("panel-id"));
    //        if(filterPanel.length == 0) {
    //            console.log("TTT: " + "You may forgot to add filterPanel with id: " + $(elem).data("panel-id"));
    //            return;
    //        }
    //
    //        //position filter under filter button
    //        var jelem = $(elem);
    //        console.log("TTT: " + 200 )
    //        filterPanel.css({left: jelem.offset().left + jelem.outerWidth() - 16 - 200, top: jelem.offset().top + jelem.outerHeight()})
    //        //filterPanel.css({left: 10, top: 300})
    //        console.log('TTT: ' + JSON.stringify({left: jelem.offset().left + jelem.width() - filterPanel.width(), top: jelem.offset().top + jelem.height()}))
    //
    //    }
    //
    //    init(this);
    //
    //    $(this).unbind('click');
    //
    //    $(this).click(function(){
    //        var panel = $("#" + $(this).data("panel-id"));
    //        var current = $(this).data("show");
    //        $(this).data("show", !current);
    //        if (current) {
    //            panel.addClass("hidden-xs-up");
    //        } else {
    //            panel.removeClass("hidden-xs-up");
    //        }
    //    })
    //};

    window.MAGNIFY = {};

    function jqueryUI(html){
        if($( "#magnify-center")){
            $( "#magnify-center").remove();
        }
        var center = $("<div id='magnify-center' class='magnify-center'></div>");
        center.appendTo($("body"));
        $(html).appendTo(center);
        $( "#magnify-center" ).dialog({
            width:"auto"
        });
    }
    MAGNIFY.openModal = function(html){
        //remove modal if exist
        if($("#magnify-background-layer")){
            $("#magnify-background-layer").remove();
        }

        console.log("TTT: " + "open modal");
        var backgroundLayer = $("<div class='background-layer' id='magnify-background-layer'> </div>");
        backgroundLayer.appendTo($("body"));
        var center = $("<div id='magnify-center' class='magnify-center'></div>");
        center.appendTo(backgroundLayer);
        $(html).appendTo(center);
        center.offset({left: ($(window).width() - center.width())/2, top: ($(window).height() - center.height())/2})

        $("#magnify-background-layer").click(function(e){
            var target = $(e.target);
            if ($('#magnify-center').has(target).length == 0) {
                $("#magnify-background-layer").remove();
            }
        });
    }

    MAGNIFY.closeModal = function(html){
        if($("#magnify-background-layer")){
            $("#magnify-background-layer").remove();
        }
    }

})(jQuery);



