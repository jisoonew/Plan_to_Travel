package com.ptt.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.inject.Inject;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.ptt.dao.EventDAO;
import com.ptt.dao.LocationDAO;
import com.ptt.dao.ScheduleDAO;
import com.ptt.mapper.LocationMapper;
import com.ptt.model.EventVO;
import com.ptt.model.LocationVO;
import com.ptt.model.ScheduleVO;
import com.ptt.model.UserVO;
import com.ptt.service.EventService;
import com.ptt.service.LocationService;
import com.ptt.service.ScheduleService;
import com.ptt.service.UserService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger log = LoggerFactory.getLogger(ServeController.class);

	@Autowired
	private LocationDAO dao;

	@Autowired
	private ScheduleDAO scheduldao;

	@Autowired
	private EventDAO eventdao;

	@Autowired
	private LocationService locationservice;

	@Autowired
	private ScheduleService scheduleservice;
	
	@Autowired
	private EventService eventservice;

	@Autowired
	private UserService userservice;

	@Autowired
	LocationMapper mapper;

	@RequestMapping(value = "/Plan_to_travel", method = RequestMethod.GET, produces = "application/json")
	public String home(HttpSession session, HttpServletRequest req, Model model,
			@RequestParam(value = "location_UUID", required = false) String location_UUID,
			@RequestParam(value = "location_ID", required = false) String location_ID) throws Exception {

		Map<String, Object> resultMap = new HashMap<String, Object>();
		Map<String, Object> map = new HashMap<>();

		// 로그인 성공한 아이디(세션값) 가져오기
		String uID_session = (String) session.getAttribute("uID_session");

		UserVO location_map = userservice.user_data(uID_session);

		model.addAttribute("user", location_map);

		return "main"; // JSP 페이지를 렌더링
	}

	@ResponseBody
	@RequestMapping(value = "/Plan_to_travel", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> home_location(HttpSession session, HttpServletRequest req, LocationVO locationvo,
			@RequestParam(value = "location_UUID", required = false) String location_UUID,
			@RequestParam(value = "schedule_ID", required = false) String schedule_ID,
			@RequestParam(value = "schedule_UUID", required = false) String schedule_UUID,
			@RequestParam(value = "location_ID", required = false) String location_ID, Model model) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// ajax를 통해 넘어온 배열 데이터 선언
		String[] arrStr = req.getParameterValues("arrStr");
		String[] schedule_arrStr = req.getParameterValues("schdule_itemList");
		String[] schedule_arrStr2 = req.getParameterValues("schdule_itemList2");
		// 로그인 성공한 아이디(세션값) 가져오기
		String uID_session = (String) session.getAttribute("uID_session");

		try {
			if (arrStr != null && arrStr.length > 0) {
				LocationVO vo = new LocationVO();
				vo.setLocation_UUID(location_UUID);
				vo.setuID(uID_session);
				vo.setLocation_ID(arrStr[0]);
				vo.setLocation_TITLE(arrStr[1]);
				vo.setLocation_DATE(arrStr[2]);
				vo.setLocation_TIME(arrStr[3]);
				vo.setLocation_NAME(arrStr[4]);
				vo.setLocation_LAT(arrStr[5]);
				vo.setLocation_LNG(arrStr[6]);
				vo.setLocation_MEMO(arrStr[7]);
				vo.setLocation_REVIEW(arrStr[8]);

				dao.insertMember(vo);

				resultMap.put("result", "success");
			} else {

				resultMap.put("result", "false");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return resultMap;
	}

	// schedule 저장
	@ResponseBody
	@RequestMapping(value = "/sche_save", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> test(HttpSession session,
			@RequestParam(value = "sche_id", required = false) String sche_id,
			@RequestParam(value = "sche_title", required = false) String sche_title, Model model) throws Exception {
		// 로그인 성공한 아이디(세션값) 가져오기
		String uID_session = (String) session.getAttribute("uID_session");

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {
			ScheduleVO schedulevo = new ScheduleVO();
			schedulevo.setSche_id(sche_id);
			schedulevo.setU_id(uID_session);
			schedulevo.setSche_title(sche_title);

			scheduldao.insertTest(schedulevo);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return resultMap;
	}

	// schedule 수정
	@ResponseBody
	@RequestMapping(value = "/schedule_change", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> schedule_change(HttpSession session,
			@RequestParam(value = "sche_id", required = false) String sche_id,
			@RequestParam(value = "sche_title", required = false) String sche_title, Model model) throws Exception {
		// 로그인 성공한 아이디(세션값) 가져오기
		String uID_session = (String) session.getAttribute("uID_session");

		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {
			resultMap.put("sche_id", sche_id);
			resultMap.put("sche_title", sche_title);

			scheduldao.schedule_change(resultMap);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return resultMap;
	}
	
	// event_change
	@RequestMapping(value = "/event_change", method = RequestMethod.POST)
	@ResponseBody
	public void event_changePOST(
			@RequestParam(value = "event_id", required = false) String event_id,
	        @RequestParam(value = "event_title", required = false) String event_title,
	        @RequestParam(value = "event_datetime", required = false) String event_datetime,
	        @RequestParam(value = "event_place", required = false) String event_place,
	        @RequestParam(value = "event_lat", required = false) String event_lat,
	        @RequestParam(value = "event_lng", required = false) String event_lng,
	        @RequestParam(value = "event_memo", required = false) String event_memo,
	        @RequestParam(value = "event_review", required = false) String event_review, EventVO vo) throws Exception {

	    log.info("event_change POST() 진입");

		try {
			
			vo.setEvent_id(event_id);
			vo.setEvent_title(event_title);
			vo.setEvent_datetime(event_datetime);
			vo.setEvent_place(event_place);
			vo.setEvent_lat(event_lat);
			vo.setEvent_lng(event_lng);
			vo.setEvent_memo(event_memo);
			vo.setEvent_review(event_review);

			eventdao.event_change(vo);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	// REevent_change
	@RequestMapping(value = "/REevent_change", method = RequestMethod.POST)
	@ResponseBody
	public void REevent_changePOST(
			@RequestParam(value = "event_uuid_arr", required = false) String event_uuid_arr,
			@RequestParam(value = "cancle_event_arr", required = false) String cancle_event_arr,
			@RequestParam(value = "elementCount", required = false) int elementCount,
			@RequestParam(value = "card_uuid", required = false) String card_uuid, // 일정표에 대한 uuid
			@RequestParam(value = "itemList", required = false) String itemList,
			@RequestParam(value = "event_id", required = false) String event_id, // 일정에 대한 id
	        @RequestParam(value = "event_title", required = false) String event_title,
	        @RequestParam(value = "event_datetime", required = false) String event_datetime,
	        @RequestParam(value = "event_place", required = false) String event_place,
	        @RequestParam(value = "event_lat", required = false) String event_lat,
	        @RequestParam(value = "event_lng", required = false) String event_lng,
	        @RequestParam(value = "event_memo", required = false) String event_memo,
	        @RequestParam(value = "event_review", required = false) String event_review, EventVO vo) throws Exception {

	    log.info("REevent_change POST() 진입");
	    String[] items = itemList.split(",");
	    String[] event_id_items = event_uuid_arr.split(",");

		try {
			vo.setEvent_id(event_id);
			vo.setEvent_title(event_title);
			vo.setEvent_datetime(event_datetime);
			vo.setEvent_place(event_place);
			vo.setEvent_lat(event_lat);
			vo.setEvent_lng(event_lng);
			vo.setEvent_memo(event_memo);
			vo.setEvent_review(event_review);

			eventdao.REevent_change(vo);
			
			EventVO num_vo = new EventVO();
			for (int num = 1; num <= items.length; num++) {
				num_vo.setEvent_id(event_id_items[num-1]);
				num_vo.setEvent_num(num);
				
				eventdao.REnum_change(num_vo);
			}

			// 현재 일정표에 있는 일정 갯수보다 DB에 있는 일정 갯수가 더 많다면 DB에 있는 데이터 삭제
			int event_num = eventdao.event_count(card_uuid);
			EventVO del_vo = new EventVO();
			if(event_num>elementCount) {
				String[] cancle_event_items = cancle_event_arr.split(",");
				for (int num = 1; num <= items.length; num++) {
					del_vo.setEvent_id(cancle_event_items[num-1]);
					eventdao.event_delete(del_vo);
				}
				
				for (int num = 1; num <= items.length; num++) {
					num_vo.setEvent_id(event_id_items[num-1]);
					num_vo.setEvent_num(num);
					
					eventdao.REnum_change(num_vo);
				}
			}


		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@ResponseBody
	@RequestMapping(value = "/event_insert", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> event_test(HttpSession session,
			@RequestParam(value = "event_id", required = false) String event_id,
			@RequestParam(value = "sche_id", required = false) String sche_id,
			@RequestParam(value = "itemList", required = false) String itemList,
			@RequestParam(value = "event_datetime", required = false) String event_datetime,
			@RequestParam(value = "event_place", required = false) String event_place,
			@RequestParam(value = "event_lat", required = false) String event_lat,
			@RequestParam(value = "event_lng", required = false) String event_lng,
			@RequestParam(value = "event_memo", required = false) String event_memo,
			@RequestParam(value = "event_content", required = false) String event_content, HttpServletRequest req,
			Model model) throws Exception {
		// 로그인 성공한 아이디(세션값) 가져오기
		Map<String, Object> resultMap = new HashMap<String, Object>();
		String[] items = itemList.split(",");
		String[] event_id_items = event_id.split(",");
		

		try {
			EventVO vo = new EventVO();
			for (int num = 1; num <= items.length; num++) {
				vo.setEvent_id(event_id_items[num-1]);
				vo.setEvent_num(num);
				vo.setSche_id(sche_id);
				vo.setEvent_title(items[num - 1]);
				vo.setEvent_datetime(event_datetime);
				vo.setEvent_place(event_place);
				vo.setEvent_lat(event_lat);
				vo.setEvent_lng(event_lng);
				vo.setEvent_memo(event_memo);
				vo.setEvent_review(event_content);

				eventdao.insert_event(vo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMap;
	}


	@ResponseBody
	@RequestMapping(value = "/event_delete", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> event_change(HttpSession session,
			@RequestParam(value = "event_id", required = false) String event_id, HttpServletRequest req,
			Model model) throws Exception {
		// 로그인 성공한 아이디(세션값) 가져오기
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {
			eventdao.event_delete(event_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMap;
	}
	
	@ResponseBody
	@RequestMapping(value = "/schedule_delete", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> schedule_delete(HttpSession session,
			@RequestParam(value = "sche_id", required = false) String sche_id, HttpServletRequest req, Model model) throws Exception {
		// 로그인 성공한 아이디(세션값) 가져오기
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {
			scheduldao.schedule_delete(sche_id);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return resultMap;
	}

	@ResponseBody
	@RequestMapping(value = "/Plan_to_travel_location", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> home_location_insert(HttpSession session, HttpServletRequest req, LocationVO locationvo,
			@RequestParam(value = "location_UUID", required = false) String location_UUID,
			@RequestParam(value = "schedule_ID", required = false) String schedule_ID,
			@RequestParam(value = "schedule_UUID", required = false) String schedule_UUID,
			@RequestParam(value = "location_ID", required = false) String location_ID, Model model) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		// ajax를 통해 넘어온 배열 데이터 선언
		String[] arrStr = req.getParameterValues("arrStr");

		// 로그인 성공한 아이디(세션값) 가져오기
		String uID_session = (String) session.getAttribute("uID_session");

		try {
			if (arrStr != null && arrStr.length > 0) {

				LocationVO vo = new LocationVO();
				vo.setLocation_UUID(location_UUID);
				vo.setuID(uID_session);
				vo.setLocation_ID(arrStr[0]);
				vo.setLocation_TITLE(arrStr[1]);
				vo.setLocation_DATE(arrStr[2]);
				vo.setLocation_TIME(arrStr[3]);
				vo.setLocation_NAME(arrStr[4]);
				vo.setLocation_LAT(arrStr[5]);
				vo.setLocation_LNG(arrStr[6]);
				vo.setLocation_MEMO(arrStr[7]);
				vo.setLocation_REVIEW(arrStr[8]);

				dao.insertMember(vo);

				resultMap.put("result", "success");
			} else {

				resultMap.put("result", "false");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return resultMap;
	}

	// 데이터 출력
	@ResponseBody
	@RequestMapping(value = "/event_print", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> event_print(
	        HttpSession session, 
	        HttpServletRequest req,
	        @RequestParam(value = "event_id", required = false) String event_id,
	        Model model) throws Exception {
	    
	    Map<String, Object> resultMap = new HashMap<String, Object>();
	    List<EventVO> location_map = eventservice.event_print(event_id);
	    
	    model.addAttribute("data", location_map); 
	    resultMap.put("data2", location_map);
	    
	    return resultMap;
	}
		
	// 데이터 출력
	@ResponseBody
	@RequestMapping(value = "/latlng_print", method = RequestMethod.POST, produces = "application/json")
	public List<String> latlng_print(
	        HttpSession session, 
	        HttpServletRequest req,
	        @RequestParam(value = "sche_id", required = false) String sche_id,
	        @RequestParam(value = "event_datetime", required = false) String event_datetime,
	        Model model) throws Exception {
	    
	    Map<String, Object> params = new HashMap<>();
	    params.put("sche_id", sche_id);
	    params.put("event_datetime", event_datetime);

	    List<EventVO> latlng = eventservice.latlng_print(params);

	    List<String> latlng_arr = new ArrayList<>();

	    for (EventVO event : latlng) {
	    	latlng_arr.add(event.getEvent_lng());
	    	latlng_arr.add(event.getEvent_lat());
	    }
 
	    return latlng_arr;
	}

	// 수정하기
	@ResponseBody
	@RequestMapping(value = "/change", method = RequestMethod.POST, produces = "application/json")
	public Map<String, Object> changePOST(HttpSession session, HttpServletRequest req, ScheduleVO schedulevo,
			@RequestParam(value = "location_UUID", required = false) String location_UUID,
			@RequestParam(value = "location_ID", required = false) String location_ID, LocationVO location_VO,
			@RequestParam(value = "schedule_UUID", required = false) String schedule_UUID,
			@RequestParam(value = "schedule_ID", required = false) String schedule_ID,
			@RequestParam(value = "result", required = false) String result) throws Exception {
		Map<String, Object> resultMap = new HashMap<String, Object>();
		// ajax를 통해 넘어온 배열 데이터 선언
		String[] arrStr = req.getParameterValues("arrStr");

		try {
			if (arrStr != null && arrStr.length > 0) {

				location_VO.setLocation_TITLE(arrStr[1]);
				location_VO.setLocation_DATE(arrStr[2]);
				location_VO.setLocation_TIME(arrStr[3]);
				location_VO.setLocation_NAME(arrStr[4]);
				location_VO.setLocation_LAT(arrStr[5]);
				location_VO.setLocation_LNG(arrStr[6]);
				location_VO.setLocation_MEMO(arrStr[7]);
				location_VO.setLocation_REVIEW(arrStr[8]);

				dao.change(location_VO);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} // memberIdChkPOST() 종료
		return resultMap;
	}

	// schedule 삽입 가능 여부
	// sche_id 여부로 판단함(처음 삽입에 사용)
	@RequestMapping(value = "/sche_Chk", method = RequestMethod.POST)
	@ResponseBody
	public boolean sche_ChkPOST(@RequestParam(value = "sche_id", required = false) String sche_id) throws Exception {

		log.info("sche_Chk() 진입");

		boolean sche_Chk = scheduleservice.sche_Chk(sche_id);

		return sche_Chk;
	}

	// event 삽입 가능 여부
	// event sche_id나 event_date가 없다면 삽입, 둘 다 있다면 수정
	@RequestMapping(value = "/event_Chk", method = RequestMethod.POST)
	@ResponseBody
	public boolean event_ChkPOST(@RequestParam(value = "sche_id", required = false) String sche_id,
	        @RequestParam(value = "event_date", required = false) String event_date) throws Exception {

	    log.info("event_ChkPOST() 진입");

	    boolean sche_Chk = eventservice.event_Chk(sche_id, event_date);

	    return sche_Chk;
	}
	

	

	@RequestMapping(value = "/handleMapData", method = RequestMethod.POST)
	@ResponseBody
	public Map<String, Double> handleMapData(@RequestParam Double latitude, @RequestParam Double longitude) {
		Map<String, Double> response = new HashMap<>();
		// 경도 위도 데이터
		response.put("latitude", latitude);
		response.put("longitude", longitude);
		return response;
	}

}