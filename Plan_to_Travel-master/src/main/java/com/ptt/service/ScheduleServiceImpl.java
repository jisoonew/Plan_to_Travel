package com.ptt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ptt.mapper.LocationMapper;
import com.ptt.mapper.ScheduleMapper;
import com.ptt.model.EventVO;
import com.ptt.model.ScheduleVO;

@Service
public class ScheduleServiceImpl implements ScheduleService {
	@Autowired
	LocationMapper locationMapper;
	
	@Autowired
	ScheduleMapper schedulemapper;
	
	//스케줄 데이터 출력
	public List<ScheduleVO> Schedule_print(Map<String, Object> response) throws Exception {

		return locationMapper.Schedule_print(response);
	}
	
	//히스토리 목록 불러오기
	@Override
    public List<ScheduleVO> selectHistory(ScheduleVO history) throws Exception {
        return schedulemapper.selectHistory(history);
    }
	
	//히스토리 클릭 후 해당 스케줄 표 불러오기
    @Override
    public List<EventVO> getSchedule(String sche_id) {
        return schedulemapper.getSchedule(sche_id);
    }
    
    //히스토리 삭제 (스케줄 삭제)
    @Override
    public void deleteSchedule(String sche_id) {
        // 여기에서 ScheduleMapper를 이용하여 DB에서 해당 scheduleId에 해당하는 데이터를 삭제하는 로직을 작성
        schedulemapper.deleteSchedule(sche_id);
    }
	
	@Override
	public boolean sche_Chk(String sche_id) {
        return locationMapper.sche_Chk(sche_id);
	}

	@Override
	public List<ScheduleVO> schedule_change(Map<String, Object> response) throws Exception {
		return locationMapper.schedule_change(response);
	}
}
