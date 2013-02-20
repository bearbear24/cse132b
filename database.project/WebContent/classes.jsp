<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/table.css" >
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script src="js/table.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<div class="container-wide">
<h3>Data Entry Menu</h3>

<ul id="navigation" class="nav nav-pills inline">
	<li>
    <a href="menu.html">Home</a>
    </li>
    <li>
        <a href="courses.jsp">Courses</a>
    </li>
    <li  class="active">
        <a href="classes.jsp">Classes</a>
    </li>
    <li >
        <a href="students.jsp">Students</a>
    </li>
     <li>
        <a href="faculty.jsp">Faculty</a>
    </li>
    <li>
        <a href="courseenroll.jsp">Course Enrollment</a>
    </li>
     <li>
        <a href="pastcourse.jsp">Classes taken</a>
     </li>
         <li>
        <a href="committee.jsp">Thesis Committee</a>
    </li>
             <li>
        <a href="probation.jsp">Probation</a>
    </li>
    <li>
        <a href="reviewsession.jsp">Review session</a>
    </li>
    <li>
        <a href="degree.jsp">Degree requirement</a>
    </li>
</ul>
</div>
	<div class="container-wide">
	<div id="form">

		<%-- Set the scripting language to Java and --%>
		<%-- Import the java.sql package --%>
		<%@ page language="java" import="java.sql.*"%>
		<%@ page import="java.util.*" %>

		<%-- -------- Open Connection Code -------- --%>
		<%
			try {
				DriverManager.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

				Connection conn = DriverManager.getConnection(
						"jdbc:sqlserver://localhost:1433;databaseName=cse132b",
						"sa", "wangchunyan");
		%>

		<%-- -------- INSERT Code -------- --%>
		<%
			String action = request.getParameter("action");
				// Check if an insertion is requested
				if (action != null && action.equals("insert")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// INSERT the student attributes INTO the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("INSERT INTO class (number, quarter_year, title) VALUES (?, ?, ?)");
					String quatYear = request.getParameter("QUARTER") + " "+ request.getParameter("YEAR");

					pstmt.setString(1, (request.getParameter("NUMBER")));
					pstmt.setString(2, quatYear);
					pstmt.setString(3, request.getParameter("TITLE"));

					int rowCount = pstmt.executeUpdate();

					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<%--section insert code --%>
		<%
		if(action!=null &&action.equals("sectioninsert")) {
			conn.setAutoCommit(false);

			// Create the prepared statement and use it to
			// INSERT the student attributes INTO the Student table.
			PreparedStatement pstmt = conn
					.prepareStatement("INSERT INTO section VALUES (?, ?, ?, ?, ?)");


			pstmt.setString(1, (request.getParameter("NUMBER")));
			pstmt.setString(2, request.getParameter("SECTIONID"));
			pstmt.setInt(3, Integer.parseInt(request.getParameter("LIMIT")));
			pstmt.setString(4, request.getParameter("QUARTERYEAR"));
			pstmt.setString(5, request.getParameter("INSTRUCTOR"));

			int rowCount = pstmt.executeUpdate();

			// Commit transaction
			conn.commit();
			conn.setAutoCommit(true);
		}
		%>
		
		<%-- meeting insert --%>
		<%
		if(action!=null &&action.equals("meetinginsert")) {
			conn.setAutoCommit(false);

			// Create the prepared statement and use it to
			// INSERT the student attributes INTO the Student table.
			String type= request.getParameter("type");
			String sql="";
			if(type.equals("DI")) {
				sql = "INSERT INTO DISCUSSION(section_id, start_time,day_of_week,end_date,place, mandatory, start_date) VALUES(?,?,?,?,?,?,?)";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, (request.getParameter("SECTIONID")));
				pstmt.setString(2, request.getParameter("time"));
				pstmt.setString(3, request.getParameter("day"));
				pstmt.setString(4, request.getParameter("enddate"));
				pstmt.setString(5, request.getParameter("place"));
				pstmt.setBoolean(6, new Boolean(request.getParameter("mand")));
				pstmt.setString(7, request.getParameter("startdate"));
				int rowCount = pstmt.executeUpdate();
			}
			else {
				sql ="INSERT INTO WEEKLY_MEETING(section_id, start_time, day_of_week,end_date,place,start_date,type) VALUES(?,?,?,?,?,?,?)";
				PreparedStatement pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, (request.getParameter("SECTIONID")));
				pstmt.setString(2, request.getParameter("time"));
				pstmt.setString(3, request.getParameter("day"));
				pstmt.setString(4, request.getParameter("enddate"));
				pstmt.setString(5, request.getParameter("place"));
				pstmt.setString(6, request.getParameter("startdate"));
				pstmt.setString(7, request.getParameter("type"));
				int rowCount = pstmt.executeUpdate();
			}
		

			

			// Commit transaction
			conn.commit();
			conn.setAutoCommit(true);
		}
		%>
		
		<%--section update code--%>
		<%
		//check if an update is requested
		if(action != null && action.equals("sectionupdate")) {
			conn.setAutoCommit(false);
			PreparedStatement pstmt = conn.prepareStatement("UPDATE section SET number=?, quarter_year=?,enroll_limit=?, faculty_name=? WHERE section_id=?");
			pstmt.setString(1, request.getParameter("NUMBER"));
			pstmt.setString(2, request.getParameter("QUARTERYEAR"));
			pstmt.setInt(3, Integer.parseInt(request.getParameter("LIMIT")));
			pstmt.setString(4, request.getParameter("INSTRUCTOR"));
			pstmt.setString(5, request.getParameter("SECTIONID"));
			int rowCount = pstmt.executeUpdate();
			conn.commit();
			conn.setAutoCommit(true);
		}
		
		%>
		<%--weekly meeting update --%>
		<%
			if(action != null && action.equals("weekupdate")) {
				conn.setAutoCommit(false);
				PreparedStatement pstmt = conn.prepareStatement("UPDATE weekly_meeting SET start_date=?, end_date=? ,place=? WHERE (section_id=? and start_time=? and day_of_week=?)");
				pstmt.setString(1, request.getParameter("startdate"));
				pstmt.setString(2, request.getParameter("enddate"));
				pstmt.setString(3, request.getParameter("place"));
				pstmt.setString(4, request.getParameter("SECTIONID"));
				pstmt.setString(5, request.getParameter("time"));
				pstmt.setString(6, request.getParameter("day"));
				int rowCount = pstmt.executeUpdate();
				conn.commit();
				conn.setAutoCommit(true);
			}
		%>
		<%--weekly meeting delete code --%>
		<%
			if(action != null && action.equals("weekdelete")) {
				conn.setAutoCommit(false);
				PreparedStatement pstmt = conn.prepareStatement("DELETE FROM weekly_meeting WHERE (section_id=? and start_time=? and day_of_week=?)");
				pstmt.setString(1, request.getParameter("SECTIONID"));
				pstmt.setString(2, request.getParameter("time"));
				pstmt.setString(3, request.getParameter("day"));
				int rowCount = pstmt.executeUpdate();
				conn.commit();
				conn.setAutoCommit(true);
			}
		%>
		
		<%--discussion update --%>
		<%
			if(action != null && action.equals("discussionupdate")) {
				conn.setAutoCommit(false);
				PreparedStatement pstmt = conn.prepareStatement("UPDATE discussion SET mandatory =?,start_date=?, end_date=? ,place=? WHERE (section_id=? and start_time=? and day_of_week=?)");
				pstmt.setBoolean(1, new Boolean(request.getParameter("mand")));
				pstmt.setString(2, request.getParameter("startdate"));
				pstmt.setString(3, request.getParameter("enddate"));
				pstmt.setString(4, request.getParameter("place"));
				pstmt.setString(5, request.getParameter("SECTIONID"));
				pstmt.setString(6, request.getParameter("time"));
				pstmt.setString(7, request.getParameter("day"));
				int rowCount = pstmt.executeUpdate();
				conn.commit();
				conn.setAutoCommit(true);
			}
		%>
		<%--discussion delete code --%>
		<%
			if(action != null && action.equals("discussiondelete")) {
				conn.setAutoCommit(false);
				PreparedStatement pstmt = conn.prepareStatement("DELETE FROM discussion WHERE (section_id=? and start_time=? and day_of_week=?)");
				pstmt.setString(1, request.getParameter("SECTIONID"));
				pstmt.setString(2, request.getParameter("time"));
				pstmt.setString(3, request.getParameter("day"));
				int rowCount = pstmt.executeUpdate();
				conn.commit();
				conn.setAutoCommit(true);
			}
		%>
		

		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.equals("update")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE class SET title=? where (number =? and quarter_year=?)");

					pstmt.setString(1, request.getParameter("TITLE"));
					pstmt.setString(2, request.getParameter("NUMBER"));
					pstmt.setString(3, request.getParameter("QUARTERYEAR"));

					int rowCount = pstmt.executeUpdate();

					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<%-- section delete --%>
		<%
			if(action !=null && action.equals("sectiondelete")) {
				conn.setAutoCommit(false);

				// Create the prepared statement and use it to
				// DELETE the student FROM the Student table.
				PreparedStatement pstmt = conn
						.prepareStatement("DELETE FROM section WHERE section_id=?");

				pstmt.setString(1, request.getParameter("SECTIONID"));

				int rowCount = pstmt.executeUpdate();

				// Commit transaction
				conn.commit();
				conn.setAutoCommit(true);
			}
		%>

		<%-- -------- DELETE Code -------- --%>
		<%
			// Check if a delete is requested
				if (action != null && action.equals("delete")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// DELETE the student FROM the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("DELETE FROM class WHERE (number = ? and quarter_year=?)");

					pstmt.setString(1, request.getParameter("NUMBER"));
					pstmt.setString(2, request.getParameter("QUARTERYEAR"));
					int rowCount = pstmt.executeUpdate();

					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>

		<%-- -------- SELECT Statement Code -------- --%>
		<%
			// Create the statement
				Statement statement = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				ResultSet rs = statement.executeQuery("SELECT number,quarter_year,title FROM class");
			    Statement stat = conn.createStatement();
				ResultSet rsDegree = stat.executeQuery("Select number from course");
				List<String> list = new ArrayList<String>();
				while(rsDegree.next())
					list.add(rsDegree.getString("number"));	
				
				Statement facultyStmt = conn.createStatement();
				ResultSet facultySet = facultyStmt.executeQuery("SELECT FACULTY_name from faculty");
				List<String> fList = new ArrayList<String>();
				while(facultySet.next()) {
				    fList.add(facultySet.getString("faculty_name"));
				}
		%>
		<form id="teacher">
		<%for(String s: fList) {%>
		<input type="hidden" value=<%=s %>>
		<%} %>
		</form>

		<table class="table table-hover table-bordered table-condensed" >
			<tr>

				<th>Course</th>
				<th>Quarter Year</th>
				<th>Title</th>
				<th colspan="3">Action</th>
			</tr>
			<tr>
				<form action="classes.jsp" method="get">
					<input type="hidden" value="insert" name="action">
					
					<td>
					<select name = "NUMBER">
					<%for(String s : list) {%>
					<option value=<%=s%>><%=s %></option>
					<%} %>
					</select>
					</td>
					<td>
					<input type="text" value="" name="YEAR" size="15">
					<select name="QUARTER" class="span2">
					<option value ="SPRING">Spring</option>
					<option value="SUMMER">Summer</option>
					<option value ="FALL"> Fall</option>
					<option value="WINTER">Winter</option>
					</select>
					</td>
					<td><input type="text" value="" name="TITLE" size="15"></td>
					
					<td colspan="3">
					<input class="btn btn-info" type="submit" value="Insert">
					</td>
				</form>
			</tr>
			</table>

			<%-- -------- Iteration Code -------- --%>
			<%
					while (rs.next()) {
						Statement stmtSec = conn.createStatement();
						ResultSet section = stmtSec.executeQuery("SELECT section_id, enroll_limit, faculty_name from section where"+
								" (number ='" + rs.getString("number")+"'" + "and quarter_year='" + rs.getString("quarter_year")+ "')");
						
								%>
			<div class="classdiv">
			<% String str[]= rs.getString("quarter_year").split(" "); 
			System.out.print(rs.getString("number") +"_"+str[0] +"_"+ str[1]);%>
			<table class="table table-hover table-bordered table-condensed"  id="<%=rs.getString("number") +"_"+str[0] +"_"+ str[1]%>" style="text-align:center">
			<tr>
				<th>Course</th>
				<th>Quarter Year</th>
				<th>Title</th>
				<th colspan="3">Action</th>
			</tr>

			<tr>
				<form action="classes.jsp" method="get">
					<input type="hidden" value="update" name="action"> 
					<input type="hidden" value="<%=rs.getString("number")%>" name="NUMBER">
					<input type="hidden" value="<%=rs.getString("quarter_year") %>" name="QUARTERYEAR">
					<%-- Get the ID --%>
					<td name="NUMBER"><%=rs.getString("number") %> 
					</td>
					<td name="QUARTERYEAR"><%=rs.getString("quarter_year") %>
					</td>
					<td><input type="text"  value="<%=rs.getString("title") %>" name="TITLE" size="15"></td>
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="classes.jsp" method="get">
				<input type="hidden" value="delete" name="action"> 
					<input type="hidden" value="<%=rs.getString("number")%>" name="NUMBER"  id="number">
						<input type="hidden" value="<%=rs.getString("quarter_year") %>" name="QUARTERYEAR" id="quarteryear">
					<td><input  class="btn btn-info" type="submit" value="Delete"></td>
					
				</form>
				<td><input class="btn btn-info" type="submit" value = "AddSection" id="<%="add" +"_" +rs.getString("number") + "_" +str[0] +"_" +str[1] %>"></td>
			</tr>
			</table>
			<%while(section.next()) {
			Statement stmtWeekMeet = conn.createStatement();
			ResultSet weekMeeting = stmtWeekMeet.executeQuery("SELECT *from weekly_meeting where section_id= '"+ section.getString("section_id")+ "'");
			
			Statement stmtDiscussion = conn.createStatement();
			ResultSet discussion = stmtDiscussion.executeQuery("SELECT* FROM DISCUSSION where section_id='" + section.getString("section_id") + "'");
				%>
			<table class="table table-hover table-bordered table-condensed"  id="<%=section.getString("section_id") %>">
		<tr>
			<th>Section ID</th> 
			<th>Meet type</th> 
			<th>StartDate</th>
			<th>EndDate </th>
			<th>Day</th>
			<th>Time</th> 
			<th>Place</th>
			<th>Mandatory</th>
			<th>Instructor</th>
			<th>Limit</th>
			<th  colspan="3">Action</th></tr>
			<tr> 
			<form  action="classes.jsp" method="get">
			<input type="hidden" value="sectionupdate" name="action"> 
			<td><input type="text" disabled=true class="input-small" name="SECTIONID" style="width: 50px" value="<%=section.getString("section_id") %>"></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>
			<select class="span2" name="INSTRUCTOR">
			<%for(String s: fList) {%>
			<option value="<%=s%>" <%=s.equals(section.getString("faculty_name"))? "selected":"" %>><%=s%></option>
			<% }%>
			</select>
			</td>
			<td><input type="text" name="LIMIT" style="width: 20px" value=<%=section.getString("enroll_limit") %>></td>
			<input type="hidden" value="<%=section.getString("section_id")%>" name="SECTIONID">
			<input type="hidden" value="<%=rs.getString("number")%>" name="NUMBER">
			<input type="hidden" value="<%=rs.getString("quarter_year") %>" name="QUARTERYEAR" >
			<td><input type="submit" class="btn btn-info"value="Update" size="15"></td>
			</form>
			
			<form>
			<input type="hidden" value="sectiondelete" name="action">
			<input type="hidden" value="<%=section.getString("section_id")%>" name="SECTIONID">
			
			<td><input type ="submit" value="Delete" class="btn btn-info"></td>
			</form>
			<td><input type="submit" class="btn btn-info" value="AddMeet" size="10" id="<%="M_" + section.getString("section_id")%>"></td>
			</tr>
			<% while(weekMeeting.next()) {%>
			<tr>
			<td></td>
			<form action="classes.jsp" method="get">
			<input type="hidden" value = "weekupdate" name="action">
			<td>
			<input type="text" disabled = true style="width: 20px" value="<%=weekMeeting.getString("type") %>">
			</td>
			<td>
			<input type="text" name= "startdate" value="<%=weekMeeting.getString("start_date")%>" style="width: 60px"> 
			</td>
			<td>
			<input type="text" name= "enddate" value="<%=weekMeeting.getString("end_date")%>" style="width: 60px"> 
			</td>
			<td>
			<input type="text" disabled = true  style="width: 30px" value="<%=weekMeeting.getString("day_of_week")%>" name="day" >
			</td>
			<td>
			<input type="text"  disabled = true name="time" value="<%=weekMeeting.getString("start_time")%>" style="width: 50px">
			</td>
			<td>
			<input type="text" name ="place" value="<%=weekMeeting.getString("place")%>" style="width: 50px">
			</td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<input type="hidden"  value = "<%=section.getString("section_id") %>" name="SECTIONID">
			<input type="hidden"  value = "<%=weekMeeting.getString("day_of_week") %>" name="day">
			<input type="hidden"  value = "<%=weekMeeting.getString("start_time") %>" name="time">
			<td><input type="submit" class="btn btn-info" value="Update" size="15"></td>
			</form >
			<form action="classes.jsp" method="get">
			<input type="hidden" value = "weekdelete" name="action">
			<input type="hidden"  value = "<%=section.getString("section_id") %>" name="SECTIONID">
			<input type="hidden"  value = "<%=weekMeeting.getString("day_of_week") %>" name="day">
			<input type="hidden"  value = "<%=weekMeeting.getString("start_time") %>" name="time">
			<td><input type="submit" class="btn btn-info" value="Delete" size="15"></td>
			</form>
			</tr>;
			<%} %>
			<%while(discussion.next()) {%>
			<tr>
			<td></td>
			<form action="classes.jsp" method="get">
			<td><input type="text" disabled = true style="width: 20px" value="DI"></td>
			<td>
			<input type="text" name= "startdate" value="<%=discussion.getString("start_date") %>" style="width: 60px"> 
			</td>
			<td>
			<input type="text" name= "enddate" value="<%=discussion.getString("end_date") %>" style="width: 60px"> 
			</td>
			<td>
			<input type="text" disabled = true  style="width:30px" value=<%=discussion.getString("day_of_week")%> name="day" >
			</td>
			<td>
			<input type="text" name="time"   disabled = true value="<%=discussion.getString("start_time")%>" style="width: 50px">
			</td>
			<td>
			<input type="text" name ="place" value="<%=discussion.getString("place")%>" style="width: 50px">
			</td>		
			<td><input type="checkbox" name="mand"  <%=(discussion.getBoolean("mandatory")==true)? "checked":"" %> value="true"> </td>
			<td></td>
			<td></td>
			<td></td>
			<input type="hidden" value = "discussionupdate" name="action">
			<input type="hidden"  value = "<%=section.getString("section_id") %>" name="SECTIONID">
			<input type="hidden"  value = "<%=discussion.getString("day_of_week") %>" name="day">
			<input type="hidden"  value = "<%=discussion.getString("start_time") %>" name="time">
			<td><input type="submit" class="btn btn-info" value="Update" size="15"></td>
			</form>
			<form  action="classes.jsp" method="get">
						<input type="hidden" value = "discussiondelete" name="action">
			<input type="hidden"  value = "<%=section.getString("section_id") %>" name="SECTIONID">
			<input type="hidden"  value = "<%=discussion.getString("day_of_week") %>" name="day">
			<input type="hidden"  value = "<%=discussion.getString("start_time") %>" name="time">
			<td><input type="submit" class="btn btn-info" value="Delete" size="15"></td>
			</form>
			</tr>
			<%} %>
		</table>
		<%} %>	
		</div>	
		<div class="inner"></div>	
			<%
					}
			%>

			<%-- -------- Close Connection Code -------- --%>
			<%
				    rsDegree.close();
					stat.close();
					// Close the ResultSet
					rs.close();

					// Close the Statement
					statement.close();

					// Close the Connection
					conn.close();
				} catch (SQLException sqle) {
					out.println(sqle.getMessage());
				} catch (Exception e) {
					out.println(e.getMessage());
				}
			%>
		
	</div>
	</div>
</body>
</html>