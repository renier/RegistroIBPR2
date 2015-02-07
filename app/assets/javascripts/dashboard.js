// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("ready page:change", function(event) {
    var url;
    window.clearInterval(window.refreshDashboardTimeout);
    if (event.originalEvent) {
        url = event.originalEvent.target.URL;
        if (url.charAt(url.length - 1) !== "/") { return; }
    }
    window.refreshDashboardTimeout = setInterval(function() {
        $("#home-link")[0].click();
    }, 60000);
});
