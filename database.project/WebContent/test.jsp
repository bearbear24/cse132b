<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date" %>
<%
try{
	DriverManager
	.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

Connection conn = DriverManager.getConnection(
	"jdbc:sqlserver://localhost:1433;databaseName=cse132b",
	"sa", "wangchunyan");

%>
<%-- insert  --%>
<%
Date t = new Date();
t.parse("2012-02-04 12:30");
Statement stme = conn.createStatement();
stme.execute("Insert into test values(1, '"+ t +"')");


%>
<%
conn.close();
} catch (SQLException e) {
	e.printStackTrace();
} catch (Exception e) {
	e.printStackTrace();
}
%>
</body>
</html>