package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.Date;

public class Test {
	public static void main(String[] srgs) {
	try{
		DriverManager.registerDriver(new com.microsoft.sqlserver.jdbc.SQLServerDriver());

	Connection conn = DriverManager.getConnection("jdbc:sqlserver://localhost:1433;databaseName=cse132b","sa", "wangchunyan");


	String date = "2012-02-12";
	String time = "12:20";
	
	
	Calendar c = Calendar.getInstance();
	c.set(2013, 02, 20, 13, 20);
	Calendar c2 = Calendar.getInstance();
	c2.set(2013, 02,18,13,20);
	//System.out.print(c.after(c2));
	PreparedStatement pstmt = conn.prepareStatement("insert into test values(?,?)");
	pstmt.setTimestamp(1, new java.sql.Timestamp(c.getTimeInMillis()));
	pstmt.setInt(2, 3);
	pstmt.execute();
	
	pstmt = conn.prepareStatement("insert into test values(?,?)");
	pstmt.setTimestamp(1, new java.sql.Timestamp(c2.getTimeInMillis()));
	pstmt.setInt(2, 5);
	pstmt.execute();
	
	Date s2 = null;
	Date s1 = null;
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select * from test");
	while(rs.next()) {
		if(rs.getInt("id") == 5) {
			s1 = rs.getTime("time");
			System.out.print(s1);
			s1 =rs.getDate("time");
			System.out.print(s1);
		}
		if(rs.getInt("id")==4) {
			s2 = rs.getTimestamp("time");
		}
	}
	
	String d = s1.toString();
	System.out.print(d);
	conn.close();
	} catch (SQLException sqle) {
		sqle.printStackTrace();
	} catch (Exception e) {
		e.printStackTrace();
	}
	}

}
