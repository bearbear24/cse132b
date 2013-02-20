<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link rel="stylesheet" href="css/table.css">
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>degree</title>
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
			<%@ page language="java" import="java.sql.*"%>
			<%@ page import="java.util.*"%>

			<%-- -------- Open Connection Code -------- --%>
			<%
				try {
					DriverManager
							.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

					Connection conn = DriverManager.getConnection(
							"jdbc:sqlserver://localhost:1433;databaseName=cse132b",
							"sa", "wangchunyan");
			%>

			<%--Insert degree --%>
			<%
				String action = request.getParameter("action");
					// Check if an insertion is requested
					if (action != null && action.equals("insert")) {

						// Begin transaction
						conn.setAutoCommit(false);

						// Create the prepared statement and use it to
						// INSERT the student attributes INTO the Student table.
						PreparedStatement pstmt = conn
								.prepareStatement("INSERT INTO degree (degree_name, total_units) VALUES (?, ?)");
						String pre = request.getParameter("PREFIX");

						String deg_name = pre + "_"
								+ request.getParameter("DEGREE");

						pstmt.setString(1, deg_name);
						pstmt.setDouble(2,
								Double.parseDouble(request.getParameter("UNITES")));
						int rowCount = pstmt.executeUpdate();

						// Commit transactio

						String s = "";
						//System.out.print(request.getParameter("PREFIX"));
						if (pre.equals("BS"))
							s = "INSERT INTO bachelor_degree (degree_name) values (?)";
						else if (pre.equals("MS"))
							s = "INSERT INTO master_degree (degree_name) values (?)";
						else if (pre.equals("PhD"))
							s = "INSERT INTO PhD_degree (degree_name) values (?)";
						else if (pre.equals("BSMS"))
							s= "INSERT INTO BSMS_degree (degree_name) values (?)";
						//System.out.print(s);
						PreparedStatement pstmt1 = conn.prepareStatement(s);
						pstmt1.setString(1, deg_name);
						rowCount = pstmt1.executeUpdate();
						//System.out.print(rowCount);
						// Use the created statement to SELECT
						// the student attributes FROM the Student table.
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
								.prepareStatement("UPDATE degree SET total_units = ?"
										+ "WHERE degree_name = ?");

						pstmt.setString(2, request.getParameter("DEGREENAME"));
						pstmt.setDouble(1,
								Double.parseDouble(request.getParameter("UNITES")));

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
						String degree = request.getParameter("DEGREENAME");

						PreparedStatement pstmt = conn
								.prepareStatement("DELETE FROM degree WHERE degree_name = ?");
						pstmt.setString(1, degree);
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
							.executeQuery("SELECT degree_name,total_units FROM degree");
					//Statement stat = conn.createStatement();

					//ResultSet dept = stat.executeQuery("Select dept_name from department");
					//List<String> list = new ArrayList<String>();
					//while(dept.next())
					//list.add(dept.getString("dept_name"));
			%>

			<table class="table table-hover table-bordered table-condensed">
				<tr>
					<th>Degree name</th>
					<th>Total Units</th>
					<th colspan="2">Action</th>
				</tr>
				<tr>
					<form action="degree.jsp" method="get">
						<input type="hidden" value="insert" name="action">
						<th><select name="PREFIX" class="span1">
								<option value="BS">BS</option>
								<option value="MS">MS</option>
								<option value="PhD">PhD</option>
								<option value="BSMS">BSMS</option>
						</select> <input type="text" value="" name="DEGREE"  size="50"></th>
						<th><input type="text" value="" name="UNITES"  class="input-small" size="10"></th>

						<th colspan="2"><input class="btn btn-info" type="submit"
							value="Insert"></th>
					</form>
				</tr>

				<%-- -------- Iteration Code -------- --%>
				<%
					while (rs.next()) {
							//System.out.print(rs.getDouble("total_units"));
				%>

				<tr>
					<form action="degree.jsp" method="get">
						<input type="hidden" value="update" name="action"> <input
							type="hidden" value="<%=rs.getString("degree_name")%>"
							name="DEGREENAME">
						<%-- Get the ID --%>
						<td>
							<p name="DEGREENAME"><%=rs.getString("degree_name")%></p>
						</td>
						<%-- Get the COLLEGE --%>
						<td><input type="text" class="input-small"
							value="<%=rs.getDouble("total_units")%>" name="UNITES" size="10"></td>

						<%-- Button --%>
						<td><input class="btn btn-info" type="submit" value="Update"></td>
					</form>

					<form action="degree.jsp" method="get">
						<input type="hidden" value="delete" name="action"> <input
							type="hidden" value="<%=rs.getString("degree_name")%>"
							name="DEGREENAME">

						<%-- Button --%>
						<td><input class="btn btn-info" class="btn btn-info"
							type="submit" value="Delete"></td>
					</form>
				</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>


	<div id="bachelor" class="container-wide">
		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.equals("BSupdate")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE bachelor_degree SET lower_division_units = ?"
									+ ", mini_lower_division_avg_GPA =?"
									+ ", college =? WHERE degree_name = ?");

					pstmt.setDouble(1, Double.parseDouble(request
							.getParameter("BSUNITES")));
					pstmt.setDouble(2,
							Double.parseDouble(request.getParameter("BSGPA")));
					pstmt.setString(3, request.getParameter("COLLEGE"));
					pstmt.setString(4, request.getParameter("BSDEGREE"));

					int rowCount = pstmt.executeUpdate();
					PreparedStatement lCourse = conn
							.prepareStatement("DELETE FROM bachelor_course WHERE degree_name = ?");
					lCourse.setString(1, request.getParameter("BSDEGREE"));
					lCourse.execute();

					String[] course = request.getParameterValues("LowDCourse");
					if(!course[0].equals("")) {
						
					
					
					for (String s : course) {
						PreparedStatement lCourse1 = conn
								.prepareStatement("INSERT INTO bachelor_course (degree_name, number) VALUES (?, ?)");
						lCourse1.setString(1, request.getParameter("BSDEGREE"));
						lCourse1.setString(2, s);
						lCourse1.execute();
					}
					}
					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<hr>
		<h4>Bachelor Degree Requirement</h4>
		<div id="form">

			<%-- -------- SELECT Statement Code -------- --%>
			<%
				// Create the statement
					Statement statBS = conn.createStatement();

					// Use the created statement to SELECT
					// the student attributes FROM the Student table.
					ResultSet rsBS = statBS
							.executeQuery("SELECT degree_name, lower_division_units, mini_lower_division_avg_GPA, college  FROM bachelor_degree");
					//Statement stat = conn.createStatement();

					Statement statBS1 = conn.createStatement();
					ResultSet lowerCourse = statBS1
							.executeQuery("SELECT number from course where division='LOWER'");
					List<String> lowerCourseList = new ArrayList<String>();
					while (lowerCourse.next())
						lowerCourseList.add(lowerCourse.getString("number"));
					lowerCourse.close();
					statBS1.close();
					//ResultSet dept = stat.executeQuery("Select dept_name from department");
					//List<String> list = new ArrayList<String>();
					//while(dept.next())
					//list.add(dept.getString("dept_name"));
			%>
			<table class="table table-hover table-bordered table-condensed">
				<tr>
					<th>Degree name</th>
					<th>Low Division Units</th>
					<th>Minimum GPA</th>
					<th>College</th>
					<th>Lower Division Course</th>
					<th colspan="2">Action</th>
				</tr>
				<%
					List<String> colgList = new ArrayList<String>();
						colgList.add("Revelle College");
						colgList.add("John Muir College");
						colgList.add("Thurgood Marshall College");
						colgList.add("Earl Warren College");
						colgList.add("Eleanor Roosevelt College");
						colgList.add("Sixth College");
				%>
				<%
					while (rsBS.next()) {
							Statement statBS2 = conn.createStatement();
							ResultSet lowerCourse2 = statBS2
									.executeQuery("SELECT number from bachelor_course where degree_name = '"
											+ rsBS.getString("degree_name") + "'");
							HashMap<String, String> BSLowerCourseMap = new HashMap<String, String>();
							while (lowerCourse2.next())
								BSLowerCourseMap.put(lowerCourse2.getString("number"),
										"");

							lowerCourse2.close();
							statBS2.close();
				%>
				<tr>
					<form action="degree.jsp" method="get">
						<input type="hidden" value="BSupdate" name="action"> <input
							type="hidden" value="<%=rsBS.getString("degree_name")%>"
							name="BSDEGREE">
						<th><p><%=rsBS.getString("degree_name")%></p></th>
						<th><input type="text" class="input-small"
							value="<%=rsBS.getDouble("lower_division_units")%>"
							name="BSUNITES" size="10"></th>
						<th><input type="text" class="input-small"
							value="<%=rsBS.getDouble("mini_lower_division_avg_GPA")%>"
							name="BSGPA" size="10"></th>
						<th><select name="COLLEGE" class="span2">
								<%
									for (String col : colgList) {
								%>
								<option value="<%=col%>"
									<%=col.equals(rsBS.getString("college")) ? "selected"
								: ""%>>
									<%=col%>
								</option>
								<%
									}
								%>
						</select></th>
						<th><select name="LowDCourse" class="span2" multiple>
								<option value="" <%=BSLowerCourseMap.isEmpty()?"selected":"" %>>Empty</option>
								<%
									for (String BSLower : lowerCourseList) {
								%>
								<option value="<%=BSLower%>"
									<%=BSLowerCourseMap.containsKey(BSLower) ? "selected"
								: ""%>><%=BSLower%></option>
								<%
									}
								%>
						</select></th>
						<th colspan="2"><input class="btn btn-info" type="submit"
							value="Update"></th>
					</form>
				</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>



	<div id="master" class="container-wide">
		<hr>
		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.equals("MSupdate")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE master_degree SET core_units = ?"
									+ ", elective_units =?, concentration_units=?, thesis_units=?,"
									+ " mini_avg_GPA =?, dept_name=? WHERE degree_name = ?");

					pstmt.setDouble(1, Double.parseDouble(request
							.getParameter("COREUNITS")));

					pstmt.setDouble(2, Double.parseDouble(request
							.getParameter("ELECTIVEUNITS")));

					pstmt.setDouble(3, Double.parseDouble(request
							.getParameter("CONCENTRATIONUNITS")));

					pstmt.setDouble(4, Double.parseDouble(request
							.getParameter("THESISUNITS")));

					pstmt.setDouble(5,
							Double.parseDouble(request.getParameter("MSGPA")));

					pstmt.setString(6, request.getParameter("DEPARTMENT"));
					pstmt.setString(7, request.getParameter("DEGREENAME"));

					int rowCount = pstmt.executeUpdate();

					String[] coreCourseStr = request
							.getParameterValues("CORECOURSE");
					PreparedStatement lCourse = conn
							.prepareStatement("DELETE FROM core_course WHERE degree_name = ?");
					lCourse.setString(1, request.getParameter("DEGREENAME"));
					lCourse.execute();
					
					if(!coreCourseStr[0].equals("")) {
						
						
						for (String s : coreCourseStr) {
							PreparedStatement lCourse1 = conn
									.prepareStatement("INSERT INTO core_course (degree_name, number) VALUES (?, ?)");
							lCourse1.setString(1,
									request.getParameter("DEGREENAME"));
							lCourse1.setString(2, s);
							
							lCourse1.execute();
						}
					}
					

					String[] electiveCourseStr = request
							.getParameterValues("ELECTIVECOURSE");
					PreparedStatement elecCourse = conn
							.prepareStatement("DELETE FROM elective_course WHERE degree_name = ?");
					elecCourse.setString(1, request.getParameter("DEGREENAME"));
					elecCourse.execute();
					if(!electiveCourseStr[0].equals("")) {
						
						for (String s : electiveCourseStr) {
							PreparedStatement elecCourse1 = conn
									.prepareStatement("INSERT INTO elective_course (degree_name, number) VALUES (?, ?)");
							elecCourse1.setString(1,
									request.getParameter("DEGREENAME"));
							elecCourse1.setString(2, s);
							elecCourse1.execute();
						}
					}
					
					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<h4>Master Degree Requirement</h4>
		<div id="form"></div>
		<%-- -------- SELECT Statement Code -------- --%>
		<%
			// Create the statement
				Statement statMS = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				ResultSet rsMS = statMS
						.executeQuery("SELECT degree_name, core_units, concentration_units, elective_units, thesis_units, mini_avg_GPA, dept_name FROM master_degree");
				//Statement stat = conn.createStatement();

				Statement MSDept = conn.createStatement();
				ResultSet dept = MSDept
						.executeQuery("SELECT dept_name from department");
				List<String> deptList = new ArrayList<String>();
				while (dept.next())
					deptList.add(dept.getString("dept_name"));

				Statement course = conn.createStatement();
				ResultSet rsCourse = course
						.executeQuery("Select number from course");
				List<String> courseList = new ArrayList<String>();
				while (rsCourse.next())
					courseList.add(rsCourse.getString("number"));

				MSDept.close();
				dept.close();
				rsCourse.close();
				course.close();
				//ResultSet dept = stat.executeQuery("Select dept_name from department");
				//List<String> list = new ArrayList<String>();
				//while(dept.next())
				//list.add(dept.getString("dept_name"));
		%>
		<table class="table table-hover table-bordered table-condensed">
			<tr>
				<th>Degree name</th>
				<th>Core Units</th>
				<th>Core Course</th>
				<th>Elective Units</th>
				<th>Elective Course</th>
				<th>Concentration Units</th>
				<th>Thesis Units</th>
				<th>Minimum GPA</th>
				<th>Department</th>
				<th colspan="2">Action</th>
			</tr>
			<%-- -------- Iteration Code -------- --%>
			<%
				while (rsMS.next()) {
						Statement coreCourse = conn.createStatement();
						ResultSet rsCoreCourse = coreCourse
								.executeQuery("select number from core_course where degree_name='"
										+ rsMS.getString("degree_name") + "'");
						HashMap<String, String> coreCourseMap = new HashMap<String, String>();
						while (rsCoreCourse.next()) {
							coreCourseMap.put(rsCoreCourse.getString("number"), "");
							
						}
							
						

						Statement electiveCourse = conn.createStatement();
						ResultSet rsElectiveCourse = electiveCourse
								.executeQuery("select number from elective_course where degree_name='"
										+ rsMS.getString("degree_name") + "'");
						HashMap<String, String> electiveCourseMap = new HashMap<String, String>();
						while (rsElectiveCourse.next()) {
							electiveCourseMap.put(rsElectiveCourse.getString("number"),
									"");
						}
						rsCoreCourse.close();
						coreCourse.close();
						rsElectiveCourse.close();
						electiveCourse.close();
			%>

			<tr>
				<form action="degree.jsp" method="get">
					<input type="hidden" value="MSupdate" name="action"> <input
						type="hidden" value="<%=rsMS.getString("degree_name")%>"
						name="DEGREENAME">
					<%-- Get the ID --%>
					<td>
						<p name="DEGREENAME"><%=rsMS.getString("degree_name")%></p>
					</td>
					
					<td><input type="text" style="width: 30px"
						value="<%=rsMS.getDouble("core_units")%>" name="COREUNITS">
					</td>
					
					<td><select name="CORECOURSE" class="span2" multiple>
							<option  value="" <%=coreCourseMap.isEmpty()?"selected":""%>>Empty</option>
							<%
								for (String s : courseList) {
							%>
							<option value="<%=s%>"
								<%=coreCourseMap.containsKey(s) ? "selected"
								: ""%>>
								<%=s%></option>
							<%
								}
							%>
					</select></td>
					
					<td><input type="text"
						value="<%=rsMS.getDouble("elective_units")%>" name="ELECTIVEUNITS"
						style="width: 30px"></td>
						
					<td><select name="ELECTIVECOURSE" class="span2" multiple>
							<option  value="" <%=electiveCourseMap.isEmpty()?"selected":"" %>>Empty</option>
							<%
								for (String s : courseList) {
							%>
							<option value="<%=s%>"
								<%=electiveCourseMap.containsKey(s) ? "selected"
								: ""%>><%=s%></option>
							<%
								}
							%>
					</select></td>
					
					<td><input type="text"
						value="<%=rsMS.getDouble("concentration_units")%>"
						name="CONCENTRATIONUNITS" style="width: 30px"></td>
						
					<td><input type="text"
						value="<%=rsMS.getDouble("thesis_units")%>" name="THESISUNITS"
						style="width: 30px"></td>
						
					<td><input type="text"
						value="<%=rsMS.getDouble("mini_avg_GPA")%>" name="MSGPA"
						style="width: 20px"></td>

					<td><select name="DEPARTMENT" class="span2">
							<%
								for (String s : deptList) {
							%>
							<option value="<%=s%>"
								<%=s.equals(rsMS.getString("dept_name")) ? "selected"
								: ""%>><%=s%></option>
							<%
								}
							%>
					</select></td>

					<%-- Button --%>
					<td><input class="btn btn-info" type="submit" value="Update"></td>
				</form>

			</tr>
			<%
				}
			%>
			
		</table>
		<a href="concentration.jsp">Edit Concentration of Master degree</a>
	</div>


	<div id="PhD" class="container-wide">
		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.equals("PHDupdate")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE PhD_degree SET thesis_units = ?"
									+ ", research_units =?"
									+ ", dept_name =? WHERE degree_name = ?");

					pstmt.setDouble(1, Double.parseDouble(request
							.getParameter("THESISUNITS")));
					pstmt.setDouble(2, Double.parseDouble(request
							.getParameter("RESEARCHUNITS")));
					pstmt.setString(3, request.getParameter("DEPARTMENT"));
					pstmt.setString(4, request.getParameter("DEGREENAME"));

					int rowCount = pstmt.executeUpdate();

					String[] researchCourse = request
							.getParameterValues("RESEARCHCOURSE");
					PreparedStatement lCourse = conn
							.prepareStatement("DELETE FROM research_course WHERE degree_name = ?");
					lCourse.setString(1, request.getParameter("DEGREENAME"));
					lCourse.execute();
					
					if(!researchCourse[0].equals("")) {
						for (String s : researchCourse) {
							PreparedStatement lCourse1 = conn
									.prepareStatement("INSERT INTO research_course (degree_name, number) VALUES (?, ?)");
							lCourse1.setString(1,
									request.getParameter("DEGREENAME"));
							lCourse1.setString(2, s);
							lCourse1.execute();
						}
					}
					
					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<hr>
		<h4>PhD Degree Requirement</h4>
		<div id="form"></div>
		<%-- -------- SELECT Statement Code -------- --%>
		<%
			// Create the statement
				Statement statPHD = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				ResultSet rsPHD = statPHD
						.executeQuery("SELECT degree_name, research_units, thesis_units, dept_name FROM PhD_degree");

				Statement statResearch = conn.createStatement();
				ResultSet researchCourse = statResearch
						.executeQuery("SELECT number from course where division='graduate'");
				List<String> researchCourseList = new ArrayList<String>();
				while (researchCourse.next())
					researchCourseList.add(researchCourse.getString("number"));
				researchCourse.close();
				statResearch.close();

				//Statement stat = conn.createStatement();					
				//ResultSet dept = stat.executeQuery("Select dept_name from department");
				//List<String> list = new ArrayList<String>();
				//while(dept.next())
				//list.add(dept.getString("dept_name"));
		%>
		<table class="table table-hover table-bordered table-condensed">
			<tr>
				<th>Degree name</th>
				<th>Thesis Units</th>
				<th>Research Units</th>
				<th>Research Course</th>
				<th>Department</th>
				<th colspan="2">Action</th>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%
				while (rsPHD.next()) {
						Statement courseByDegre = conn.createStatement();
						ResultSet courseByD = courseByDegre
								.executeQuery("SELECT number from research_course where degree_name='"
										+ rsPHD.getString("degree_name") + "'");
						HashMap<String, String> selectCourseMap = new HashMap<String, String>();
						while (courseByD.next())
							selectCourseMap.put(courseByD.getString("number"), "");

						//System.out.print(rs.getDouble("total_units"));
			%>

			<tr>
				<form action="degree.jsp" method="get">
					<input type="hidden" value="PHDupdate" name="action"> <input
						type="hidden" value="<%=rsPHD.getString("degree_name")%>"
						name="DEGREENAME">
					<%-- Get the ID --%>
					<td>
						<p name="DEGREENAME"><%=rsPHD.getString("degree_name")%></p>
					</td>
					<%-- Get the COLLEGE --%>
					<td><input type="text"
						value="<%=rsPHD.getDouble("thesis_units")%>" name="THESISUNITS"
						size="10"></td>
					<td><input type="text"
						value="<%=rsPHD.getDouble("research_units")%>"
						name="RESEARCHUNITS" size="10"></td>
					<td><select name="RESEARCHCOURSE" class="span2" multiple>
							<option  value=""  <%=selectCourseMap.isEmpty()? "selected":""%>>Empty</option>
							<%
								for (String s : researchCourseList) {
							%>
							<option value="<%=s%>"
								<%=selectCourseMap.containsKey(s) ? "selected"
								: ""%>><%=s%></option>
							<%
								}
							%>
					</select></td>

					<td><select name="DEPARTMENT" class="span2">
							<%
								for (String s : deptList) {
							%>
							<option value="<%=s%>"
								<%=s.equals(rsPHD.getString("dept_name")) ? "selected"
								: ""%>><%=s%></option>
							<%
								}
							%>
					</select></td>

					<%-- Button --%>
					<td><input class="btn btn-info" type="submit" value="Update"></td>
				</form>

			</tr>
			<%
				courseByD.close();
						courseByDegre.close();
					}
			%>
		</table>
	</div>
	
	<div id="bss" class="container-wide">
		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.equals("BSMSupdate")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE BSMS_degree SET lower_division_units = ?"
									+ ", mini_lower_division_avg_GPA =?"
									+ ", college =?, MS_units=? WHERE degree_name = ?");

					pstmt.setDouble(1, Double.parseDouble(request
							.getParameter("BSMSUNITS")));
					pstmt.setDouble(2,
							Double.parseDouble(request.getParameter("BSMSGPA")));
					pstmt.setString(3, request.getParameter("COLLEGEMS"));
					pstmt.setString(4, request.getParameter("MSUNITS"));
					pstmt.setString(5, request.getParameter("BSMSDEGREE"));

					int rowCount = pstmt.executeUpdate();
					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
		<hr>
		<h4>Bachelor-Master Degree Requirement</h4>
		<div id="form">

			<%-- -------- SELECT Statement Code -------- --%>
			<%
				// Create the statement
					Statement statBSMS = conn.createStatement();

					// Use the created statement to SELECT
					// the student attributes FROM the Student table.
					ResultSet rsBSMS = statBS
							.executeQuery("SELECT degree_name, lower_division_units, mini_lower_division_avg_GPA, college,ms_units  FROM BSMS_degree");
					//Statement stat = conn.createStatement();

					Statement statBSMS1 = conn.createStatement();
					//ResultSet dept = stat.executeQuery("Select dept_name from department");
					//List<String> list = new ArrayList<String>();
					//while(dept.next())
					//list.add(dept.getString("dept_name"));
			%>
			<table class="table table-hover table-bordered table-condensed">
				<tr>
					<th>Degree name</th>
					<th>Low Division Units</th>
					<th>Minimum GPA</th>
					<th>College</th>
					<th>Master Units</th>
					<th>Action</th>
				</tr>
				<%
					while (rsBSMS.next()) {
				%>
				<tr>
					<form action="degree.jsp" method="get">
						<input type="hidden" value="BSMSupdate" name="action"> <input
							type="hidden" value="<%=rsBSMS.getString("degree_name")%>"
							name="BSMSDEGREE">
						<th><p><%=rsBSMS.getString("degree_name")%></p></th>
						<th><input type="text" class="input-small"
							value="<%=rsBSMS.getDouble("lower_division_units")%>"
							name="BSMSUNITS" size="10"></th>
						<th><input type="text" class="input-small"
							value="<%=rsBSMS.getDouble("mini_lower_division_avg_GPA")%>"
							name="BSMSGPA" size="10"></th>
						<th><select name="COLLEGEMS" class="span2">
								<%
									for (String col : colgList) {
								%>
								<option value="<%=col%>"
									<%=col.equals(rsBSMS.getString("college")) ? "selected"
								: ""%>>
									<%=col%>
								</option>
								<%
									}
								%>
						</select></th>
						<th><input type="text" class="input-small"
							value="<%=rsBSMS.getDouble("ms_units")%>"
							name="MSUNITS" size="10"></th>
						<th ><input class="btn btn-info" type="submit"
							value="Update"></th>
					</form>
				</tr>
				<%
					}
				%>
			</table>
		</div>
	</div>
	
	<%-- -------- Close Connection Code -------- --%>
	<%
		// Close the ResultSet
			rs.close();

			// Close the Statement
			statement.close();

			statBS.close();
			rsBS.close();
			statMS.close();
			rsMS.close();

			statPHD.close();
			rsPHD.close();

			// Close the Connection
			conn.close();
		} catch (SQLException sqle) {
			out.println(sqle.getMessage());
		} catch (Exception e) {
			out.println(e.getMessage());
		}
	%>
</body>
</html>