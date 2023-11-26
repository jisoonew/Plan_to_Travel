package com.ptt.mapper;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import com.ptt.model.HistoryVO;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class HISTORYMAPPERtest {
	
	@Autowired
	//HistoryMapper.java 인터페이스 의존성 주입
	private HistoryMapper historymapper;
	
	@Test
	public void selectHistory() throws Exception{
		
		HistoryVO history = new HistoryVO();
		
		history.setuID("id");
		System.out.println(history.getuID());
		
		historymapper.selectHistory(history);
		System.out.println("결과 값 : " + historymapper.selectHistory(history));
		System.out.println(history.getuID());
	}

}