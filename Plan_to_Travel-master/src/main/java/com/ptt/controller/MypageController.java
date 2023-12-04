package com.ptt.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.ui.Model;

import com.ptt.model.EventVO;
import com.ptt.model.FavoriteVO;
import com.ptt.model.ScheduleVO;
import com.ptt.service.FavoriteService;
import com.ptt.service.ScheduleService;


@Controller
public class MypageController {

	private static final Logger logger = LoggerFactory.getLogger(ServeController.class);

	@Autowired
	private ScheduleService scheduleservice;

	@Autowired
	private FavoriteService favoriteService;

	@RequestMapping(value = "/getHistory", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, String>> getHistory(HttpServletRequest request, Model model) throws Exception {
		// �궗�슜�옄 �븘�씠�뵒瑜� �꽭�뀡�뿉�꽌 媛��졇�샃�땲�떎.
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("uID_session");
		System.out.println(userId);

		// HistoryService瑜� �궗�슜�븯�뿬 �뒪耳�以� �뜲�씠�꽣瑜� 媛��졇�샃�땲�떎.
		ScheduleVO history = new ScheduleVO();
		history.setU_id(userId);

		// HistoryService瑜� �샇異쒗븯�뿬 �뒪耳�以꾩쓣 媛��졇�샃�땲�떎.
		List<ScheduleVO> userHistory = scheduleservice.selectHistory(history);
		// System.out.println(userHistory);

		// 寃곌낵瑜� 媛�怨듯븯�뿬 諛섑솚�븷 由ъ뒪�듃 �깮�꽦
		List<Map<String, String>> historyList = new ArrayList<>();
		for (ScheduleVO item : userHistory) {
			Map<String, String> historyMap = new HashMap<>();
			// �븘�옒以꾩뿉 ( ) 遺�遺� 怨듬갚 �뱾�뼱媛�硫� js�뿉 data 媛믪씠 undefined濡� �굹�샂
			historyMap.put("sche_title", item.getSche_title());
			historyMap.put("sche_id", item.getSche_id());
			historyList.add(historyMap);
			// System.out.println("History List : " + historyList);
		}

		return historyList;
	}

	// �겢由��븳 �엳�뒪�넗由ъ쓽 �뒪耳�以� �몴 �몴�떆
	@RequestMapping(value = "/historySche", method = RequestMethod.GET)
	public ResponseEntity<List<Map<String, String>>> historyScheGET(@RequestParam("buttonValue") String buttonValue,
			Model model) throws Exception {

		// logger.info("�엳�뒪�넗由ъ쓽 �뒪耳�以� 遺덈윭�삤湲�");
		// logger.info("�겢由��븳 history�쓽 value: " + buttonValue);

		// �겢由��븳 history�쓽 value瑜� �궗�슜�븯�뿬 �뒪耳�以� �젙蹂대�� 媛��졇�샂
		List<EventVO> scheduleList = scheduleservice.getSchedule(buttonValue);
		// System.out.println("�뒪耳�以� 由ъ뒪�듃 :" + scheduleList);

		// 紐⑤뜽�뿉 寃곌낵瑜� 異붽��븯�뿬 酉곕줈 �쟾�떖
		// model.addAttribute("scheduleList", scheduleList);

		// 寃곌낵瑜� �몴�떆�븷 酉곗쓽 �씠由꾩쓣 諛섑솚
		// return "main"; // yourViewName�� �떎�젣濡� �궗�슜�븯�뒗 酉곗쓽 �씠由꾩쑝濡� �닔�젙�빐�빞 �빀�땲�떎.

		// 寃곌낵瑜� 媛�怨듯븯�뿬 諛섑솚�븷 由ъ뒪�듃 �깮�꽦
		List<Map<String, String>> scheINFO = new ArrayList<>();
		for (EventVO event : scheduleList) {
			Map<String, String> eventMap = new HashMap<>();
			eventMap.put("event_id", String.valueOf(event.getEvent_id()));
			eventMap.put("sche_id", String.valueOf(event.getSche_id()));
			eventMap.put("event_num", String.valueOf(event.getEvent_num()));
			eventMap.put("event_title", event.getEvent_title());
			eventMap.put("event_datetime", String.valueOf(event.getEvent_datetime()));
			scheINFO.add(eventMap);
			// System.out.println("�뒪耳�以� �젙蹂� :" + scheINFO);
		}

		// ResponseEntity瑜� �궗�슜�븯�뿬 JSON �삎�떇�쑝濡� �쓳�떟
		return new ResponseEntity<>(scheINFO, HttpStatus.OK);
	}

	// �엳�뒪�넗由� �궘�젣 (�뒪耳�以� �궘�젣)
	@RequestMapping(value = "/hisDelete", method = RequestMethod.GET)
	public ResponseEntity<String> deleteHistory(@RequestParam("sche_id") String sche_id) {
		try {
			scheduleservice.deleteSchedule(sche_id);
			return ResponseEntity.ok("�뒪耳�以꾩쓣 �꽦怨듭쟻�쑝濡� �궘�젣�븯���뒿�땲�떎.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Failed to delete schedule: " + e.getMessage());
		}
	}

	// 濡쒓렇�븘�썐
	@RequestMapping(value = "/logout", method = RequestMethod.GET)
	public String logoutMainGET(HttpServletRequest request) throws Exception {

		logger.info("logoutMainGET硫붿꽌�뱶 吏꾩엯");

		HttpSession session = request.getSession();
		session.invalidate();

		return "redirect:/Login";
	}

	// 利먭꺼李얘린 ���옣
	@RequestMapping(value = "/favoriteAdd", method = RequestMethod.POST)
	@ResponseBody
	public String addFavoriteGET(

			HttpServletRequest request, @RequestParam("fav_name") String fav_name,
			@RequestParam("fav_lat") String fav_lat, @RequestParam("fav_lng") String fav_lng,
			@RequestParam("fav_address1") String fav_address1, @RequestParam("fav_address2") String fav_address2,
			@RequestParam("fav_info") String fav_info) throws Exception {

		logger.info("addFavoriteGET 硫붿꽌�뱶 吏꾩엯");

		// �궗�슜�옄 �븘�씠�뵒瑜� �꽭�뀡�뿉�꽌 媛��졇�샃�땲�떎.
		HttpSession session = request.getSession();
		String u_id = (String) session.getAttribute("uID_session");
		System.out.println(u_id);

		FavoriteVO favoriteVO = new FavoriteVO();
		favoriteVO.setU_id(u_id);
		favoriteVO.setFav_name(fav_name);
		favoriteVO.setFav_lat(fav_lat);
		favoriteVO.setFav_lng(fav_lng);
		favoriteVO.setFav_address1(fav_address1);
		favoriteVO.setFav_address2(fav_address2);
		favoriteVO.setFav_info(fav_info);

		favoriteService.addFavorite(favoriteVO);

		return "Success";
	}

	@RequestMapping(value = "/getFavorite", method = RequestMethod.GET)
	@ResponseBody
	public List<Map<String, String>> getFavorite(HttpServletRequest request, Model model) throws Exception {
		// �궗�슜�옄 �븘�씠�뵒瑜� �꽭�뀡�뿉�꽌 媛��졇�샃�땲�떎.
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("uID_session");
		System.out.println(userId);

		// HistoryService瑜� �궗�슜�븯�뿬 �뒪耳�以� �뜲�씠�꽣瑜� 媛��졇�샃�땲�떎.
		FavoriteVO favorite = new FavoriteVO();
		favorite.setU_id(userId);

		// HistoryService瑜� �샇異쒗븯�뿬 �뒪耳�以꾩쓣 媛��졇�샃�땲�떎.
		List<FavoriteVO> userFavorite = favoriteService.selectFavorite(favorite);
		// System.out.println(userHistory);

		// 寃곌낵瑜� 媛�怨듯븯�뿬 諛섑솚�븷 由ъ뒪�듃 �깮�꽦
		List<Map<String, String>> favoriteList = new ArrayList<>();
		for (FavoriteVO item : userFavorite) {
			Map<String, String> favoriteMap = new HashMap<>();
			// �븘�옒以꾩뿉 ( ) 遺�遺� 怨듬갚 �뱾�뼱媛�硫� js�뿉 data 媛믪씠 undefined濡� �굹�샂
			favoriteMap.put("fav_name", item.getFav_name());
			favoriteMap.put("fav_id", item.getFav_id());
			favoriteList.add(favoriteMap);
			// System.out.println("History List : " + historyList);
		}

		return favoriteList;
	}

	// 利먭꺼李얘린 �궘�젣
	@RequestMapping(value = "/favDelete", method = RequestMethod.GET)
	public ResponseEntity<String> deleteFav(@RequestParam("fav_id") String fav_id) {
		try {
			favoriteService.deleteFav(fav_id);
			return ResponseEntity.ok("利먭꺼李얘린瑜� �꽦怨듭쟻�쑝濡� �궘�젣�븯���뒿�땲�떎.");
		} catch (Exception e) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
					.body("Failed to delete favorite: " + e.getMessage());
		}
	}

