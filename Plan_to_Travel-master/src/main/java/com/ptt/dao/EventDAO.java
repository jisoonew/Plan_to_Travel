package com.ptt.dao;

import java.util.List;
import java.util.Map;

import com.ptt.model.EventVO;
import com.ptt.model.ScheduleVO;

public interface EventDAO {
	public void insert_event(EventVO vo);
	
	public void event_delete(String event_id);
	
	public boolean event_Chk(String sche_id, String event_date);
	
	// 처음 event 삽입시 수정
	public void event_change(EventVO vo) throws Exception;
	
	// REevent 수정
		public void REevent_change(EventVO vo) throws Exception;
		
		// REevent 수정
		public void REnum_change(EventVO num_vo) throws Exception;
		
		public List<EventVO> event_print(String event_id) throws Exception;
		
		public void event_delete(EventVO del_vo) throws Exception;
		
		public int event_count(String card_uuid) throws Exception;
		
		public List<EventVO> latlng_print(Map<String, Object> params);
}
