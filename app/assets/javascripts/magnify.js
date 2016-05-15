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

MAGNIFY.bodyScrollable = function(scrollable){
    var css = scrollable ? "visible" : "hidden";
    $("body").css("overflow", css);
}


MAGNIFY.openModal = function(html){
    //remove modal if exist
    if($("#magnify-background-layer")){
        $("#magnify-background-layer").remove();
    }

    var backgroundLayer = $("<div class='background-layer' id='magnify-background-layer'> </div>");
    backgroundLayer.appendTo($("body"));
    var center = $("<div id='magnify-center' class='magnify-center'></div>");
    center.appendTo(backgroundLayer);
    center.css("overflow", "auto");
    center.css("border-radius", "10px");
    $(html).appendTo(center);

    $("#magnify-background-layer").click(function(e){
        var target = $(e.target);
        if ($('#magnify-center').has(target).length == 0) {
            $("#magnify-background-layer").remove();
        }
    });

    $(window).resize(function(){
        resizeMagnifyCenter();
    });

    var paddingH = 20;
    var paddingW = 20;

    function resizeMagnifyCenter(){
        var contentH = center[0].scrollHeight;
        var contentW = center[0].scrollWidth;
        var maxH = $(window).height() - paddingH * 2;
        var maxW = $(window).width() - paddingW * 2;

        if(contentH > maxH) {
            center.height(maxH)
        }

        if(contentW > maxW) {
            center.width(maxW);
        }

        center.offset({left: ($(window).width() - center.width())/2, top: ($(window).height() - center.height())/2})

    }

    resizeMagnifyCenter();

    MAGNIFY.bodyScrollable(false);

}

MAGNIFY.closeModal = function(html){
    if($("#magnify-background-layer")){
        $("#magnify-background-layer").remove();
    }
    MAGNIFY.bodyScrollable(true);
}