	// 利먭꺼李얘린 �쟾泥� �궘�젣
	@RequestMapping(value = "/deleteAll")
	@ResponseBody
	public ResponseEntity<String> deleteAllFavorites(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String u_id = (String) session.getAttribute("uID_session");

		// Check if the userId is not null to avoid potential issues
		if (u_id != null) {
			// Call the service to delete all favorites for the user
			favoriteService.deleteAllFav(u_id);
			return new ResponseEntity<>("Favorites deleted successfully", HttpStatus.OK);
		}

		// Return an error response if needed
		return new ResponseEntity<>("Unable to delete favorites", HttpStatus.BAD_REQUEST);
	}

	// �겢由��븳 利먭꺼李얘린 �젙蹂� 媛��졇�삤湲�
	@RequestMapping(value = "/favPlace", method = RequestMethod.GET)
	public ResponseEntity<FavoriteVO> favPlaceGET(@RequestParam("buttonValue") String buttonValue) {
		try {
			// Fetch favorite data using fav_id
			FavoriteVO favoriteData = favoriteService.getFavInfo(buttonValue);

			// Check if data is found
			if (favoriteData != null) {
				return new ResponseEntity<>(favoriteData, HttpStatus.OK);
			} else {
				return new ResponseEntity<>(HttpStatus.NOT_FOUND);
			}
		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}
}