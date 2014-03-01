// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require bootbox.min
//= require_self

var rails = {
    inController: function(name) {
        return (new RegExp("\/" + name + "\/?$|\/" + name + "\/[0-9a-z]+$")).
            test(location.href);
    }
};

$(document).on("page:change", function() {
    // Activate tooltips
    $('[data-toggle="tooltip"]').tooltip();

    // Handle delete links from index page
    $('a[data-method="delete"]').click(function() {
        var link = $(this),
            question = link.data("question"),
            url = link.attr("href");
        bootbox.confirm(question, function(result) {
            if (!result) { return; }
            $.ajax(url + ".json", {
                type: "DELETE",
                complete: function(xhr) {
                    location.href = xhr.getResponseHeader("location");
                }
            });
        })
        return false;
    });

    // Activate affix plugin in bootstrap
    $('[data-spy="affix"]').affix({});

    // Toggle yesno buttons
    $(".yesno button").click(function() {
        var button = $(this), data = {}, model = {},
            scope = $("#" + button.attr("for")),
            loading = $(".loading", scope),
            buttons = $("button", scope),
            value = !button.hasClass("btn-success");

        // Disable buttons, show spinner.
        buttons.toggleClass("disabled");
        loading.toggleClass("invisible");

        // Package data value
        data[button.data("model")] = model;
        model[button.data("field")] = value;

        // Update object
        $.ajax(button.data("url") + ".json", {
            type: "PUT",
            data: data,
            success: function(xhr) {
                buttons.toggleClass("invisible");
            },
            complete: function(xhr, status) {
                loading.toggleClass("invisible");
                buttons.toggleClass("disabled");
            }
        });
    });
});
