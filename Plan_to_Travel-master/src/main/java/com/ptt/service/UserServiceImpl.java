package com.ptt.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ptt.mapper.UserMapper;
import com.ptt.model.LocationVO;
import com.ptt.model.UserVO;

@Service
public class UserServiceImpl implements UserService {
	
	@Autowired
	UserMapper usermapper;

	//회원가입
	@Override
	public void userJoin(UserVO user) throws Exception
	{ 
		usermapper.userJoin(user);
	}
	
	//아이디 중복 체크
	@Override
	public int idCheck(String u_id) throws Exception {
		
		return usermapper.idCheck(u_id);
	}
	
    //로그인
    @Override
    public UserVO userLogin(UserVO user) throws Exception {
        
        return usermapper.userLogin(user);
    }
    
    //사용자 데이터 불러오기
	public UserVO user_data(String uID_session) throws Exception {

		return usermapper.user_data(uID_session);
	}
}