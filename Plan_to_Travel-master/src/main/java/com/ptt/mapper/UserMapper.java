package com.ptt.mapper;

import java.util.List;
import java.util.Map;

import com.ptt.model.LocationVO;
import com.ptt.model.UserVO;

public interface UserMapper {
	
	//회원가입
	//userJoin은 UserMapper.xml에 있는 insert문 id
	//UserVO는 UserVO.java 파일의 UserVO 클래스
	public void userJoin(UserVO user);
	
	//아이디 중복 검사
	public int idCheck(String u_id);
	
    //로그인
    public UserVO userLogin(UserVO user);
    
    //사용자 데이터
	public UserVO user_data(String uID_session);
}
