package com.ptt.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.ptt.model.EventVO;
import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;

@Repository
public class EventDAPImp implements EventDAO {
    @Inject // 의존관계를 자동으로 연결(JAVA에서 제공) ==@autowired (Spring에서 제공)
    private SqlSession sqlSession;
   
   
    private static final String namespace = "com.ptt.mapper.LocationMapper";
                                            //memberMapper.xml의 namespace값
    
    @Autowired
	private LocationDAO mapper;
   
    @Override
    public void insert_event(EventVO vo) {
        sqlSession.insert(namespace+".insert_event", vo);
    }
    
    @Override
    public void REinsert_event(EventVO vo) {
        sqlSession.insert(namespace+".REinsert_event", vo);
    }
    
    @Override
    public void event_delete(String event_id) {
    	Map<String, Object> params = new HashMap<>();
        params.put("event_id", event_id);
        sqlSession.delete("event_delete", params);
    }
    
    @Override
    public boolean event_Chk(String sche_id, String event_date) {
    	Map<String, Object> params = new HashMap<>();
        params.put("sche_id", sche_id);
        params.put("event_date", event_date);
		return sqlSession.selectOne(namespace+".event_Chk", params);
    }
    
	// 데이터 출력
    @Override
    public void event_change(EventVO vo) throws Exception {
    	sqlSession.update(namespace + ".event_change", vo);
    }
    
    @Override
    public void REevent_change(EventVO vo) throws Exception {
    	sqlSession.update(namespace + ".REevent_change", vo);
    }
    
    @Override
    public void REnum_change(EventVO num_vo) throws Exception {
    	sqlSession.update(namespace + ".REnum_change", num_vo);
    }
    
    @Override
    public List<EventVO> event_print(String event_id) throws Exception {
        return sqlSession.selectList(namespace + ".event_print", event_id);
    }
    
    @Override
    public List<EventVO> latlng_print(Map<String, Object> params) {
        return sqlSession.selectList(namespace + ".latlng_print", params);
    }
    
    @Override
    public void event_delete(EventVO del_vo) throws Exception {
    	sqlSession.delete(namespace + ".event_delete", del_vo);
    }
    
    @Override
    public int event_count(String card_uuid) throws Exception {
		return sqlSession.selectOne(namespace + ".event_count", card_uuid);
    }
}
