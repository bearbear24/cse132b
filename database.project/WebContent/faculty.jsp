<html>
<head>
<link rel="stylesheet" href="css/table.css" >
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>

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
     <li class ="active">
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
							.prepareStatement("INSERT INTO dbo.faculty (faculty_name, title, dept_name) VALUES (?, ?, ?)");

					pstmt.setString(1, (request.getParameter("NAME")));
					pstmt.setString(2, request.getParameter("TITLE"));
					pstmt.setString(3, request.getParameter("DEPARTMENT"));
					int rowCount = pstmt.executeUpdate();

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
							.prepareStatement("UPDATE faculty SET title = ?, dept_name = ? "
									+ "WHERE faculty_name = ?");

					pstmt.setString(3, (request.getParameter("NAME")));
					pstmt.setString(1, request.getParameter("TITLE"));
					pstmt.setString(2, request.getParameter("DEPARTMENT"));

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
							.prepareStatement("DELETE FROM faculty WHERE faculty_name = ?");

					pstmt.setString(1, request.getParameter("NAME"));
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
				ResultSet rs = statement.executeQuery("SELECT faculty_name,title,dept_name FROM faculty");	
			    Statement stat = conn.createStatement();
				ResultSet rsDept = stat.executeQuery("Select dept_name from department");
				List<String> depList = new ArrayList<String>();
				while(rsDept.next())
					depList.add(rsDept.getString("dept_name"));
		%>

		<table class="table table-hover table-bordered" >
			<tr>

				<th>Name</th>
				<th>Title</th>
				<th>Department</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="faculty.jsp" method="get">
					<input type="hidden" value="insert" name="action">
					<th><input type="text"  value="" name="NAME" size="50"></th>
					<th><select name="TITLE" class="span3">
							<option value="Professor">Professor</option>
							<option value="Associate Professor">Associate Professor</option>
							<option value="Assistant Professor">Assistant Professor</option>
							<option value="Lecturer">Lecturer</option>
					</select></th>
					<th><select name="DEPARTMENT" class="span2">
							<%
								for(String dept : depList) {
							%>
							<option value="<%=dept%>"><%=dept%></option>
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
			%>

			<tr>
				<form action="faculty.jsp" method="get">
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("faculty_name")%>" name="NAME">
					<%-- Get the ID --%>
					<td>
						<p name="NAME"><%=rs.getString("faculty_name")%></p>
					</td>

					<%-- Get the COLLEGE --%>

					<td>
					<%
							   String dataTitle = rs.getString("title");%>
					<select name="TITLE" class="span3">
						<option value="Professor" <%=dataTitle.equals("Professor") ? "selected" : ""%> >Professor</option>
						<option value="Associate Professor" <%=dataTitle.equals("Associate Professor") ? "selected" : ""%> >Associate Professor</option>
						<option value="Assistant Professor" <%=dataTitle.equals("Assistant Professor") ? "selected" : ""%> >Assistant Professor</option>
						<option value="Lecturer" <%=dataTitle.equals("Lecturer") ? "selected" : ""%> >Lecturer</option>
					</select>
					</td>

					<td>	<select name="DEPARTMENT" class="span2">
							<%
							   String dataDept = rs.getString("dept_name");
								for(String dept : depList) {
							%>
							<option value="<%=dept%>" <%=dataDept.equals(dept) ? "selected" : ""%> ><%=dept%></option>
							<%
								}
							%>
					</select></td>

					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="faculty.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("faculty_name")%>" name="NAME"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
			<%
					}
			%>

			<%-- -------- Close Connection Code -------- --%>
			<%

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
