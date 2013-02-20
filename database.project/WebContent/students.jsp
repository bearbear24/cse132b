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
    <li class="active" >
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
         <li >
        <a href="committee.jsp">Thesis Committee</a>
    </li>
             <li>
        <a href="probation.jsp">Probation</a>
    </li>
    <li>
        <a href="reviewsession.jsp">Review session</a>
    </li>
    <li >
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
				if (action != null && action.startsWith("insert")) {
				
					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// INSERT the student attributes INTO the Student table.
					PreparedStatement pstmt = conn
							.prepareStatement("INSERT INTO dbo.student (SSN, s_id,firstname,middlename,lastname,degree_name,enrolled_status,resident_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

					pstmt.setString(1, (request.getParameter("SSN")));
					pstmt.setString(2, request.getParameter("ID"));
					pstmt.setString(3, request.getParameter("FIRSTNAME"));
					pstmt.setString(4, request.getParameter("MIDDLENAME"));
					pstmt.setString(5, request.getParameter("LASTNAME"));
					//System.out.print(request.getParameter("DEGREE"));
					pstmt.setString(6, request.getParameter("DEGREE"));
					pstmt.setBoolean(7,
							new Boolean(request.getParameter("ENROLLEDSTATUS")));
					pstmt.setString(8, request.getParameter("RESIDENCY"));
					String major=request.getParameter("DEGREE").split("_")[1];
					int rowCount = pstmt.executeUpdate();
					if(action.endsWith("_MS"))
					{
						PreparedStatement gra = conn
								.prepareStatement("INSERT INTO dbo.graduate (s_id,dept_name,thesis_status,degree_type) VALUES (?,?,null,'MS')");
						gra.setString(1, request.getParameter("ID"));
						gra.setString(2, request.getParameter("DEPARTMENT"));
						gra.execute();
					}
					else if(action.endsWith("_PHD"))
					{
						PreparedStatement gra = conn
								.prepareStatement("INSERT INTO dbo.graduate (s_id,dept_name,thesis_status,degree_type) VALUES (?, ?,null,'PHD')");
						gra.setString(1, request.getParameter("ID"));
						gra.setString(2, request.getParameter("DEPARTMENT"));
						gra.execute();
						PreparedStatement phd = conn
								.prepareStatement("INSERT INTO dbo.PhD (s_id,faculty_name,candidate_status) VALUES (?,?,?)");
						phd.setString(1, request.getParameter("ID"));
						phd.setString(2, request.getParameter("NAME"));
						phd.setBoolean(3, new Boolean(request.getParameter("CANDIDATE")));
						phd.execute();
					}
					else if(action.endsWith("_BS"))
					{
						PreparedStatement pstm2=conn.prepareStatement("INSERT INTO undergraduate (s_id,college,major,minor) VALUES(?,?,?,?)");
						pstm2.setString(1,request.getParameter("ID"));
						pstm2.setString(2, request.getParameter("COLLEGE"));
						pstm2.setString(3, major);
						String[] minor = request.getParameterValues("MINOR");
						String minorReal = "";
						for(String s: minor) {
							if(s=="") {
								continue;
							}
							else {
								minorReal = s;
								break;
							}
						}
						System.out.print("f" + minorReal);
						if(minorReal.equals(major)) {
								minorReal ="";
						}
						System.out.print("l" + minorReal);
						pstm2.setString(4, minorReal);	
						pstm2.execute();
					}
					else if(action.endsWith("_BSMS"))
					{
						PreparedStatement pstm2=conn.prepareStatement("INSERT INTO undergraduate_master (s_id,college,major,minor,thesis_status) VALUES(?,?,?,?,null)");
						pstm2.setString(1,request.getParameter("ID"));
						pstm2.setString(2, request.getParameter("COLLEGE"));
						pstm2.setString(3, major);
						String[] minor = request.getParameterValues("MINOR");
						String minorReal = "";
						for(String s: minor) {
							if(s=="") {
								continue;
							}
							else {
								minorReal = s;
								break;
							}
						}
						System.out.print("f" + minorReal);
						if(minorReal.equals(major)) {
								minorReal ="";
						}
						pstm2.setString(4, minorReal);
						
						pstm2.execute();
					}


					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>

		<%-- -------- UPDATE Code -------- --%>
		<%
			// Check if an update is requested
				if (action != null && action.startsWith("update")) {

					// Begin transaction
					conn.setAutoCommit(false);

					// Create the prepared statement and use it to
					// UPDATE the student attributes in the Student table.
		
					PreparedStatement pstmt = conn
							.prepareStatement("UPDATE student SET SSN = ?, FIRSTNAME = ?, "
									+ "MIDDLENAME = ?, LASTNAME = ?, resident_status = ?"
									+ ",degree_name =?,enrolled_status=? WHERE s_id = ?");

					pstmt.setInt(1,
							Integer.parseInt(request.getParameter("SSN")));
					pstmt.setString(8, request.getParameter("ID"));
					pstmt.setString(2, request.getParameter("FIRSTNAME"));
					pstmt.setString(3, request.getParameter("MIDDLENAME"));
					pstmt.setString(4, request.getParameter("LASTNAME"));
					pstmt.setString(5, request.getParameter("RESIDENCY"));
					pstmt.setString(6, request.getParameter("DEGREE"));
					pstmt.setBoolean(7,
							new Boolean(request.getParameter("ENROLLEDSTATUS")));

					int rowCount = pstmt.executeUpdate();
					String major=request.getParameter("DEGREE").split("_")[1];
					if(action.endsWith("_MS"))
					{
						System.out.println("studnet!3");
						PreparedStatement gra = conn
								.prepareStatement("UPDATE dbo.graduate SET dept_name=? WHERE s_id=?");
						gra.setString(2, request.getParameter("ID"));
						gra.setString(1, request.getParameter("DEPARTMENT"));
						gra.execute();
					}
					else if(action.endsWith("_PHD"))
					{
						PreparedStatement gra = conn
								.prepareStatement("UPDATE dbo.graduate SET dept_name=? WHERE s_id=?");
						gra.setString(2, request.getParameter("ID"));
						gra.setString(1, request.getParameter("DEPARTMENT"));
						gra.execute();
						PreparedStatement gra2 = conn
								.prepareStatement("UPDATE dbo.PhD SET faculty_name=?, candidate_status=? WHERE s_id=?" );
						gra2.setString(3, request.getParameter("ID"));
						gra2.setString(1, request.getParameter("NAME"));
						gra2.setBoolean(2, new Boolean(request.getParameter("CANDIDATE")));
						gra2.execute();
					}

					else if(action.endsWith("_BS"))
					{
						
						PreparedStatement pstm2=conn.prepareStatement("UPDATE undergraduate SET college=?,major=?,minor=? WHERE s_id=? ");
						pstm2.setString(4,request.getParameter("ID"));
						pstm2.setString(1, request.getParameter("COLLEGE"));
						pstm2.setString(2, major);
						String[] minor = request.getParameterValues("MINOR");
						String minorReal = "";
						for(String s: minor) {
							if(s=="") {
								continue;
							}
							else {
								minorReal = s;
								break;
							}
						}
						System.out.print("f" + minorReal);
						if(minorReal.equals(major)) {
								minorReal ="";
						}
						pstm2.setString(3, minorReal);	
						pstm2.execute();
					}
					else if(action.endsWith("_BSMS"))
					{
						PreparedStatement pstm2=conn.prepareStatement("UPDATE undergraduate_master SET college=?,major=?,minor=? WHERE s_id=?");
						pstm2.setString(4,request.getParameter("ID"));
						pstm2.setString(1, request.getParameter("COLLEGE"));
						System.out.print(major);
						pstm2.setString(2, major);
						String[] minor = request.getParameterValues("MINOR");
						String minorReal = "";
						for(String s: minor) {
							if(s=="") {
								continue;
							}
							else {
								minorReal = s;
								break;
							}
						}
						System.out.print("f" + minorReal);
						if(minorReal.equals(major)) {
								minorReal ="";
						}
						pstm2.setString(3, minorReal);
						
						pstm2.execute();
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
							.prepareStatement("DELETE FROM student WHERE s_id = ?");

					pstmt.setString(1, request.getParameter("ID"));
					int rowCount = pstmt.executeUpdate();

					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>

		<%-- -------- SELECT Statement Code -------- --%>
		<%
			// Create the statement
				Statement statement1 = conn.createStatement();
				
				Statement statement2 = conn.createStatement();
				Statement statement3 = conn.createStatement();
				Statement statement4 = conn.createStatement();
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				ResultSet under = statement1.executeQuery("SELECT student.s_id AS s_id, SSN, firstname,middlename,lastname,degree_name,enrolled_status,resident_status,college,major,minor FROM undergraduate left outer join student ON undergraduate.s_id=student.s_id");
				ResultSet master = statement2.executeQuery("SELECT student.s_id AS s_id, SSN, firstname,middlename,lastname,degree_name,enrolled_status,resident_status,dept_name FROM graduate left outer join student ON graduate.s_id=student.s_id WHERE graduate.degree_type='MS'");
				ResultSet phd = statement3.executeQuery("SELECT student.s_id AS s_id, SSN, firstname,middlename,lastname,degree_name,enrolled_status,resident_status,dept_name,faculty_name,candidate_status FROM PhD,graduate,student WHERE PhD.s_id=graduate.s_id AND PhD.s_id=student.s_id");
				ResultSet underms = statement4.executeQuery("SELECT student.s_id AS s_id, SSN, firstname,middlename,lastname,degree_name,enrolled_status,resident_status,college,major,minor FROM undergraduate_master left outer join student ON undergraduate_master.s_id=student.s_id");
				
				Statement stat = conn.createStatement();
				ResultSet rsDegree = stat.executeQuery("Select degree_name from degree");
				List<String> list = new ArrayList<String>();
				while(rsDegree.next())
					list.add(rsDegree.getString("degree_name"));	
				
			    Statement stat2 = conn.createStatement();
				ResultSet rsDept = stat2.executeQuery("Select dept_name from department");
				List<String> depList = new ArrayList<String>();
				while(rsDept.next())
					depList.add(rsDept.getString("dept_name"));
				
				Statement stat3 = conn.createStatement();
				ResultSet rsFac = stat2.executeQuery("Select faculty_name from faculty WHERE title='Professor' or title='Assistent Professor' or title='Associate Professor'");
				List<String> facList = new ArrayList<String>();
				while(rsFac.next())
					facList.add(rsFac.getString("faculty_name"));
		%>
		<h2>Undergraduate Students</h2>
		<table class="table table-hover table-bordered table-condensed" >
			<tr>

				<th>ID</th>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>Degree</th>
				<th>Enroll</br>Status</th>
				<th>Residency</th>
				<th>College</th>
				<th>Major</th>
				<th>Minor</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="insert_BS" name="action">
					<th><input type="text" class="input-small" value="" name="ID" size="10"></th>
					<th><input type="text" class="input-small" value="" name="SSN" size="10"></th>
					<th><input type="text" class="input-small" value="" name="FIRSTNAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="MIDDLENAME" style="width:40px"></th>
					<th><input type="text" class="input-small" value="" name="LASTNAME" size="15"></th>
					<th><select name="DEGREE" class="input-small">
							<%
								for(String degree : list) {
									if(degree.startsWith("BS_"))
									{
							%>
							<option value="<%=degree%>"><%=degree%></option>
							<%
								}
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="ENROLLEDSTATUS"
						size="5"></th>
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA">CA</option>
					<option value="NONCA">NONCA</option>
					<OPTION value="International">International</OPTION>
					</select></th>
					<th><select class="input-small" NAME="COLLEGE">
					<option value="Revelle College">Revelle College</option>
					<option value="John Muir College">John Muir College</option>
					<option value="Thurgood Marshall College">Thurgood Marshall College</option>
					<option value="Earl Warren College">Earl Warren College</option>
					<option value="Eleanor Roosevelt College">Eleanor Roosevelt College</option>
					<option value="Sixth College">Sixth College</option>
					</select></th>
					<th></th>
					<th><select name="MINOR" class="input-small">
					<option  selected value="" >No minor</option>
							<%
								for(String degree : list) {
									if(degree.startsWith("BS_")) {
										String s = degree.split("_")[1];
							%>
							<option value="<%=s%>"><%=s%></option>
							<%
									}
								}
							%>
					</select></th>
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
				</form>
			</tr>
			
			<%-- -------- Iteration Code -------- --%>
			<%


					while (under.next()) {
				
			%>

			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="update_BS" name="action"> <input
						type="hidden" value="<%=under.getString("s_id")%>" name="ID">
					<%-- Get the ID --%>
					<td>
						<p name="ID"><%=under.getString("s_id")%></p>
					</td>
					<td><input type="text" class="input-small" value="<%=under.getString("SSN")%>" name="SSN"
						size="10"></td>

					<%-- Get the FIRSTNAME --%>
					<td><input type="text" class="input-small" value="<%=under.getString("FIRSTNAME")%>"
						name="FIRSTNAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=under.getString("MIDDLENAME")%>"
						name="MIDDLENAME" style="width:40px"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=under.getString("LASTNAME")%>"
						name="LASTNAME" size="15"></td>

					<%-- Get the COLLEGE --%>

					<td>
					<select name="DEGREE" class="input-small">
							<%
							   String dataDegree = under.getString("degree_name");
								for(String degree : list) {
									if(degree.startsWith("BS_"))
									{
							%>
							<option value="<%=degree%>" <%=dataDegree.equals(degree) ? "selected" : ""%> ><%=degree%></option>
							<%
								}}
							%>
					</select>
					</td>

					<td><input type="checkbox"
						<%=(under.getString("ENROLLED_STATUS")).equals("1") ? "checked"
							: ""%>
						name="ENROLLEDSTATUS" size="15" , value="true"></td>

					
					
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA" <%=(under.getString("resident_status")).equals("CA") ? "selected" : ""%>>CA</option>
					<option value="NONCA" <%=(under.getString("resident_status")).equals("NONCA") ? "selected" : ""%>>NONCA</option>
					<OPTION value="International" <%=(under.getString("resident_status")).equals("International") ? "selected" : ""%>>International</OPTION>
					</select></th>
					<th><select class="input-small" NAME="COLLEGE">
					<option value="Revelle College" <%=(under.getString("college")).equals("Revelle College") ? "selected" : ""%>>Revelle College</option>
					<option value="John Muir College" <%=(under.getString("college")).equals("John Muir College") ? "selected" : ""%>>John Muir College</option>
					<option value="Thurgood Marshall College" <%=(under.getString("college")).equals("Thurgood Marshall College") ? "selected" : ""%>>Thurgood Marshall College</option>
					<option value="Earl Warren College" <%=(under.getString("college")).equals("Earl Warren College") ? "selected" : ""%>>Earl Warren College</option>
					<option value="Eleanor Roosevelt College" <%=(under.getString("college")).equals("Eleanor Roosevelt College") ? "selected" : ""%>>Eleanor Roosevelt College</option>
					<option value="Sixth College" <%=(under.getString("college")).equals("Sixth College") ? "selected" : ""%>>Sixth College</option>
					</select></th>
					<td><p  name="MAJOR"><%=under.getString("major")%></p></td>
					
					<th><select name="MINOR" class="input-small">
					<option <%= under.getString("minor").equals("")? "selected" :"" %> value="">No minor</option>
							<%
							for(String degree : list) {
									
									if(degree.startsWith("BS_")) {
										String ss = degree.split("_")[1];
							%>
							<option value="<%=ss%>" <%=under.getString("minor").equals(ss)?"selected":""%>><%=ss%></option>
							<%
									}
							}
							%>
					</select></th>
					
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="students.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=under.getString("s_id")%>" name="ID"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
			<%
					}
			%>
			</table>
			<hr>
			
			
			
			<h2>Masters Students</h2>
		<table class="table table-hover table-bordered table-condensed" >
			<tr>

				<th>ID</th>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>Degree</th>
				<th>Enroll</br>Status</th>
				<th>Residency</th>
				<th>Department</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="insert_MS" name="action">
					<th><input type="text" class="input-small" value="" name="ID" size="10"></th>
					<th><input type="text" class="input-small" value="" name="SSN" size="10"></th>
					<th><input type="text" class="input-small" value="" name="FIRSTNAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="MIDDLENAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="LASTNAME" size="15"></th>
					<th><select name="DEGREE" class="input-small">
							<%
								for(String degree : list) {
									if(degree.startsWith("MS_"))
									{
							%>
							<option value="<%=degree%>"><%=degree%></option>
							<%
								}
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="ENROLLEDSTATUS"
						size="5"></th>
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA">CA</option>
					<option value="NONCA">NONCA</option>
					<OPTION value="International">International</OPTION>
					</select></th>
					<th><select name="DEPARTMENT" class="input-small">
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

					while (master.next()) {
			%>

			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="update_MS" name="action"> <input
						type="hidden" value="<%=master.getString("s_id")%>" name="ID">
					<%-- Get the ID --%>
					<td>
						<p name="ID"><%=master.getString("s_id")%></p>
					</td>
					<td><input type="text" class="input-small" value="<%=master.getString("SSN")%>" name="SSN"
						size="10"></td>

					<%-- Get the FIRSTNAME --%>
					<td><input type="text" class="input-small" value="<%=master.getString("FIRSTNAME")%>"
						name="FIRSTNAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=master.getString("MIDDLENAME")%>"
						name="MIDDLENAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=master.getString("LASTNAME")%>"
						name="LASTNAME" size="15"></td>

					<%-- Get the COLLEGE --%>

					<td>
					<select name="DEGREE" class="input-small">
							<%
							   String dataDegree = master.getString("degree_name");
								for(String degree : list) {
									if(degree.startsWith("MS_"))
									{
							%>
							<option value="<%=degree%>" <%=dataDegree.equals(degree) ? "selected" : ""%> ><%=degree%></option>
							<%
								}}
							%>
					</select>
					</td>

					<td><input type="checkbox"
						<%=(master.getString("ENROLLED_STATUS")).equals("1") ? "checked"
							: ""%>
						name="ENROLLEDSTATUS" size="15" , value="true"></td>

					
					
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA" <%=(master.getString("resident_status")).equals("CA") ? "selected" : ""%>>CA</option>
					<option value="NONCA" <%=(master.getString("resident_status")).equals("NONCA") ? "selected" : ""%>>NONCA</option>
					<OPTION value="International" <%=(master.getString("resident_status")).equals("International") ? "selected" : ""%>>International</OPTION>
					</select></th>
					
					<th><select name="DEPARTMENT" class="input-small">
							<%
							   String dataDept = master.getString("dept_name");
					
								for(String dept : depList) {
							
							%>
							<option value="<%=dept%>" <%=dataDept.equals(dept) ? "selected" : ""%> ><%=dept%></option>
							<%
								}
							%>
					</select></th>

					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="students.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=master.getString("s_id")%>" name="ID"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
			<%
					}
			%>
			</table>
			<hr>
			
		<h2>PhD Students</h2>
		<table class="table table-hover table-bordered table-condensed" >
			<tr>

				<th>ID</th>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>Degree</th>
				<th>Enroll</br>Status</th>
				<th>Residency</th>
				<th>Department</th>
				<th>Candidate</br>Status</th>
				<th>Advisor</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="insert_PHD" name="action">
					<th><input type="text" class="input-small" value="" name="ID" size="10"></th>
					<th><input type="text" class="input-small" value="" name="SSN" size="10"></th>
					<th><input type="text" class="input-small" value="" name="FIRSTNAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="MIDDLENAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="LASTNAME" size="15"></th>
					<th><select name="DEGREE" class="input-small">
							<%
								for(String degree : list) {
									if(degree.startsWith("PhD_"))
									{
							%>
							<option value="<%=degree%>"><%=degree%></option>
							<%
								}
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="ENROLLEDSTATUS"
						size="5"></th>
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA">CA</option>
					<option value="NONCA">NONCA</option>
					<OPTION value="International">International</OPTION>
					</select></th>
					<th><select name="DEPARTMENT" class="input-small">
							<%
								for(String dept : depList) {
							%>
							<option value="<%=dept%>"><%=dept%></option>
							<%
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="CANDIDATE"
						size="5"></th>
						<th><select name="NAME" class="input-small">
							<%
								for(String falc : facList) {
							%>
							<option value="<%=falc%>"><%=falc%></option>
							<%
								}
							%>
					</select></th>
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
				</form>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%

					while (phd.next()) {
			%>

			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="update_PHD" name="action"> <input
						type="hidden" value="<%=phd.getString("s_id")%>" name="ID">
					<%-- Get the ID --%>
					<td>
						<p name="ID"><%=phd.getString("s_id")%></p>
					</td>
					<td><input type="text" class="input-small" value="<%=phd.getString("SSN")%>" name="SSN"
						size="10"></td>

					<%-- Get the FIRSTNAME --%>
					<td><input type="text" class="input-small" value="<%=phd.getString("FIRSTNAME")%>"
						name="FIRSTNAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=phd.getString("MIDDLENAME")%>"
						name="MIDDLENAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=phd.getString("LASTNAME")%>"
						name="LASTNAME" size="15"></td>

					<%-- Get the COLLEGE --%>

					<td>
					<select name="DEGREE" class="input-small">
							<%
							   String dataDegree = phd.getString("degree_name");
								for(String degree : list) {
									if(degree.startsWith("PhD_"))
									{
							%>
							<option value="<%=degree%>" <%=dataDegree.equals(degree) ? "selected" : ""%> ><%=degree%></option>
							<%
								}}
							%>
					</select>
					</td>

					<td><input type="checkbox"
						<%=(phd.getString("ENROLLED_STATUS")).equals("1") ? "checked"
							: ""%>
						name="ENROLLEDSTATUS" size="15" , value="true"></td>

					
					
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA" <%=(phd.getString("resident_status")).equals("CA") ? "selected" : ""%>>CA</option>
					<option value="NONCA" <%=(phd.getString("resident_status")).equals("NONCA") ? "selected" : ""%>>NONCA</option>
					<OPTION value="International" <%=(phd.getString("resident_status")).equals("International") ? "selected" : ""%>>International</OPTION>
					</select></th>
					
					<th><select name="DEPARTMENT" class="input-small">
							<%
							   String dataDept = phd.getString("dept_name");
					
								for(String dept : depList) {
							
							%>
							<option value="<%=dept%>" <%=dataDept.equals(dept) ? "selected" : ""%> ><%=dept%></option>
							<%
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="CANDIDATE"
						size="5" <%=(phd.getString("candidate_status")).equals("1") ? "checked" : ""%>></th>
						<th><select name="NAME" class="input-small">
							<%
							String dataFac = phd.getString("faculty_name");
								for(String falc : facList) {
							%>
							<option value="<%=falc%>" <%=falc.equals(dataFac) ? "selected" : ""%>><%=falc%></option>
							<%
								}
							%>
					</select></th>
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="students.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=phd.getString("s_id")%>" name="ID"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
			<%
					}
			%>
			</table>	
			
			
			<hr>
			
				<h2>Undergraduate-Masters Students</h2>
		<table class="table table-hover table-bordered table-condensed" >
			<tr>

				<th>ID</th>
				<th>SSN</th>
				<th>First Name</th>
				<th>Middle Name</th>
				<th>Last Name</th>
				<th>Degree</th>
				<th>Enroll</br>Status</th>
				<th>Residency</th>
				<th>College</th>
				<th>Major</th>
				<th>Minor</th>

				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="insert_BSMS" name="action">
					<th><input type="text" class="input-small" value="" name="ID" size="10"></th>
					<th><input type="text" class="input-small" value="" name="SSN" size="10"></th>
					<th><input type="text" class="input-small" value="" name="FIRSTNAME" size="15"></th>
					<th><input type="text" class="span1" value="" name="MIDDLENAME" size="15"></th>
					<th><input type="text" class="input-small" value="" name="LASTNAME" size="15"></th>
					<th><select name="DEGREE" class="input-small">
							<%
								for(String degree : list) {
									if(degree.startsWith("BSMS_"))
									{
							%>
							<option value="<%=degree%>"><%=degree%></option>
							<%
								}
								}
							%>
					</select></th>
					<th><input type="checkbox" value="true" name="ENROLLEDSTATUS"
						size="5"></th>
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA">CA</option>
					<option value="NONCA">NONCA</option>
					<OPTION value="International">International</OPTION>
					</select></th>
					<th><select class="input-small" NAME="COLLEGE">
					<option value="Revelle College">Revelle College</option>
					<option value="John Muir College">John Muir College</option>
					<option value="Thurgood Marshall College">Thurgood Marshall College</option>
					<option value="Earl Warren College">Earl Warren College</option>
					<option value="Eleanor Roosevelt College">Eleanor Roosevelt College</option>
					<option value="Sixth College">Sixth College</option>
					</select></th>
					<th><p name="MAJOR"></th>
					<th><select name="MINOR" class="input-small">
					<option  selected value="" >No minor</option>
							<%
								for(String degree : list) {
									if(degree.startsWith("BS_")) {
										String s = degree.split("_")[1];
							%>
							<option value="<%=s%>"><%=s%></option>
							<%
									}
								}
							%>
					</select></th>
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
				</form>
			</tr>
			
			<%-- -------- Iteration Code -------- --%>
			<%


					while (underms.next()) {
				
			%>

			<tr>
				<form action="students.jsp" method="get">
					<input type="hidden" value="update_BSMS" name="action"> <input
						type="hidden" value="<%=underms.getString("s_id")%>" name="ID">
					<%-- Get the ID --%>
					<td>
						<p name="ID"><%=underms.getString("s_id")%></p>
					</td>
					<td><input type="text" class="input-small" value="<%=underms.getString("SSN")%>" name="SSN"
						size="10"></td>

					<%-- Get the FIRSTNAME --%>
					<td><input type="text" class="input-small" value="<%=underms.getString("FIRSTNAME")%>"
						name="FIRSTNAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="span1" value="<%=underms.getString("MIDDLENAME")%>"
						name="MIDDLENAME" size="15"></td>

					<%-- Get the LASTNAME --%>
					<td><input type="text" class="input-small" value="<%=underms.getString("LASTNAME")%>"
						name="LASTNAME" size="15"></td>

					<%-- Get the COLLEGE --%>

					<td>
					<select name="DEGREE" class="input-small">
							<%
							   String dataDegree = underms.getString("degree_name");
								for(String degree : list) {
									if(degree.startsWith("BSMS_"))
									{
							%>
							<option value="<%=degree%>" <%=dataDegree.equals(degree) ? "selected" : ""%> ><%=degree%></option>
							<%
								}}
							%>
					</select>
					</td>

					<td><input type="checkbox"
						<%=(underms.getString("ENROLLED_STATUS")).equals("1") ? "checked"
							: ""%>
						name="ENROLLEDSTATUS" size="15" , value="true"></td>

					
					
					<th><select name="RESIDENCY" class="input-small">
					<option value="CA" <%=(underms.getString("resident_status")).equals("CA") ? "selected" : ""%>>CA</option>
					<option value="NONCA" <%=(underms.getString("resident_status")).equals("NONCA") ? "selected" : ""%>>NONCA</option>
					<OPTION value="International" <%=(underms.getString("resident_status")).equals("International") ? "selected" : ""%>>International</OPTION>
					</select></th>
					<th><select class="input-small" NAME="COLLEGE">
					<option value="Revelle College" <%=(underms.getString("college")).equals("Revelle College") ? "selected" : ""%>>Revelle College</option>
					<option value="John Muir College" <%=(underms.getString("college")).equals("John Muir College") ? "selected" : ""%>>John Muir College</option>
					<option value="Thurgood Marshall College" <%=(underms.getString("college")).equals("Thurgood Marshall College") ? "selected" : ""%>>Thurgood Marshall College</option>
					<option value="Earl Warren College" <%=(underms.getString("college")).equals("Earl Warren College") ? "selected" : ""%>>Earl Warren College</option>
					<option value="Eleanor Roosevelt College" <%=(underms.getString("college")).equals("Eleanor Roosevelt College") ? "selected" : ""%>>Eleanor Roosevelt College</option>
					<option value="Sixth College" <%=(underms.getString("college")).equals("Sixth College") ? "selected" : ""%>>Sixth College</option>
					</select></th>
				<td><p name="MAJOR"><%=underms.getString("major")%></p></td>
					
					<th><select name="MINOR" class="input-small">
					<option <%= underms.getString("minor").equals("")? "selected" :"" %> value="">No minor</option>
							<%
							for(String degree : list) {
									if(degree.startsWith("BS_")) {
										String ss = degree.split("_")[1];
							%>
							<option value="<%=ss%>" <%=underms.getString("minor").equals(ss)?"selected":""%>><%=ss%></option>
							<%
									}
							}
							%>
					</select></th>
					
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="students.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=underms.getString("s_id")%>" name="ID"> 

					<%-- Button --%>
					<td><input  class="btn btn-info" class="btn btn-info" type="submit" value="Delete"></td>
				</form>
			</tr>
			<%
					}
			%>
			</table>
			<hr>	
			<%-- -------- Close Connection Code -------- --%>
			<%
				    rsDegree.close();
					stat.close();
					// Close the ResultSet
					under.close();
					master.close();
					phd.close();
					
					// Close the Statement
					statement1.close();
					statement2.close();
					statement3.close();
					statement4.close();
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
