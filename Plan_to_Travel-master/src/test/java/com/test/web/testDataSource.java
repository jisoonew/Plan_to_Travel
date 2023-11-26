package com.test.web;

import java.sql.Connection;

import javax.inject.Inject;
import javax.sql.DataSource;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;

@WebAppConfiguration
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations ={"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class testDataSource {

	 @Inject
	 @Qualifier("datasource")
	    private DataSource ds;

	    @Test
	    public void testDS() throws Exception{
	        try(Connection con = ds.getConnection()){
	            System.out.println("dataSource설정 성공");
	            System.out.println(con);
	        }catch(Exception e){
	            System.out.println("실패");
	            e.printStackTrace();
	        }
	    }
}
