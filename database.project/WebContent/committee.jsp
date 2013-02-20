<html>
<head>
<link rel="stylesheet" href="css/table.css" >
<link href="css/bootstrap.min.css" rel="stylesheet" media="screen">
<script src="js/bootstrap.min.js"></script>
<script>
function check()
{
	var obj=document.getElementById("FAC1");
	var options = obj.options;
	var count=0;
	for(var i=0;i<options.length;i++)
	{
		if(options[i].selected)
			count=count+1;
	}
	if(count<3)
		alert("Please select at least 3 professors from the same department.");
	else
		document.getElementById("formsubmit").submit();
	
	
}
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
     <li>
        <a href="pastcourse.jsp">Classes taken</a>
     </li>
         <li  class="active">
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
					String fac1[]=request.getParameterValues("FAC1");
					String fac2[]=request.getParameterValues("FAC2");
					for(String f : fac1)
					{
						System.out.print("fac1=" +f);
						PreparedStatement pstmt = conn
								.prepareStatement("INSERT INTO dbo.committee (faculty_name, s_id) VALUES (?, ?)");
	
						pstmt.setString(1, f);
						pstmt.setString(2, request.getParameter("ID"));
						int rowCount = pstmt.executeUpdate();
					}
					for(String f : fac2)
					{
						System.out.print("fac2=" +f);
						if(f=="")
							continue;
						PreparedStatement pstmt = conn
								.prepareStatement("INSERT INTO dbo.committee (faculty_name, s_id) VALUES (?, ?)");
						System.out.print("fac2=" +f);
	
						pstmt.setString(1, f);
						pstmt.setString(2, request.getParameter("ID"));
						int rowCount = pstmt.executeUpdate();
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
							.prepareStatement("DELETE FROM committee WHERE s_id = ?");

					pstmt.setString(1, request.getParameter("ID"));
					int rowCount = pstmt.executeUpdate();

					// Commit transaction
					conn.commit();
					conn.setAutoCommit(true);
				}
		%>
	<%-- -------- Look Up Statement Code -------- --%>
		<%
		String d_type="";
		List<String> sameList = new ArrayList<String>();
		List<String> diffList = new ArrayList<String>();
		String deptname="";
		String sid=request.getParameter("ID");
		if (action != null && action.equals("lookup")) {
			// Create the statement
				
				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				Statement statS = conn.createStatement();
				ResultSet rC = statS.executeQuery("SELECT degree_type,dept_name FROM graduate WHERE s_id='"+request.getParameter("ID")+"'");	
				while(rC.next())
				{
					d_type=rC.getString("degree_type");
					deptname=rC.getString("dept_name");
				}
				Statement stat3 = conn.createStatement();
				ResultSet rsFac = stat3.executeQuery("Select faculty_name from faculty WHERE dept_name='"+deptname+"' AND (title='Professor' or title='Assistant Professor' or title='Associate Professor')");
				Statement stat2 = conn.createStatement();
				ResultSet rdFac = stat2.executeQuery("Select faculty_name from faculty WHERE dept_name!='"+deptname+"' AND (title='Professor' or title='Assistant Professor' or title='Associate Professor')");
		
				while(rsFac.next())
					sameList.add(rsFac.getString("faculty_name"));
				while(rdFac.next())
					diffList.add(rdFac.getString("faculty_name"));

				
			
		}	
		%>
		<%-- -------- SELECT Statement Code -------- --%>
		<%
			// Create the statement
				Statement statement = conn.createStatement();

				// Use the created statement to SELECT
				// the student attributes FROM the Student table.
				ResultSet rs = statement.executeQuery("Select DISTINCT graduate.s_id AS s_id,dept_name,degree_type from committee left outer join graduate ON committee.s_id=graduate.s_id");
			    Statement stat = conn.createStatement();

		%>
			
		<table class="table table-hover table-bordered" >
			<tr>

				<th>Student ID</th>
				<th>Degree Type</th>
				<th>Department</th>
				<th>Faculty from the same department</th>
				<th>Faculty from other departments</th>
				<th>Action</th>
			</tr>
			<tr>
				<form id="formsubmit" action="committee.jsp" method="get">
					
					<th><input type="text" class="input-small" value="<%=action!=null &&action.equals("lookup")? sid:""%>" name="ID" size="10"></th>
					<td>
						<p name="ID"><%=action!=null &&action.equals("lookup")? d_type:""%></p>
					</td>
					<td>
						<p name="DEPT"><%=action!=null &&action.equals("lookup")? deptname:""%></p>
					</td>
					<th><select name="FAC1" ID="FAC1" class="span3" multiple <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
							<%
								for(String fac : sameList) {
							%>
							<option value="<%=fac%>"><%=fac%></option>
							<%
								}
							%>
					</select></th>
					<th><select name="FAC2" ID="FAC2" class="span3" multiple <%=action!=null &&action.equals("lookup")?"":"disabled" %>>
							
							<%
								if(d_type.equals("MS")){
									%>
									<option value="" <%=action!=null &&action.equals("lookup")? "selected":"" %>></option>
									<% }
								for(String fac : diffList) {
									
							%>
							<option value="<%=fac%>"><%=fac%></option>
							<%
								}
							%>
					</select></th>
					<%
							if(action==null || !action.equals("lookup")){
					%>
					<input type="hidden" value="lookup" name="action">
					<th><input  class="btn btn-info" type="submit" value="Look Up"></th>
					<%} %>
					<%
							if(action!=null &&action.equals("lookup")){
					%>
					<input type="hidden" value="insert" name="action">
					<th><input  class="btn btn-info"  onclick="check();" value="Insert"></th>
					<%} %>
				</form>
			</tr>

			<%-- -------- Iteration Code -------- --%>
			<%

					while (rs.next()) {
						Statement facstate1 = conn.createStatement();
						Statement facstate2 = conn.createStatement();
						ResultSet fac1 = facstate1.executeQuery("Select faculty.faculty_name as faculty_name from committee,faculty WHERE committee.s_id='"+rs.getString("s_id")+"' AND faculty.dept_name='"+rs.getString("dept_name")+"' AND committee.faculty_name=faculty.faculty_name");
						ResultSet fac2 = facstate2.executeQuery("Select faculty.faculty_name as faculty_name from committee,faculty WHERE committee.s_id='"+rs.getString("s_id")+"' AND faculty.dept_name!='"+rs.getString("dept_name")+"' AND committee.faculty_name=faculty.faculty_name");

			%>

			<tr>
			
					<td>
						<p name="ID"><%=rs.getString("s_id")%></p>
					</td>

					<td>
						<p><%=rs.getString("degree_type")%></p>
					</td>
					<td>
						<p><%=rs.getString("dept_name")%></p>
					</td>
				<th><select name="FAC1" ID="FAC1" class="span3" multiple>
							<%
								while(fac1.next()) {
									System.out.println(fac1.getString("faculty_name"));
							%>
							<option value="<%=fac1.getString("faculty_name")%>" selected><%=fac1.getString("faculty_name")%></option>
							<%
								}
							%>
					</select></th>
					<th><select name="FAC2" ID="FAC2" class="span3" multiple>
							
							<%
								
								
									while(fac2.next()) {
								%>
								<option value="<%=fac2.getString("faculty_name")%>" selected><%=fac2.getString("faculty_name")%></option>
								<%
									}
								%>
					</select></th>

					<%-- Button --%>
					
				<form action="committee.jsp" method="get">
					<input type="hidden" value="delete" name="action"> <input
						type="hidden" value="<%=rs.getString("s_id")%>" name="ID"> 

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
