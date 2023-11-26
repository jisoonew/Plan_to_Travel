package com.ptt.persistence;

import static org.junit.Assert.fail;

import java.sql.Connection;
import java.sql.DriverManager;

import org.junit.Test;

public class JDBCtest {
    static { 
        try { 
            Class.forName("net.sf.log4jdbc.sql.jdbcapi.DriverSpy"); 
        } catch(Exception e) { 
            e.printStackTrace(); 
        } 
    } 
    
    @Test 
    public void testConnection() { 
        try(Connection con = DriverManager.getConnection( 
                "jdbc:mysql://localhost:3306/ptt?serverTimezone=Asia/Seoul", 
                "root", 
                "1234")){ 
            System.out.println(con); 
        } catch (Exception e) { 
            fail(e.getMessage()); 
        } 
    
    }    
}