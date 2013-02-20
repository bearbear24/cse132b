<html>
<head>
<link rel="stylesheet" href="css/table.css">
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>
<script
	src="http://ajax.googleapis.com/ajax/libs/jquery/1.8.0/jquery.min.js"></script>
<script src="js/table.js"></script>
</head>
<body>

	<div class="container-wide">
		<h3>Data Entry Menu</h3>

		<ul id="navigation" class="nav nav-pills inline">
			<li><a href="menu.html">Home</a></li>
			<li><a href="courses.jsp">Courses</a></li>
			<li><a href="classes.jsp">Classes</a></li>
			<li><a href="students.jsp">Students</a></li>
			<li><a href="faculty.jsp">Faculty</a></li>
			<li><a href="courseenroll.jsp">Course Enrollment</a></li>
			<li><a href="pastcourse.jsp">Classes taken</a></li>
			<li><a href="committee.jsp">Thesis Committee</a></li>
			<li><a href="probation.jsp">Probation</a></li>
			<li class="active"><a href="reviewsession.jsp">Review
					session</a></li>
			<li><a href="degree.jsp">Degree requirement</a></li>
		</ul>
	</div>
	<div class="container-wide">
		<div id="form">

			<%-- Set the scripting language to Java and --%>
			<%-- Import the java.sql package --%>
			<%@ page language="java" import="java.sql.*"%>
			<%@ page import="java.util.*"%>
			<%@ page import="java.util.Date"%>

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
								.prepareStatement("INSERT INTO review_session VALUES (?, ?, ?)");
						String date = request.getParameter("date");
						String time = request.getParameter("time");
						date = date + " " + time;

						pstmt.setString(1, (request.getParameter("SECTIONID")));
						pstmt.setString(2, date);
						pstmt.setString(3, request.getParameter("place"));
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
								.prepareStatement("UPDATE review_session SET place = ?" + " WHERE (section_id = ? and date_time=?)");

						pstmt.setString(3, request.getParameter("datetime"));
						pstmt.setString(2, request.getParameter("SECTIONID"));
						pstmt.setString(1, request.getParameter("place"));

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
								.prepareStatement("DELETE FROM review_session WHERE (section_id=? and date_time= ?)");

						pstmt.setString(1, request.getParameter("SECTIONID"));
						pstmt.setString(2, request.getParameter("datetime"));
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
					ResultSet rs = statement
							.executeQuery("SELECT * FROM review_session");
					Statement stat = conn.createStatement();
					ResultSet section = stat
							.executeQuery("select section_id, number from section");
					List<String> sectionList = new ArrayList<String>();
					List<String> sectionNumberList = new ArrayList<String>();

					int size = 0;
					while (section.next()) {
						size++;
						sectionList.add(section.getString("section_id"));
						sectionNumberList.add(section.getString("number"));
					}
					System.out.print(size);
					HashMap<String, String> sectionMap = new HashMap<String, String>();
					for (int i = 0; i < size; i++) {
						sectionMap
								.put(sectionList.get(i), sectionNumberList.get(i));
					}
			%>

			<table class="table table-hover table-bordered">
				<tr>
					<th>Section ID</th>
					<th>Date</th>
					<th>Time</th>
					<th>place</th>
					<th colspan="2">Action</th>
				</tr>
				<tr>
					<form action="reviewsession.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><select name="SECTIONID" class="span3" id="section">
								<%
									int len = sectionList.size();
										for (int i = 0; i < len; i++) {
											String id = sectionList.get(i);
											String number = sectionNumberList.get(i);
											number = "(" + number + ")";
								%>
								<option value="<%=id%>">
									<%=(id + number)%></option>
								<%
									}
								%>
						</select></th>
						<th><input type="text" value="" name="date" size="15"></th>
						<th><input type="text" value="" name="time" size="15"></th>
						<th><input type="text" value="" name="place" size=15></th>
						<th colspan="2"><input type="submit" class="btn btn-info"
							value="Insert"></th>
					</form>
				</tr>

				<%-- -------- Iteration Code -------- --%>
				<%
				System.out.println("before");
					while (rs.next()) {
						System.out.println("inner");
				%>

				<tr>
					<form action="reviewsession.jsp" method="get">
						<%
							String datetime = rs.getString("date_time");
						System.out.print("datetime = " + datetime.split("\\.")[0]);
							String display = datetime.split("\\.")[0]; 
							System.out.print("time display: " + display);
						%>
						<input type="hidden" value="update" name="action"> <input
							type="hidden" value="<%=rs.getString("section_id")%>"
							name="SECTIONID"> <input type="hidden"
							value="<%=rs.getString("date_time")%>" name="datetime">
						<%-- Get the ID --%>
						<td><p>
								<%=(rs.getString("section_id") + "("
							+ sectionMap.get(rs.getString("section_id")) + ")")%></p>
						<td colspan="2"><p>
								<%=display%>
							<p></td>
						<td><input type="text" value="<%=rs.getString("place")%>"
							name="place"></td>
						<td><input class="btn btn-info" type="submit" value="Update"></td>
					</form>

					<form action="reviewsession.jsp" method="get">
						<input type="hidden" value="delete" name="action"> <input
							type="hidden" value="<%=rs.getString("section_id")%>"
							name="SECTIONID"> <input type="hidden"
							value="<%=rs.getString("date_time")%>" name="datetime">
						<%-- Button --%>
						<td><input class="btn btn-info" class="btn btn-info"
							type="submit" value="Delete"></td>
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
