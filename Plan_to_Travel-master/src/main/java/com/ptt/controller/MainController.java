package com.ptt.controller;

import javax.inject.Inject;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import com.ptt.dao.LocationDAO;

import lombok.extern.log4j.Log4j;

@Controller

public class MainController {
	
	private static final Logger logger = LoggerFactory.getLogger(MainController.class);
	
	//메인 페이지 이동
	@RequestMapping(value = "/main", method = RequestMethod.GET)
	public String mainPageGET() {
			
		logger.info("main 페이지 진입");
		
		return "Plan_to_travel";
	}

}