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
			$(button).attr('disabled', true);
		$.post('/repositories/import', { 'rid': id, 'name': name }, function( data ) {
			if (data.err) {
				$('#import-msg').text(data.err);
				$(button).text('Import Error');
			} else {
				$(button).text('Imported');
			}
			setTimeout(function() {
				$('#import-msg').text('');
			}, 2000);
		}).fail(function () {
			alert('Import failed');
		});
	}
}