$(document).ready(function(){
	var teacher =[];
	$('#teacher input' ).each(function(i) {
	    teacher[i] = $(this).val();
	});
	var len ="";
	$.each(teacher, function(key,val){
		len = len + "<option value ='" + val +"'>" + val +"</option>"; 
	});
	

	$('input[id^="add_"]').each(function(){
		var id = $(this).attr('id');
		var arr= id.split('_');
		var tableId =arr[1]+ "_" + arr[2]+"_"+arr[3];
		var quarteryear=arr[2] + " " + arr[3]; 
		var number = arr[1];
		var insertTr = 
			"<table class='table table-hover table-bordered table-condensed' >"+
		"<tr>"+
			"<th>Section ID</th>" +
			"<th>Meeting type</th>" +
			"<th>Day</th>"+
			"<th>Time</th>" +
			"<th>Place</th>"+
			"<th>Mandatory</th>"+
			"<th>Instructor</th>"+
			"<th>Limit</th>"+
			"<th colspan='2'>Action</th></tr>"+
			"<tr>" +
			"<form  action='classes.jsp' method='get'>"+
			"<input type='hidden' value='sectioninsert' name='action'>"+
			"<td><input type='text' class='input-small' name='SECTIONID' size='15'></td>"+
			"<td></td>"+
			"<td></td>"+
			"<td></td>"+
			"<td></td>"+
			"<td></td>"+
		    "<td>"+
			"<select class='span2' name='INSTRUCTOR'>"+ len +
			"</select>"+
			"</td>"+
			"<td><input type='text' class='input-small' name='LIMIT' size='15'></td>"+
	        "<input type='hidden' value='"+number+"' name='NUMBER'>"+
			"<input type='hidden' value='"+ quarteryear +"'name='QUARTERYEAR'>"+
			"<td><input type='submit' class='btn btn-info' value='Insert' size='15'></td>" +
			"</form>"+
			"<form  action='classes.jsp' method='get'>"+
			"<td><input type='submit' class='btn btn-info' value='Delete' size='15'></td>" +
			"</form>"+
			"</tr>";
		"</table>";
	
		$(this).click(function() {
			$("#" + tableId).after(insertTr);
	});
	});	
	
	$('input[id^="M_"]').each(function(){
		var id = $(this).attr('id');
		var arr= id.split('_');
		var tableId =arr[1];
		var insertTr = 
			"<tr>"+
			"<td></td>"+
			"<form action='classes.jsp' method='get'>"+
			"<input type='hidden' name='SECTIONID' value='"+tableId + "'"+ ">"+
			"<td>"+
			"<select name='type' class = 'span1'>"+
			"<option value='LE'>LE</option>"+
			"<option value='DI'>DI</option>"+
			"<option value='LAB'>LAB</option>"+
			"</select>"+
			"</td>"+
			"<td>"+
			"<input type='text' name= 'startdate' style='width: 60px'>" +
			"</td>"+
			"<td>"+
			"<input type='text' name= 'enddate' style='width: 60px'>" +
			"</td>"+
			"<td>"+
			"<select name='day' style='width: 70px'>"+
			"<option value='mon'>MON</option>"+
			"<option value='TUE'>TUE</option>"+
			"<option value='WED'>WED</option>"+
			"<option value='THU'>THU</option>"+
			"<option value='FRI'>FRI</option>"+
			"</select>"+
			"</td>"+
			"<td>"+
			"<input type='text' name='time' style='width: 50px'>"+
			"</td>"+
			"<td>"+
			"<input type='text' name ='place' style='width: 50px'>"+
			"</td>"+
			"<td><input type='checkbox' name='mand' value='true'></td>"+
			"<td></td>"+
			"<td></td>"+
			"<td></td>"+
			"<input type='hidden' value='meetinginsert' name='action'>"+
			"<td><input type='submit' class='btn btn-info' value='Insert' size='15'></td>"+
			"<form action='classes.jsp' method='get'>"+
			"<td><input type='submit' class='btn btn-info' value='Delete' size='15'></td>"+
			"</form>"+
			"</tr>";
	
		$(this).click(function() {
			$("#" + tableId).append(insertTr);
	});
	});	
});
