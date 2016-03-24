//COMMON FUNCTION START
var crm = window.crm || {};
crm.registerUniqueHook = function(hookFunction, name){
    window.ONLOAD_HOOK = window.ONLOAD_HOOK || {};
    if(ONLOAD_HOOK.hasOwnProperty(name)){
        return;
    }
    window.ONLOAD_HOOK.name = hookFunction;
}

crm.runOnload = function(){
    var ONLOAD_HOOK = window.ONLOAD_HOOK || [];
    for(var key in ONLOAD_HOOK){
        var hook = ONLOAD_HOOK[key];
        if($.isFunction(hook)){
            console.log("TTT: run hook" + name);
            hook();
        } else {
            console.log("W: hook only accept function");
        }
    }
}

//EVENT EMITTER
crm.event = new EventEmitter();
var EVENT_EDIT_OK = "editOk"
var EVENT_EDIT_NG = "editNg"
var EVENT_EDIT_START = "editStart"