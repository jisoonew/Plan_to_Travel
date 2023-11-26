package com.ptt.controller;

import javax.inject.Inject;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import com.ptt.dao.LocationDAO;
import com.ptt.model.LocationVO;

@Controller
public class TestDAO {
	
	@Inject
    private LocationDAO dao;
   
    @RequestMapping(value = "/testDAO", method = RequestMethod.GET)
    public void testDAO(){
        LocationVO vo = new LocationVO();
        vo.setuID("연습1233");
        vo.setLocation_NAME("1234");

        dao.insertMember(vo);
    }
}
