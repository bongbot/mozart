CKEDITOR.editorConfig = function (config) {
    //todo: fix image not display
    config.allowedContent = true ;

    config.toolbarGroups = [
        { name: 'basicstyles',     groups: [ "Bold",  "Italic",  "Underline",  "Strike",  "-",  "Subscript",  "Superscript" ] },
        { name: 'others'},
    ];

    //config.extraPlugins = 'imageadd';

}

