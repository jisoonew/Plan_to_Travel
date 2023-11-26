package com.ptt.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.stereotype.Service;

import com.ptt.mapper.LocationMapper;
import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;

@Service
public class LocationServiceImpl implements LocationService {
	@Autowired
	LocationMapper locationMapper;
	
	@Inject // 의존관계를 자동으로 연결(JAVA에서 제공) ==@autowired (Spring에서 제공)
    private SqlSession sqlSession;
	
	@Override
	public boolean idCheck(String location_UUID, String location_ID) throws Exception {
		Map<String, Object> params = new HashMap<>();
        params.put("location_UUID", location_UUID);
        params.put("location_ID", location_ID);
        
        int count = locationMapper.idCheck(params);

        // count가 1 이상이면 데이터가 이미 존재하므로 사용할 수 없음을 의미
        return (int) count <= 0;
		/* return locationMapper.idCheck(location_UUID, location_ID); */
	}
	
	
	@Override
	public boolean scheduleCheck(String schedule_UUID, String schedule_ID) throws Exception {
		Map<String, Object> params = new HashMap<>();
        params.put("schedule_UUID", schedule_UUID);
        params.put("schedule_ID", schedule_ID);
        
        int count = locationMapper.scheduleCheck(params);

        // count가 1 이상이면 데이터가 이미 존재하므로 사용할 수 없음을 의미
        return (int) count <= 0;
		/* return locationMapper.idCheck(location_UUID, location_ID); */
	}
	
	@Override
	public boolean idmodifyCheck(String location_UUID, String location_ID) throws Exception {
		Map<String, Object> params = new HashMap<>();
        params.put("location_UUID", location_UUID);
        params.put("location_ID", location_ID);
        
        int count = locationMapper.idmodifyCheck(params);

        // count가 1 이상이면 데이터가 이미 존재하므로 사용할 수 없음을 의미
        return (int) count <= 0;
		/* return locationMapper.idCheck(location_UUID, location_ID); */
	}
	
	
	@Override
	public int schedulemodifyCheck(String schedule_UUID, String schedule_ID) throws Exception {
		Map<String, Object> params = new HashMap<>();
        params.put("schedule_UUID", schedule_UUID);
        params.put("schedule_ID", schedule_ID);
        
        int count = locationMapper.schedulemodifyCheck(params);

        // count가 1 이상이면 데이터가 이미 존재하므로 사용할 수 없음을 의미
        return count;
		/* return locationMapper.idCheck(location_UUID, location_ID); */
	}
	
	
	public List<LocationVO> Location_print(Map<String, Object> map) throws Exception {

		return locationMapper.Location_print(map);
	}
	
	@Override
	public List<LocationVO> Location_latlng(Map<String, Object> response) {
		return locationMapper.Location_latlng(response);
	}


	
}
