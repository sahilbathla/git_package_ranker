var repositories = {
	search: function search () {
		$('#search-target').text('Searching...');
		var searchParams = $('#search-repo').val();
		if (!searchParams) {
			alert('Please enter keywords');
		} else {
			$.get('/repositories/search', { 'q': searchParams }, function (data) {
				if (!data) {
					alert('Something went wrong!!');
					return;
				}
				if (data.err) {
					$('#search-target').text(data.err);
				} else {
					$.get('/templates', function(templates) {
						$('#search-target').text('');
						var template = $(templates).filter('#search-result-template').html();
						data.forEach(function (item) {
						    $('#search-target').append(Mustache.render(template, item));
						});
					});
				}
			}).fail(function failure () {
				alert('Something went wrong!!');
			});
		}
	},

	importRep: function importRep (button) {
		var id = $(button).data('id'),
			name = $(button).data('name');
		$.post('/repositories/import', { 'rid': id, 'name': name }, function( data ) {
			$(button).text('Imported').attr('disabled', true);
			$('#import-msg').text(data.msg);
			setTimeout(function() {
				$('#import-msg').text('');
			}, 2000);
		}).fail(function () {
			alert('Import failed');
		});
	}
}