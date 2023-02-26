// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on("ready turbolinks:render", function() {
  window.clearInterval(window.refreshDashboardTimeout);
  window.refreshDashboardTimeout = setInterval(function() {
      if (location.pathname !== '/') { return; }
      $("#home-link")[0].click();
  }, 60000);
});
