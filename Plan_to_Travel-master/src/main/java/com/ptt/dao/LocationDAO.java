package com.ptt.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;

public interface LocationDAO {
	
	public void insertMember(LocationVO vo);
	
	public LocationVO selectMember(LocationVO vo);

	public int checkId(String location_UUID, String location_ID);

	public void change(LocationVO vo);
	
	// 출력
	public List<LocationVO> Location_print(Map<String, Object> map) throws Exception;
	
	public List<LocationVO> Location_latlng(Map<String, Object> response) throws Exception;
}
