package com.test.web;

import static org.junit.Assert.*;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

public class mysqlTest1 {

	 private static final String DRIVER = "com.mysql.jdbc.Driver";
	 private static final String URL = "jdbc:mysql://127.0.0.1:3306/plan_to_travel"; // jdbc:mysql://127.0.0.1:3306/여러분이 만드신 스키마이름
	 private static final String USER = "root"; //DB 사용자명
	 private static final String PW = "1234";   //DB 사용자 비밀번호
	 
	 @Test
	 public void testConnection() throws Exception{
	  Class.forName(DRIVER);
	  
	  try(Connection con = DriverManager.getConnection(URL, USER, PW)){
	   System.out.println("성공");
	   System.out.println(con);
	  }catch (Exception e) {
	   System.out.println("에러발생");
	   e.printStackTrace();
	  }
	 }

}
