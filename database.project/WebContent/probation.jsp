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
             <li class="active">
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
							.prepareStatement("INSERT INTO dbo.student_probation (s_id, start_quarter_year, reason) VALUES (?, ?, ?)");

					pstmt.setString(1, (request.getParameter("SID")));
					pstmt.setString(2, request.getParameter("STARTQUARTER"));
					pstmt.setString(3, request.getParameter("REASON"));
					int rowCount = pstmt.executeUpdate();
					PreparedStatement pstmt2 = conn
							.prepareStatement("INSERT INTO dbo.probation_time (s_id, start_quarter_year, end_quarter_year) VALUES (?, ?, ?)");

					pstmt2.setString(1, (request.getParameter("SID")));
					pstmt2.setString(2, request.getParameter("STARTQUARTER"));
					pstmt2.setString(3, request.getParameter("ENDQUARTER"));
					pstmt2.execute();
					// Commit transaction
					
					String end=request.getParameter("ENDQUARTER");
// 					if(end=="current")
// 					{
// 						PreparedStatement pstmt3 = conn
// 							.prepareStatement("UPDATE student SET probation_status = true WHERE s_id = ?");

// 						pstmt3.setString(1, (request.getParameter("SID")));
// 						pstmt3.execute();
// 					}
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
							.prepareStatement("UPDATE student_probation SET reason = ? "
									+ "WHERE s_id = ? AND start_quarter_year=? ");

					pstmt.setString(2, (request.getParameter("SID")));
					pstmt.setString(1, request.getParameter("REASON"));
					pstmt.setString(3, request.getParameter("STARTQUARTER"));
					int rowCount = pstmt.executeUpdate();
					PreparedStatement pstmt2 = conn
							.prepareStatement("UPDATE probation_time SET end_quarter_year = ? "
									+ "WHERE s_id = ? AND start_quarter_year=? ");

					pstmt2.setString(2, (request.getParameter("SID")));
					pstmt2.setString(1, request.getParameter("ENDQUARTER"));
					pstmt2.setString(3, request.getParameter("STARTQUARTER"));

					pstmt2.executeUpdate();
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
							.prepareStatement("DELETE FROM student_probation WHERE s_id = ? AND start_quarter_year= ?");

					pstmt.setString(1, request.getParameter("SID"));
					pstmt.setString(2, request.getParameter("STARTQUARTER"));
					int rowCount = pstmt.executeUpdate();
					PreparedStatement pstmt2 = conn
							.prepareStatement("DELETE FROM probation_time WHERE s_id = ? AND start_quarter_year= ?");

					pstmt2.setString(1, request.getParameter("SID"));
					pstmt2.setString(2, request.getParameter("STARTQUARTER"));
					pstmt2.execute();
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
				ResultSet rs = statement.executeQuery("SELECT student_probation.s_id AS s_id, student_probation.start_quarter_year AS start_quarter_year, end_quarter_year, reason FROM student_probation LEFT OUTER JOIN probation_time ON student_probation.s_id=probation_time.s_id AND student_probation.start_quarter_year=probation_time.start_quarter_year");	

		%>

		<table class="table table-hover table-bordered" >
			<tr>

				<th>Student Id</th>
				<th>Start Quarter</th>
				<th>End Quarter</th>
				<th>Reason</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="probation.jsp" method="get">
					<input type="hidden" value="insert" name="action">
					<th><input type="text" class="input-small" value="" name="SID" size="10"></th>
					<th><select name="STARTQUARTER" class="span2">
						<option value="2013 Winter">2013 Winter</option>
						<%
							for(int i=2012;i>=2000;i--)
							{
								String year=Integer.toString(i);
							
						%>
							<option value="<%=year%> Fall"><%=year%> Fall</option>
							<option value="<%=year%> Winter"><%=year%> Winter</option>
							<option value="<%=year%> Spring"><%=year%> Spring</option>
							<%
								}
							%>
					</select></th>
					<th><select name="ENDQUARTER" class="span2">
						<option value="current">current</option>
						<%
							for(int i=2012;i>=2000;i--)
							{
								String year=Integer.toString(i);
							
						%>
							<option value="<%=year%> Fall"><%=year%> Fall</option>
							<option value="<%=year%> Winter"><%=year%> Winter</option>
							<option value="<%=year%> Spring"><%=year%> Spring</option>
							<%
								}
							%>
					</select></th>
					<th><textarea name="REASON" rows="3"></textarea></textarea></th>
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
				</form>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%

					while (rs.next()) {
			%>

			<tr>
				<form action="probation.jsp" method="get">
					<input class="input-small" type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("s_id")%>" name="SID">
						<input class="input-small" type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("start_quarter_year")%>" name="STARTQUARTER">
					<%-- Get the ID --%>
					<td>
						<p name="SID"><%=rs.getString("s_id")%></p>
					</td>
					
					
					<%-- Get the ID --%>
					<td>
						<p name="STARTQUARTER"><%=rs.getString("start_quarter_year")%></p>
					</td>
					<% String dataEquarter = rs.getString("end_quarter_year");%> 
					<th><select name="ENDQUARTER" class="span2">
						<option value="current" <%=dataEquarter.equals("current") ? "selected" : ""%>>current</option>
						<%
						
							for(int i=2012;i>=2000;i--)
							{
								String year=Integer.toString(i);
							
						%>
							<option value="<%=year%> Fall" <%=dataEquarter.equals(year+" Fall") ? "selected" : ""%>><%=year%> Fall</option>
							<option value="<%=year%> Winter" <%=dataEquarter.equals(year+" Winter") ? "selected" : ""%>><%=year%> Winter</option>
							<option value="<%=year%> Spring" <%=dataEquarter.equals(year+" Spring") ? "selected" : ""%>><%=year%> Spring</option>
							<%
								}
							%>
					</select></th>

					<th><textarea name="REASON" rows="3"><%=rs.getString("reason") %></textarea></textarea></th>

					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="probation.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("s_id")%>" name="SID"> 
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("start_quarter_year")%>" name="STARTQUARTER"> 
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
