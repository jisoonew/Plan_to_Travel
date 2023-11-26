package com.ptt.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.inject.Inject;

import org.apache.ibatis.session.SqlSession;

import com.ptt.model.LocationVO;
import com.ptt.model.UserVO;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository // DAO라고 명시
public class LocationDAOImp implements LocationDAO {

    @Inject // 의존관계를 자동으로 연결(JAVA에서 제공) ==@autowired (Spring에서 제공)
    private SqlSession sqlSession;
   
   
    private static final String namespace = "com.ptt.mapper.LocationMapper";
                                            //memberMapper.xml의 namespace값
    
    @Autowired
	private LocationDAO mapper;
   
    @Override
    public void insertMember(LocationVO vo) {
        sqlSession.insert(namespace+".insertMember", vo);
    }
	
    @Override
    public LocationVO selectMember(LocationVO vo) {
		return (LocationVO) sqlSession.selectList(namespace+".selectMember", vo);
    }
    
    
    public int checkId(String location_UUID, String location_ID) {
    	Map<String, Object> params = new HashMap<>();
        params.put("location_UUID", location_UUID);
        params.put("location_ID", location_ID);
        return sqlSession.selectOne(namespace+".idCheck", params);
    }
    
    public int scheduleCheck(String schedule_UUID, String schedule_ID) {
    	Map<String, Object> params = new HashMap<>();
        params.put("schedule_UUID", schedule_UUID);
        params.put("schedule_ID", schedule_ID);
        return sqlSession.selectOne(namespace+".scheduleCheck", params);
    }
   
    @Override
    public void change(LocationVO vo) {
        sqlSession.update(namespace+".change", vo);
    }
    
    // 데이터 출력
    @Override
    public List<LocationVO> Location_print(Map<String, Object> map) throws Exception {
    	return sqlSession.selectList(namespace + ".Location_print", map);
    }
    
    // 데이터 출력2
    @Override
    public List<LocationVO> Location_latlng(Map<String, Object> response) throws Exception {
    	return sqlSession.selectList(namespace + ".Location_latlng", response);
    }
}
