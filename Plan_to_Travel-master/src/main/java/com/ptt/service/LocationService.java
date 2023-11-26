package com.ptt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;

import com.ptt.dao.LocationDAO;
import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;


public interface LocationService {
    
	// 아이디 중복 검사
	public boolean idCheck(String location_UUID, String location_ID) throws Exception;
	
	// 스케줄 중복 검사
	public boolean scheduleCheck(String schedule_UUID, String schedule_ID) throws Exception;
	
	// 아이디 중복 검사
	public boolean idmodifyCheck(String location_UUID, String location_ID) throws Exception;
	
	// 스케줄 중복 검사
	public int schedulemodifyCheck(String schedule_UUID, String schedule_ID) throws Exception;
	
	public List<LocationVO> Location_print(Map<String, Object> map) throws Exception;

	public List<LocationVO> Location_latlng(Map<String, Object> response);
}
