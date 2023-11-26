package com.ptt.service;

import java.util.List;
import java.util.Map;

import com.ptt.model.EventVO;
import com.ptt.model.ScheduleVO;

public interface EventService {
	
	public boolean event_Chk(String sche_id, String event_date);
	
	public void event_change(EventVO vo) throws Exception;

	List<EventVO> event_print(String event_id) throws Exception;
	
	List<EventVO> latlng_print(Map<String, Object> params) throws Exception;
}
