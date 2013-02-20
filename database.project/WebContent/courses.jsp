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
    <li class="active">
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
    <li>
        <a href="degree.jsp">Degree requirement</a>
    </li>
</ul>
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
							.prepareStatement("INSERT INTO dbo.course (number, dept_name, units_from, units_to, grade,division, consent,labwork) VALUES (?, ?, ?,?,?,?,?,?)");

					pstmt.setString(1, (request.getParameter("NUMBER")));
					pstmt.setString(3, request.getParameter("UNITSFROM"));
					pstmt.setString(2, request.getParameter("DEPARTMENT"));
					pstmt.setString(4, request.getParameter("UNITSTO"));
					pstmt.setString(5, request.getParameter("GRADE"));
					pstmt.setString(6, request.getParameter("DIVISION"));
					pstmt.setBoolean(7, new Boolean(request.getParameter("CONSENT")));
					pstmt.setBoolean(8, new Boolean(request.getParameter("LABWORK")));
					int rowCount = pstmt.executeUpdate();
					
					// Commit transaction
					
					String pres[]=request.getParameterValues("PREREQUISITE");
			
					for(String p : pres)
					{
						if(p=="")
							continue;
						PreparedStatement psPre = conn
								.prepareStatement("INSERT INTO dbo.prerequisite (number1, number2) VALUES (?, ?)");
						psPre.setString(1, (request.getParameter("NUMBER")));
						psPre.setString(2, p);
						psPre.execute();
					}
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
							.prepareStatement("UPDATE course SET dept_name = ?, units_from = ?, units_to = ?, grade = ?, division = ?, consent = ?, labwork = ? "
									+ "WHERE number = ?");

					pstmt.setString(8, request.getParameter("NUMBER"));
					pstmt.setString(2, request.getParameter("UNITSFROM"));
					pstmt.setString(1, request.getParameter("DEPARTMENT"));
					pstmt.setString(3, request.getParameter("UNITSTO"));
					pstmt.setString(4, request.getParameter("GRADE"));
					pstmt.setString(5, request.getParameter("DIVISION"));
					pstmt.setBoolean(6, new Boolean(request.getParameter("CONSENT")));
					pstmt.setBoolean(7, new Boolean(request.getParameter("LABWORK")));

					int rowCount = pstmt.executeUpdate();
					String pres[]=request.getParameterValues("PREREQUISITE");
					PreparedStatement pst = conn
							.prepareStatement("DELETE FROM prerequisite WHERE number1 = ?");
					pst.setString(1, (request.getParameter("NUMBER")));
					pst.execute();
					for(String p : pres)
					{
						if(p=="")
							continue;
						PreparedStatement psPre = conn
								.prepareStatement("INSERT INTO dbo.prerequisite (number1, number2) VALUES (?, ?)");
						psPre.setString(1, (request.getParameter("NUMBER")));
						psPre.setString(2, p);
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
							.prepareStatement("DELETE FROM prerequisite WHERE number1 = ? or number2 = ?");
					PreparedStatement pstmt2 = conn
							.prepareStatement("DELETE FROM course WHERE number = ?");

					pstmt.setString(1, request.getParameter("NUMBER"));
					pstmt.setString(2, request.getParameter("NUMBER"));
					pstmt2.setString(1, request.getParameter("NUMBER"));
					int rowCount = pstmt.executeUpdate();
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
				Statement stat = conn.createStatement();
				ResultSet rsDept = stat.executeQuery("Select dept_name from department");
				ResultSet rs = statement.executeQuery("SELECT * FROM course");	
				List<String> depList = new ArrayList<String>();
				while(rsDept.next())
					depList.add(rsDept.getString("dept_name"));
				Statement stat2 = conn.createStatement();
				ResultSet rsPre= stat2.executeQuery("Select number from course");
				List<String> preList = new ArrayList<String>();
				while(rsPre.next())
				{
					preList.add(rsPre.getString("number"));
				}

				
		%>

		<table class="table table-hover table-bordered" >
			<tr>

				<th>Number</th>
				<th>Department</th>
				<th>Units</br>From</th>
				<th>Units</br>To</th>
				<th>Grade</th>
				<th>Division</th>
				<th>Consent</th>
				<th>Lab</br>Work</th>
				<th>Prerequisites</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="courses.jsp" method="get">
					<input type="hidden" value="insert" name="action">
					<th><input type="text" class="input-small" value="" name="NUMBER" size="50"></th>
					<th><select name="DEPARTMENT" class="span2">
							<%
								for(String dept : depList) {
							%>
							<option value="<%=dept%>"><%=dept%></option>
							<%
								}
							%>
					</select></th>
					<th><select name="UNITSFROM" id="UNITSFROM0" class="span1">
						<%
							for(int i=1;i<=12;i++){
			
						%>
							<option value=<%=i%> <%=i==4 ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="UNITSTO" id="UNITSFTO0" class="span1">
						<%
							for(int i=1;i<=12;i++){
			
						%>
							<option value=<%=i%> <%=i==4 ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="GRADE" class="span2">
					<option value="Letter">Letter</option>
					<option value="SU">SU</option>
					<OPTION value="Letter/SU">Letter/SU</OPTION>
					</select>
					<th><select name="DIVISION" class="span2">
					<option value="Upper">Upper</option>
					<option value="Lower">Lower</option>
					<OPTION value="Graduate">Graduate</OPTION>
					</select>
					<th><input type="checkbox" value="true" name="CONSENT"></th>
					<th><input type="checkbox" value="true" name="LABWORK"></th>
					<th><select name="PREREQUISITE" class="span2" multiple>
						<option selected value="">Empty</option>
							<%
								for(String pre : preList) {
									
							%>
							<option value="<%=pre%>"><%=pre%></option>
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
						Statement stat3 = conn.createStatement();
						System.out.println("tttt");
						ResultSet rsSelectedPre= stat3.executeQuery("Select number2 from prerequisite WHERE number1='"+rs.getString("number")+"'");
						HashMap<String,String> preSelected = new HashMap<String,String>();
						while(rsSelectedPre.next())
						{
							preSelected.put(rsSelectedPre.getString("number2"),"");
						}
						System.out.println("tttt");
			%>

			<tr>
				<form action="courses.jsp" method="get">
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("number")%>" name="NUMBER">
					<%-- Get the ID --%>
					<td>
						<p name="NUMBER"><%=rs.getString("NUMBER")%></p>
					</td>

					<%-- Get the COLLEGE --%>


					<td><select name="DEPARTMENT" class="span2">
							<%
							   String dataDept = rs.getString("dept_name");
								for(String dept : depList) {
							%>
							<option value="<%=dept%>" <%=dataDept.equals(dept) ? "selected" : ""%> ><%=dept%></option>
							<%
								}
							%>
					</select></td>
										<td><select name="UNITSFROM" class="span1">
						<%
							for(int i=1;i<=12;i++){
			
						%>
							<option value=<%=i%> <%=rs.getInt("units_from")==i ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="UNITSTO" class="span1">
						<%
							for(int i=1;i<=12;i++){
			
						%>
							<option value=<%=i%> <%=rs.getInt("units_to")==i ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="GRADE" class="span2">
					<option value="Letter" <%=rs.getString("grade").equals("Letter") ? "selected" : ""%>>Letter</option>
					<option value="SU" <%=rs.getString("grade").equals("SU") ? "selected" : ""%>>SU</option>
					<OPTION value="Letter/SU" <%=rs.getString("grade").equals("Letter/SU") ? "selected" : ""%>>Letter/SU</OPTION>
					</select>
					<th><select name="DIVISION" class="span2">
					<option value="Upper" <%=rs.getString("division").equals("Upper") ? "selected" : ""%>>Upper</option>
					<option value="Lower" <%=rs.getString("division").equals("Lower") ? "selected" : ""%>>Lower</option>
					<OPTION value="Graduate" <%=rs.getString("division").equals("Graduate") ? "selected" : ""%>>Graduate</OPTION>
					</select>
					<th><input type="checkbox" value="true" <%=rs.getBoolean("consent") ? "checked": "" %> name="CONSENT"></th>
					<th><input type="checkbox" value="true" <%=rs.getBoolean("labwork") ? "checked": "" %> name="LABWORK"></th>
					<th><select name="PREREQUISITE" class="span2" multiple>
						<option <%= preSelected.size()==0 ? "selected": "" %> value="">Empty</option>
						
							<%
								for(String pre : preList) {
									if(!rs.getString("number").equals(pre)){
							%>
							<option value="<%=pre%>" <%= preSelected.containsKey(pre)? "selected": "" %>><%=pre%></option>
							
							<%
									}
								}
							%>
					</select></th>

					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="courses.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("number")%>" name="NUMBER"> 

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
					stat.close();
					stat2.close();
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
