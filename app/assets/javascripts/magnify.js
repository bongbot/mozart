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




