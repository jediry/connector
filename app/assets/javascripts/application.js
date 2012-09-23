// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function add_field(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    $(link).before(content.replace(regexp, new_id));
}

// Given a <a> element, delete the "field" of which it is a part, by (a) locating a neighboring hidden field indicating
// whether the field should be destroyed on commit and set that to 1, and (b) hiding the entire "field" element.
function delete_field(link, hide_selector) {
    $(link).prev("input[type=\"hidden\"]").val("1");
    $(link).parent(hide_selector).hide();
}


function strip_nonnumeric(number) {
    var regexp = new RegExp("[^0-9]", "g");
    return number.replace(regexp, "");
}


function format_telephone_field(input) {
    var number = strip_nonnumeric(input.value);
    var area = number.substr(0, 3);
    var prefix = number.substr(3, 3);
    var suffix = number.substr(6, 4);
    var ext = number.substr(10);
    while (area.length < 3)
        area = ' ' + area;
    while (prefix.length < 3)
        prefix = ' ' + prefix;
    while (suffix.length < 4)
        suffix = ' ' + suffix;

    var formatted = "(" + area + ") " + prefix + "-" + suffix;
    if (ext.length > 0)
        formatted += " x" + ext;
    input.value = formatted;
}
