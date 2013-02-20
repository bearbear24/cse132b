<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/table.css">
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Concentration</title>
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
    <li >
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
    <li  class="active">
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
				DriverManager
						.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

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
							.prepareStatement("INSERT INTO concentration (topic, degree_name) VALUES (?, ?)");

					pstmt.setString(1, (request.getParameter("CONCENTRATION")));
					pstmt.setString(2, request.getParameter("DEGREENAME"));

					int rowCount = pstmt.executeUpdate();
					
					String[] course = request.getParameterValues("COURSE");
					Statement deleteStmt = conn.createStatement();
					for(String s :course) {
						PreparedStatement psPre = conn
								.prepareStatement("INSERT concentration_course (topic, number) VALUES (?, ?)");
						psPre.setString(1, (request.getParameter("CONCENTRATION")));
						psPre.setString(2, s);
						psPre.execute();
					}

					// Commit transaction
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
							.prepareStatement("UPDATE concentration SET degree_name=?  WHERE topic = ?");

					pstmt.setString(1, request.getParameter("DEGREENAME"));
					pstmt.setString(2, request.getParameter("CONCENTRATION"));

					int rowCount = pstmt.executeUpdate();
					
					String[] course = request.getParameterValues("COURSE");
					Statement deleteStmt = conn.createStatement();
					deleteStmt.execute("DELETE FROM CONCENTRATION_COURSE WHERE Topic ='" + request.getParameter("CONCENTRATION")+ "'");
					
					for(String s :course) {
						PreparedStatement psPre = conn
								.prepareStatement("INSERT concentration_course (topic, number) VALUES (?, ?)");
						psPre.setString(1, (request.getParameter("CONCENTRATION")));
						psPre.setString(2, s);
						psPre.execute();
					}

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
							.prepareStatement("DELETE FROM concentration WHERE topic = ?");

					pstmt.setString(1, request.getParameter("CONCENTRATION"));
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
				ResultSet rs = statement.executeQuery("SELECT degree_name, topic  FROM concentration");
				
			    Statement stat = conn.createStatement();
			    ResultSet rsDegree = stat.executeQuery("Select degree_name from master_degree");
				List<String> list = new ArrayList<String>();
				while(rsDegree.next())
					list.add(rsDegree.getString("degree_name"));	
				
				Statement course = conn.createStatement();
				ResultSet rsCourse = course.executeQuery("SELECT number from course");
				List<String> courseList = new ArrayList<String>();
				while(rsCourse.next())
					courseList.add(rsCourse.getString("number"));
				
		%>

		<table class="table table-hover table-bordered" >
			<tr>

				<th>Degree Name</th>
				<th>Concentration Topic</th>
				<th>Concentration Course</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="concentration.jsp" method="get">
					<input type="hidden" value="insert" name="action">
					<th>
					<select name="DEGREENAME">
					<%for(String s: list){ %>
					<option value="<%=s %>"><%=s%></option>
					<%} %>
					</select>
					</th>
					<th>
					<input type="text" name="CONCENTRATION">
					</th>
					<th><select name="COURSE" class="span2" multiple>
							<option>Empty</option>
							<%
								for(String degree : courseList) {
							%>
							<option value="<%=degree%>"><%=degree%></option>
							<%
								}
							%>
					</select></th>
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
				</form>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%

					while (rs.next()) {
						Statement selectedCourse = conn.createStatement();
						ResultSet rsSelected = selectedCourse.executeQuery("SELECT number from concentration_course where topic ='" + rs.getString("topic") +"'");
						HashMap<String, String> selectedCourseMap = new HashMap<String, String>();
						while(rsSelected.next()) {
							selectedCourseMap.put(rsSelected.getString("number"), "");
						}
					
			%>

			<tr>
				<form action="concentration.jsp" method="get">
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("topic")%>" name="CONCENTRATION">
					<%-- Get the ID --%>
					<th>
					<select name="DEGREENAME">
					<%for(String s: list){ %>
					<option value="<%=s %>" <%=s.equals(rs.getString("degree_name"))? "selected":"" %>><%=s%></option>
					<%} %>
					</select>
					</th>
					
					<th>
					<p name="CONCENTRATION"><%=rs.getString("topic")%></p>
					</th>
					<th><select name="COURSE" class="span2" multiple>
							<option>Empty</option>
							<%
								for(String degree : courseList) {
							%>
							<option value="<%=degree%>" <%=selectedCourseMap.containsKey(degree)? "selected":"" %>><%=degree%></option>
							<%
								}
							%>
					</select></th>

					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="concentration.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("topic")%>" name="CONCENTRATION"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
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
		</table>
	</div>
	</div>
</body>
</html>