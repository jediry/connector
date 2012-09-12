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
function delete_field(link) {
    $(link).prev("input[type=\"hidden\"]").val("1");
    $(link).parent(".field").hide();
}
