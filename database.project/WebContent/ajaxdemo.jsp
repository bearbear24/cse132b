<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>

<script type="text/javascript">
$(document).ready(function() {
	$('#loadContent').click(function() {
		$.ajax({
			url: 'http://localhost:8090/database.project/ajaxresponse.jsp',
			method: 'POST',
			data: {
				'max': $('#max').val()
			},
			beforeSend: function() {
				$('#content').html("Calculating, please wait...");
			},
			dataType: 'text',
			success: function(data) {
				//var title = data['channel']['title'];
				$('#content').html(data);
			}
		});
	});
});
</script>

<title>Ajax Demo</title>
</head>
<body>

<div>
<input id="max" type="text">
<button id="loadContent" class="btn btn-primary">Ajax Load</button>
<div id="content"></div>
</div>

</body>
</html>