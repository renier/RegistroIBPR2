// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
function filterOnRole() {
	var role = $('#person-role-filter').val(),
		url = location.href.replace(/[?&]role=[0-9]?/, '');

	url = url + (url.indexOf('?') !== -1 ? '&' : '?');

	location.href = url + 'role=' + role;
}