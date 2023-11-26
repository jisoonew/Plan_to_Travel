package com.ptt.persistence;

import java.sql.Connection;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")

public class DATASOURCEtest {
    @Autowired
    private DataSource dataSource;
    
	/*
	 * @Test public void testConnection() {
	 * 
	 * try(Connection con = dataSource.getConnection();){
	 * 
	 * System.out.println("con = " + con);
	 * 
	 * } catch(Exception e) {
	 * 
	 * e.printStackTrace();
	 * 
	 * }
	 * 
	 * }
	 */
}

/*
 * ERROR 내용 Loading class 'com.mysql.jdbc.Driver'. This is deprecated. The new
 * driver class is 'com.mysql.cj.jdbc.Driver'. The driver is automatically
 * registered via the SPI and manual loading of the driver class is generally
 * unnecessary.
 * 
 * 답변 새로추가한 라이브러리를 사용해주기 위해서는 "net.sf.log4jdbc.sql.jdbcapi.DriverSpy"를 작성해주시면
 * 됩니다. 버전업이되면서 driverClassName이 변경이 된거 같습니다. 에러 경고 밑에 쿼리문 결과가 나온다면 내부적으로 알아서
 * 변경시켜주는 것이기 때문에 그냥 사용하셔도 무방합니다.
 */