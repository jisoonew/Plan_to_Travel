package com.ptt.service;

import java.util.List;

import com.ptt.model.HistoryVO;
import com.ptt.model.ScheduleVO;

public interface HistoryService {
	
	public List<HistoryVO> selectHistory(HistoryVO history) throws Exception;
	
	public List<ScheduleVO> getSchedule(String schedule_UUID) throws Exception;
	
}