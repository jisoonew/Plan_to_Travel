package com.ptt.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ptt.mapper.LocationMapper;
import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;

@Repository // DAO라고 명시
public class ScheduleDAOImp implements ScheduleDAO{
    @Inject // 의존관계를 자동으로 연결(JAVA에서 제공) ==@autowired (Spring에서 제공)
    private SqlSession sqlSession;
   
    private static final String namespace = "com.ptt.mapper.LocationMapper";
                                            //memberMapper.xml의 namespace값
    
	@Override
	public void insertSchedule(ScheduleVO vo) {
		sqlSession.insert(namespace+".insertSchedule", vo);
	}

	@Override
	public void changeSchedule(ScheduleVO schedulevo) {
		sqlSession.update(namespace+".changeSchedule", schedulevo);
	}
	
	// 데이터 출력
    @Override
    public List<ScheduleVO> Schedule_print(Map<String, Object> response) throws Exception {
    	return sqlSession.selectList(namespace + ".Schedule_print", response);
    }
    
    
	@Override
	public void insertTest(ScheduleVO vo) {
		sqlSession.insert(namespace+".insertTest", vo);
	}
	
	@Override
	public int getMaxScheNum(String event_id) {
		return sqlSession.insert(namespace+".getMaxScheNum", event_id);
	};
	
	// 데이터 출력
    @Override
    public List<ScheduleVO> schedule_change(Map<String, Object> response) throws Exception {
    	return sqlSession.selectList(namespace + ".schedule_change", response);
    }
    
    @Override
    public void schedule_delete(String sche_id) {
    	Map<String, Object> params = new HashMap<>();
        params.put("sche_id", sche_id);
        sqlSession.delete("schedule_delete", params);
    }
}
