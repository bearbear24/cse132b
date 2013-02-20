<html>
<head>
<link rel="stylesheet" href="css/table.css" >
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>
<script>

</script>
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
    <li   class="active">
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
							.prepareStatement("INSERT INTO dbo.current_select (s_id,section_id,enroll_or_waitlist_status,units,grade_type) VALUES (?, ?, 'enrolled',?,?)");

					pstmt.setString(1, (request.getParameter("ID")));
					pstmt.setString(2, request.getParameter("SECTION"));
					pstmt.setFloat(3, new Float(request.getParameter("UNITS")));
					pstmt.setString(4, request.getParameter("GRADETYPE"));
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
							.prepareStatement("UPDATE current_select SET units = ?,grade_type=? WHERE s_id=? AND section_id=?");



					pstmt.setString(3, request.getParameter("ID"));
					pstmt.setString(1, request.getParameter("UNITS"));
					pstmt.setString(4, request.getParameter("SECTION"));
					pstmt.setString(2, request.getParameter("GRADETYPE"));
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
					
					PreparedStatement pstmt2 = conn
							.prepareStatement("DELETE FROM current_select WHERE s_id = ? AND section_id=?");

					pstmt2.setString(1, request.getParameter("ID"));
					pstmt2.setString(2, request.getParameter("SECTION"));
				
					pstmt2.execute();
					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>

		<%-- -------- Look Up Statement Code -------- --%>
		<%
		int Ufrom=0;
		int Uto=0;
		String GradeType="";
		List<String> secList = new ArrayList<String>();
		if (action != null && action.equals("lookup")) {
			// Create the statement
				
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				Statement statS = conn.createStatement();
				ResultSet rS = statS.executeQuery("SELECT section_id FROM section WHERE number='"+request.getParameter("NUMBER")+"' AND quarter_year='Winter 2013'");	

				while(rS.next())
				{
					secList.add(rS.getString("section_id"));
				}

				Statement statC = conn.createStatement();
				ResultSet rC = statS.executeQuery("SELECT units_from,units_to,grade FROM course WHERE number='"+request.getParameter("NUMBER")+"'");	
				while(rC.next())
				{
					Ufrom=rC.getInt("units_from");
					Uto=rC.getInt("units_to");
					GradeType=rC.getString("grade");
				}
		}	
		%>

		<%-- -------- Select Code -------- --%>
			<%
			// Create the statement
				Statement statement = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				Statement stat = conn.createStatement();
			
				ResultSet rs = statement.executeQuery("SELECT grade,grade_type,current_select.section_id AS section_id,course.number AS number,units,s_id,units_from,units_to FROM current_select,section,course WHERE current_select.section_id=section.section_id AND section.number=course.number");	
				
				Statement stat2 = conn.createStatement();
				ResultSet rsCourse= stat2.executeQuery("Select number from class WHERE quarter_year='Winter 2013'");
				List<String> courseList = new ArrayList<String>();
				while(rsCourse.next())
				{
					courseList.add(rsCourse.getString("number"));
				}

				
		%>
		<table class="table table-hover table-bordered" >
			<tr>

				<th>Student Id</th>
				<th>Course</th>
				<th>Section</br>
				<th>Units</th>
				<th>Grade Type</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="courseenroll.jsp" method="get">
					
					<th><input type="text" class="input-small" value="" name="ID" size="10"></th>
					<td>
						<% if(action==null || !action.equals("lookup"))
							{
							
							%>
					        <select name="NUMBER" class="span2">
							<%
								for(String course : courseList) {
							%>
							<option value="<%=course%>"><%=course%></option>
							<%
								}
							%>
					</select>
					<% } else{
						
						%>
						<input
						type="hidden" value="<%=request.getParameter("NUMBER")%>" name="NUMBER">
						<p name="NUMBER"><%=request.getParameter("NUMBER")%></p>
					
					<% }%>
					</td>
					<th><select name="SECTION" id="SECTION" class="span2" <%=action!=null &&action.equals("lookup")?"":"disabled" %> class="span1">
						<%
						if(action!=null &&action.equals("lookup"))
							for(String sec : secList){
			
						%>
							<option value=<%=sec%>><%=sec%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="UNITS" id="UNITS" class="span1" <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
						<%
							if(action!=null &&action.equals("lookup"))
							for(int i=Ufrom;i<=Uto;i++){
			
						%>
							<option value=<%=i%> <%=i==Ufrom ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="GRADETYPE" id="GRADETYPE" class="span2" <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
						<%
							if(action!=null &&action.equals("lookup"))
							{
								if(GradeType.equals("Letter/SU"))
								{
			
						%>
							
							<option value="Letter"  selected>Letter</option>
							<option value="SU">SU</option>
						<%
							}
								else{
							%>
							<option value=<%=GradeType%>  selected><%=GradeType%></option>
							<%}} %>
					</select></th>
					<%
							if(action==null || !action.equals("lookup")){
					%>
					<input type="hidden" value="lookup" name="action">
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Look Up"></th>
					<%} %>
					<%
							if(action!=null &&action.equals("lookup")){
					%>
					<input type="hidden" value="insert" name="action">
					<th colspan="2"><input  class="btn btn-info" type="submit" value="Insert"></th>
					<%} %>
				</form>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%

					while (rs.next()) {
						
		
			%>

			<tr>
				<form action="courseenroll.jsp" method="get">
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("s_id")%>" name="ID">
					<%-- Get the ID --%>
					<td>
						<p name="ID"><%=rs.getString("s_id")%></p>
					</td>
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("number")%>" name="NUMBER">
					<%-- Get the ID --%>
					<td>
						<p name="NUMBER"><%=rs.getString("number")%></p>
					</td>
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("section_id")%>" name="SECTION">
					<%-- Get the ID --%>
					<td>
						<p name="SECTION"><%=rs.getString("section_id")%></p>
					</td>

					<th><select name="UNITS" id="UNITS" class="span1" >
						<%
							int units=rs.getInt("units");
							int uf=rs.getInt("units_from");
							int ut=rs.getInt("units_to");
							for(int i=uf;i<=ut;i++){
			
						%>
							<option value=<%=i%> <%=i==units ? "selected" : ""%>><%=i%></option>
						<%
							}
							%>
					</select></th>
					<th><select name="GRADETYPE" id="GRADETYPE" class="span2" >
						<%
							
								if(rs.getString("grade").equals("Letter/SU"))
								{
			
						%>
							
							<option value="Letter" <%=rs.getString("grade_type").equals("Letter")?"selected":"" %>>Letter</option>
							<option value="SU" <%=rs.getString("grade_type").equals("Letter")?"":"selected" %>>SU</option>
						<%
							}
								else{
							%>
							<option value=<%=rs.getString("grade_type")%>  selected><%=rs.getString("grade_type")%></option>
							<%} %>
					</select></th>
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="courseenroll.jsp" method="get">
				<input type="hidden" value="delete" name="action">
					<input
						type="hidden" value="<%=rs.getString("s_id")%>" name="ID">
					<input
						type="hidden" value="<%=rs.getString("section_id")%>" name="SECTION">
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
