// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("page:change", function() {
    window.refreshDashboardTimeout = setInterval(function() {
        $("#home-link")[0].click();
    }, 60000);
});