package com.ptt.service;

import java.util.List;
import java.util.Map;

import com.ptt.model.EventVO;
import com.ptt.model.ScheduleVO;

public interface ScheduleService {
	// 스케줄 데이터 출력
	public List<ScheduleVO> Schedule_print(Map<String, Object> response) throws Exception;
		
	public boolean sche_Chk(String sche_id);
		
	// 스케줄 수정
	public List<ScheduleVO> schedule_change(Map<String, Object> response) throws Exception;

	//히스토리 목록 불러오기
	public List<ScheduleVO> selectHistory(ScheduleVO history) throws Exception;
	
	//히스토리 클릭 후 해당 스케줄 표 불러오기
	public List<EventVO> getSchedule(String sche_id) throws Exception;
	
	//히스토리 삭제 (스케줄 삭제)
	public void deleteSchedule(String sche_id) throws Exception;
}