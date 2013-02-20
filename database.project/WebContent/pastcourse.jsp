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
    <li>
        <a href="courseenroll.jsp">Course Enrollment</a>
    </li>
     <li class="active">
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
							.prepareStatement("INSERT INTO dbo.have_taken (s_id,section_id,grade,units) VALUES (?, ?, ?,?)");

					pstmt.setString(1, (request.getParameter("ID")));
					pstmt.setString(2, request.getParameter("SECTION"));
					pstmt.setString(3, request.getParameter("GRADE"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("UNITS")) );
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
							.prepareStatement("UPDATE have_taken SET grade = ?,units=? WHERE s_id=? AND section_id=?");



					pstmt.setString(3, request.getParameter("ID"));
					pstmt.setString(1, request.getParameter("GRADE"));
					pstmt.setString(4, request.getParameter("SECTION"));
					pstmt.setInt(2, Integer.parseInt(request.getParameter("UNITS")) );
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
							.prepareStatement("DELETE FROM have_taken WHERE s_id = ? AND section_id=?");

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
		String gradeType="";
		List<String> secList = new ArrayList<String>();

		int units_from=0;
		int units_to=0;
		if (action != null && action.equals("lookup")) {
			// Create the statement
				
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				Statement statS = conn.createStatement();
				ResultSet rS = statS.executeQuery("SELECT section_id FROM section WHERE number='"+request.getParameter("NUMBER")+"' AND quarter_year='"+request.getParameter("QUARTERYEAR")+"'");	

				while(rS.next())
				{
					secList.add(rS.getString("section_id"));
				}

				Statement statC = conn.createStatement();
				ResultSet rC = statS.executeQuery("SELECT grade,units_from,units_to FROM course WHERE number='"+request.getParameter("NUMBER")+"'");	
				while(rC.next())
				{
					gradeType=rC.getString("grade");
					units_from=rC.getInt("units_from");
					units_to=rC.getInt("units_to");
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

				ResultSet rs = statement.executeQuery("SELECT units_from,units_to,have_taken.units as units,s_id,have_taken.section_id AS section_id,course.number AS number,quarter_year,have_taken.grade AS grade, course.grade AS gradeType FROM have_taken,section,course WHERE have_taken.section_id=section.section_id AND section.number=course.number");	
		
				Statement stat2 = conn.createStatement();
				ResultSet rsCourse= stat2.executeQuery("Select number from course");
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
				<th>Quarter Year</th>
				<th>Section</br>
				<th>Grade</th>
				<th>Units</th>
				<th colspan="2">Action</th>
			</tr>
			<tr>
				<form action="pastcourse.jsp" method="get">
					
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
					<td>
						<% if(action==null || !action.equals("lookup"))
							{
							
							%><select name="QUARTERYEAR" class="span2">
						<option value="Winter 2013" selected>2013 Winter</option>
						<%
							for(int i=2012;i>=2000;i--)
							{
								String year=Integer.toString(i);
							
						%>
							<option value="Fall <%=year%>">Fall <%=year%></option>
							<option value="Winter <%=year%>">Winter <%=year%></option>
							<option value="Spring <%=year%>">Spring <%=year%></option>
							<%
								}
							%>
					</select><% } else{
						
						%>
						<input
						type="hidden" value="<%=request.getParameter("QUARTERYEAR")%>" name="QUARTERYEAR">
						<p name="QUARTERYEAR"><%=request.getParameter("QUARTERYEAR")%></p>
					
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
					<th><select name="GRADE" id="GRADE" class="span1" <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
						<%
							
							if(action!=null && action.equals("lookup"))
							{
							
								if(gradeType.equals("Letter"))
								{
									
									%>
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
									<%
								}
								else if(gradeType.equals("SU"))
								{
									%>
									<option value="S" selected>S</option>
									<option value="U">U</option>
								
									<%
								}
								else if(gradeType.equals("Letter/SU"))
								{
									%>
									<option value="A" selected>A</option>
									<option value="B">B</option>
									<option value="C">C</option>
									<option value="D">D</option>
									<option value="F">F</option>
									<option value="S">S</option>
									<option value="U">U</option>
								
									<%
								}
							}
						%>
					</select></th>
					<th><select name="UNITS" id="GRADE" class="span1" <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
						<%
							
							if(action!=null && action.equals("lookup"))
							{
							
								
									for(int i=units_from; i<=units_to;i++)
									{
									%>
									<option value="<%=i%>"><%=i%></option>
								
								
									<%
								}
								
							}
						%>
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
				<form action="pastcourse.jsp" method="get">
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
						type="hidden" value="<%=rs.getString("quarter_year")%>" name="QUARTERYEAR">
					<%-- Get the ID --%>
					<td>
						<p name="QUARTERYEAR"><%=rs.getString("quarter_year")%></p>
					</td>
					<input type="hidden" value="update" name="action"> <input
						type="hidden" value="<%=rs.getString("section_id")%>" name="SECTION">
					<%-- Get the ID --%>
					<td>
						<p name="SECTION"><%=rs.getString("section_id")%></p>
					</td>

					<th><select name="GRADE" id="GRADE" class="span1" >
						<%
							
							
								String gradeT=rs.getString("gradeType");
								if(gradeT.equals("Letter"))
								{
									
									%>
									<option value="A" <%=rs.getString("grade").equals("A")? "selected":"" %>>A</option>
									<option value="B" <%=rs.getString("grade").equals("B")? "selected":"" %>>B</option>
									<option value="C" <%=rs.getString("grade").equals("C")? "selected":"" %>>C</option>
									<option value="D" <%=rs.getString("grade").equals("D")? "selected":"" %>>D</option>
									<option value="F" <%=rs.getString("grade").equals("E")? "selected":"" %>>F</option>
									<%
								}
								else if(gradeT.equals("SU"))
								{
									%>
									<option value="S" <%=rs.getString("grade").equals("S")? "selected":"" %>>U</option>
									<option value="U" <%=rs.getString("grade").equals("U")? "selected":"" %>>U</option>
								
									<%
								}
								else if(gradeT.equals("Letter/SU"))
								{
									%>
									<option value="A" <%=rs.getString("grade").equals("A")? "selected":"" %>>A</option>
									<option value="B" <%=rs.getString("grade").equals("B")? "selected":"" %>>B</option>
									<option value="C" <%=rs.getString("grade").equals("C")? "selected":"" %>>C</option>
									<option value="D" <%=rs.getString("grade").equals("D")? "selected":"" %>>D</option>
									<option value="F" <%=rs.getString("grade").equals("E")? "selected":"" %>>F</option>	<option value="S" <%=rs.getString("grade").equals(gradeT)? "selected":"" %>>S</option>
									<option value="S" <%=rs.getString("grade").equals("S")? "selected":"" %>>U</option>
									<option value="U" <%=rs.getString("grade").equals("U")? "selected":"" %>>U</option>
								
									<%
								}
							
						%>
					</select></th>
					<th><select name="UNITS" id="GRADE" class="span1">
						<%
							
							
								
									for(int i=rs.getInt("units_from"); i<=rs.getInt("units_to");i++)
									{
									%>
									<option value="<%=i%>" <%=rs.getInt("units")==i ?"selected":"" %>><%=i%></option>
								
								
									<%
								}
								
							
						%>
					</select></th>
					<%-- Button --%>
					<td><input  class="btn btn-info" type="submit" value="Update"></td>
		        </form>

				<form action="pastcourse.jsp" method="get">
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
