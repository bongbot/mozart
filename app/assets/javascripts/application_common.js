//COMMON FUNCTION START
var crm = window.crm || {};
crm.registerUniqueHook = function(hookFunction, name){
    window.ONLOAD_HOOK = window.ONLOAD_HOOK || {};
    if(ONLOAD_HOOK.hasOwnProperty(name)){
        return;
    }
    window.ONLOAD_HOOK[name] = hookFunction;
}

crm.runOnload = function(){
    var ONLOAD_HOOK = window.ONLOAD_HOOK || {};
    $.each( ONLOAD_HOOK, function( key, value ) {
        crm.runHook(key);
    });
}


crm.runHook = function(name){
    var hook = ONLOAD_HOOK[name];
    if($.isFunction(hook)){
        console.log("TTT: run hook:" + name);
        hook();
    } else {
        console.log("W: hook only accept function");
    }
}

//EVENT EMITTER
crm.event = new EventEmitter();
var EVENT_EDIT_OK = "editOk";
var EVENT_EDIT_NG = "editNg";
var EVENT_EDIT_START = "editStart";
var EVENT_EDIT_CANCEL = "editCancel";

//Enable all tool tips
crm.registerUniqueHook(function(){
    $('[data-toggle="tooltip"]').tooltip();
}, "tooltip");

//Function to toggle "edit" at the end of url
crm.toggleUrlEdit = function(toggle){
    var curUrl = window.location.href;
    if(toggle){
        curUrl = curUrl + "/edit"
    } else {
        curUrl = curUrl.substring(0, curUrl.length - "/edit".length)
    }
    window.history.pushState('', 'Title', curUrl);
}

//!Remote link (and a like) prevent event bubble so bootstrap not toggled. Below code fix this issude
//usage: add ".dropdown-remote" class to menu with remote link
$(function(){
    $(".dropdown-remote").each(function(){
        var self = this;
       $(self).find(".dropdown-item a").click(function(){
            $(self).find(">button").dropdown("toggle");
        })
    });
});