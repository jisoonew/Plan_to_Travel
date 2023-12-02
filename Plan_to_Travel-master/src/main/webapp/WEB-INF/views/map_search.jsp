<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>map_search2</title>
<link href="resources/css/map_search.css" rel="stylesheet" />
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<script
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7 autoload=true"></script>
</head>
<body>
	<div id="map_div_home">
		<div class="_map_layer_overlay_home">
			<div class="__space_10_h_home"></div>
			<div class="_map_overlay_row_home">
				<input type="text" class="_search_entry" id="searchAddress_home"
					placeholder="목적지를 입력하세요"
					onkeyup="onKeyupSearchLocation_home(this);">
				<button class="btn btn-primary btn-sm"
					onclick="apiSearchLocation_home();"
					style="margin-top: 14px; margin-bottom: 14px; pointer-events: all;">
					검색<img src="/lib/img/_icon/search.svg" alt="">
				</button>
			</div>
		</div>


		<div class="scroll_box_home">
			<div class="__flex_expand_home"></div>
			<div id="apiResult_home" class="_map_overlay_row_home">
				<div class="_result_panel_bg_home ">
					<div class="_result_panel_home">
						<div class="__disable_text_home">검색할 주소를 입력하세요.</div>
						<div class="__disable_text_home">마우스 왼쪽버튼으로 "주소찾기" 장소를
							선택하세요.</div>
						<div class="__disable_text_home">카테고리를 선택하세요.</div>
					</div>
				</div>
			</div>
		</div>
	</div>


	<script>
  var markerLayer; // 전역 변수로 선언
  var map_div_home;
  var marker1_home;

  function map_div_home_show(){	 
		$('#map_div_home').show();
	  	$('#map_div_car').hide();
	  	$('#map_div_ped').hide();
	  	};
  	
  map_div_home = new Tmapv2.Map("map_div_home", { // 지도가 생성될 div
      center: new Tmapv2.LatLng(37.57376650837833, 126.98504447937053),    // 지도의 중심좌표
      width : "500px", // 지도의 넓이
      height : "740px", // 지도의 높이
      zoom : 15, // 지도의 줌레벨
      httpsMode: true,    // https모드 설정
  });
  
// 지도 타입 변경: ROAD
  map_div_home.setMapType(Tmapv2.Map.MapType.ROAD);
  /* API시작 */
  // 마커 초기화
  var markerStart_home = null;
  var markerEnd_home = null;
  var markerWp_home = [];
  var markerPoi_home = [];
  var markerPoint_home = [];
  var markerArr_home = [], lineArr_home = [], labelArr_home = [];
  var marker1_home = new Tmapv2.Marker({
      icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png",
      iconSize : new Tmapv2.Size(24, 38),
      map : map_div_home
  });
  var tData_home = new Tmapv2.extension.TData();
      
  // (장소 API) API [검색] 버튼 동작
  function apiSearchLocation_home() {
      searchPois_car_home();
  }
  function onKeyupSearchLocation_home(obj) {
      if (window.event.keyCode == 13) {
    	  searchPois_car_home();
      }
  }
  
  // (장소API) 주소 찾기
  map_div_home.addListener("click", function onClick(evt) {
      var mapLatLng_home = evt.latLng;
      //기존 마커 삭제
      marker1_home.setMap(null);
      // 기존 라인 지우기
      if(lineArr_home.length > 0){
          for(var k_home=0; k_home<lineArr_home.length ; k_home++){
        	  lineArr_home[k_home].setMap(null);
          }
          //지운뒤 배열 초기화
          lineArr_home = [];
      }
      var markerPosition_home = new Tmapv2.LatLng(
    		  mapLatLng_home._lat, mapLatLng_home._lng);
      //마커 올리기
      marker1_home = new Tmapv2.Marker({
          position : markerPosition_home,
          icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png",
          iconHTML: `
          <div class='_t_marker' style="position:relative;" >
              <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
              <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
              P</div>
          </div>
          `,
          offset: new Tmapv2.Point(24, 38),
          iconSize : new Tmapv2.Size(24, 38),
          map : map_div_home
      });
      var lon_home = mapLatLng_home._lng;
      var lat_home = mapLatLng_home._lat;
     
      var optionObj_home = {
          coordType: "WGS84GEO",       //응답좌표 타입 옵션 설정 입니다.
          addressType: "A10"           //주소타입 옵션 설정 입니다.
      };
      var params_home = {
          onComplete:function(result) { //데이터 로드가 성공적으로 완료 되었을때 실행하는 함수 입니다.
              // 기존 팝업 지우기
              if(labelArr_home.length > 0){
                  for(var i_home in labelArr_home){
                	  labelArr_home[i_home].setMap(null);
                  }
                  labelArr_home = [];
              }
              
              // poi 마커 지우기
              if(markerPoi_home.length > 0){
                  for(var i_home in markerPoi_home){
                	  markerPoi_home[i_home].setMap(null);
                  }
                  markerPoi_home = [];
              }
              $("#searchAddress_home").val('');
              $("._btn_radio").removeClass('__color_blue_fill');
              var arrResult_home = result._responseData.addressInfo;
              var fullAddress_home = arrResult_home.fullAddress.split(",");
              var newRoadAddr_home = fullAddress_home[2];
              var jibunAddr_home = fullAddress_home[1];
              if (arrResult_home.buildingName != '') {//빌딩명만 존재하는 경우
            	  jibunAddr_home += (' ' + arrResult_home.buildingName);
              }
              let resultStr_home = `
              <div class="_result_panel_bg_home">
                  <div class="_result_panel_area">
                      <div class="__reverse_geocoding_result" style="flex-grow: 1;">
                          <p class="_result_text_line">새주소 : \${newRoadAddr_home}</p>
                          <p class="_result_text_line_memo_print" style="display: none;">\${newRoadAddr_home}</p>
                          <p class="_result_text_line">지번주소 : \${jibunAddr_home}</p>
                          <p class="_result_text_line">좌표 (WSG84) : \${lat_home}, \${lon_home}</p>
                          <p class="_result_text_line" id="_result_text_line_memo_lat" style="display: none;">\${lat_home}</p>
                          <p class="_result_text_line" id="_result_text_line_memo_lng" style="display: none;">\${lon_home}</p>
                          <p class="_result_text_line"></p>
                      </div>
                      <div>
                          <div class="_search_item_button_panel">
                          </div>
                      </div>
                  </div>
              </div>
              `;
              
              var resultDiv_home = document.getElementById("apiResult_home");
              resultDiv_home.innerHTML = resultStr_home;
          },      
          onProgress:function() {},   //데이터 로드 중에 실행하는 함수 입니다.
          onError:function() {        //데이터 로드가 실패했을때 실행하는 함수 입니다.
              alert("onError");
          }             
      };
      tData_home.getAddressFromGeoJson(lat_home, lon_home, optionObj_home, params_home);
  });
  // (장소API) 통합 검색 함수
  function searchPois_car_home() {
      var searchKeyword_home = $("#searchAddress_home").val();
      var optionObj_home = {
          resCoordType : "WGS84GEO",
          reqCoordType : "WGS84GEO",
          count: 10
      };
      var params_home = {
          onComplete: function(result) {
              // 데이터 로드가 성공적으로 완료되었을 때 발생하는 이벤트입니다.
              var resultpoisData_home = result._responseData.searchPoiInfo.pois.poi;
              // 기존 마커, 팝업 제거
              reset_home();
              $("._btn_radio").removeClass('__color_blue_fill');
              if(marker1_home) {
            	  marker1_home.setMap(null);
              }
              
              var innerHtml_home =    // Search Reulsts 결과값 노출 위한 변수
              `
              <div class="_result_panel_bg_home _scroll_padding">
                  <div class="_result_panel_scroll">
              `;
              var positionBounds_home = new Tmapv2.LatLngBounds();        //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
              
              for(var k_home in resultpoisData_home){
                  // POI 정보의 ID
                  var id_home = resultpoisData_home[k_home].id;
                  
                  var name_home = resultpoisData_home[k_home].name;
                  
                  var lat_home = Number(resultpoisData_home[k_home].noorLat);
                  var lon_home = Number(resultpoisData_home[k_home].noorLon);
                  
                  var frontLat_home = Number(resultpoisData_home[k_home].frontLat);
                  var frontLon_home = Number(resultpoisData_home[k_home].frontLon);
                  
                  var markerPosition_home = new Tmapv2.LatLng(lat_home, lon_home);
                  
                  var fullAddressRoad_home = resultpoisData_home[k_home].newAddressList.newAddress[0].fullAddressRoad;
                  
                  const marker3_home = new Tmapv2.Marker({
                      position : markerPosition_home,
                      //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png",
                      iconHTML:`
                          <div class='_t_marker' style="position:relative;" >
                          <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                          <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                          \${Number(k_home)+1}</div>
                          </div>
                      `,
                      iconSize : new Tmapv2.Size(24, 38),
                      title : name_home,
                      label: `<span style="display:none;">\{k_home}_\${id_home}</span>`,
                      map:map_div_home
                  });
                  
                  // 마커 클릭 이벤트 추가
                  marker3_home.addListener("click", function(evt) {
                      for(let tMarker_home of markerPoi_home) {
                          const labelInfo_home = $(tMarker_home.getOtherElements()).text();
                          const forK_home = labelInfo_home.split("_")[0];
                          tMarker_home.setIconHTML(`
                              <div class='_t_marker' style="position:relative;" >
                              <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                              <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                              \${Number(forK_home)+1}</div>
                              </div>
                          `);
                           // marker z-index 초기화
                           $(tMarker_home.getOtherElements()).next('div').css('z-index', 100);
                      }
                      // 선택한 marker z-index 처리 
                      $(marker3_home.getOtherElements()).next('div').css('z-index', 101);
                      const labelInfo_home = $(marker3_home.getOtherElements()).text();
                      const thisK_home = labelInfo_home.split("_")[0];
                      const thisId_home = labelInfo_home.split("_")[1];
                      marker3_home.setIconHTML(`
                          <div class='_t_marker' style="position:relative;" >
                          <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
                          <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                          \${Number(thisK_home)+1}</div>
                          </div>
                      `);
                      poiDetail_home(thisId_home, thisK_home);
                  });
                  
                  innerHtml_home += `
                      <div class="_search_item" id="poi_\${k_home}">
                          <div class="_search_item_poi">
                              <div class="_search_item_poi_icon _search_item_poi_icon_grey">
                                  <div class="_search_item_poi_icon_text">\${Number(k_home)+1}</div>
                              </div>
                          </div>
                          <div class="_search_item_info">
                              <p class="_search_item_info_title">\${name_home}</p>
                              <p class="_search_item_info_address">\${fullAddressRoad_home}</p>
                              <p class="_search_item_info_address">중심점 : \${lat_home}, \${lon_home}</p>
                              <p class="_search_item_info_address">입구점 : \${frontLat_home}, \${frontLon_home}</p>
                          </div>
                          <div class="_search_item_button_panel">
                              <div class="_search_item_button __color_blue" onclick='poiDetail_home("\${id_home}", "\${k_home}");'>
                                  상세정보
                              </div>
                          </div>
                          <div class="_search_item_button_panel">
                          </div>
                          
                      </div>
                      \${(resultpoisData_home.length-1) == Number(k_home) ? "": `<div class="_search_item_split"></div>`}
                  `;
                  markerPoi_home.push(marker3_home);
                  positionBounds_home.extend(markerPosition_home);    // LatLngBounds의 객체 확장
              }
              
              innerHtml_home += "</div></div>";
              $("#apiResult_home").html(innerHtml_home);    //searchResult 결과값 노출
              map_div_homep.panToBounds(positionBounds_home);    // 확장된 bounds의 중심으로 이동시키기
              map_div_home.zoomOut();
          },
          onProgress: function() {},
          onError: function(){}
      }
      tData_home.getPOIDataFromSearchJson(searchKeyword_home, optionObj_home, params_home);
      
  }    
      
  // POI 상세검색 함수
  function poiDetail_home(poiId_home, thisK_home) {
      for(let tMarker_home of markerPoi_home) {
          const labelInfo_home = $(tMarker_home.getOtherElements()).text();
          const forK_home = labelInfo_home.split("_")[0];
          tMarker_home.setIconHTML(`
              <div class='_t_marker' style="position:relative;" >
              <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
              <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
              \${Number(forK_home)+1}</div>
              </div>
          `);
           // marker z-index 초기화
           $(tMarker_home.getOtherElements()).next('div').css('z-index', 100);
      }
      markerPoi_home[thisK_home].setIconHTML(`
          <div class='_t_marker' style="position:relative;" >
          <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
          <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
          \${Number(thisK_home)+1}</div>
          </div>
      `);
      // 선택한 marker z-index 처리 
      $(markerPoi_home[thisK_home].getOtherElements()).next('div').css('z-index', 101);
      var scrollOffset_home = $("#poi_"+thisK_home)[0].offsetTop - $("._result_panel_scroll")[0].offsetTop
      $("._result_panel_scroll").animate({scrollTop: scrollOffset_home}, 'slow');
      $("._result_panel_scroll ._search_item_poi_icon").removeClass("_search_item_poi_icon_blue");
      $("#poi_"+thisK_home).find('._search_item_poi_icon').addClass("_search_item_poi_icon_blue");
      // 기존 라벨 지우기
      if(labelArr_home.length > 0){
          for(var i_home in labelArr_home){
        	  labelArr_home[i_home].setMap(null);
          }
          labelArr_home = [];
      }
  
      var optionObj_home = {
          resCoordType: "WGS84GEO"
      }
      var params_home = {
          onComplete: function(result) {
              // 응답받은 POI 정보
              var detailInfo_home = result._responseData.poiDetailInfo;
              console.log(detailInfo_home);
              var name_home = detailInfo_home.name;
              var bldAddr_home = detailInfo_home.bldAddr;
              var tel_home = detailInfo_home.tel;
              var bizCatName_home = detailInfo_home.bizCatName;
              var parkingString_home = (detailInfo_home.parkFlag == "0"? "주차 불가능": (detailInfo_home.parkFlag == "1" ? "주차 가능": ""));
              var zipCode_home = detailInfo_home.zipCode;
              var lat_home = Number(detailInfo_home.lat);
              var lon_home = Number(detailInfo_home.lon);
              var bldNo1_home = detailInfo_home.bldNo1;
              var bldNo2_home = detailInfo_home.bldNo2;
              
              var labelPosition = new Tmapv2.LatLng(lat_home, lon_home);
              if(bldNo1_home !== "") {
            	  bldAddr_home += ` \${bldNo1_home}`;
              }
              if(bldNo2_home !== "") {
            	  bldAddr_home += `-\${bldNo2_home}`;
              }
              
              /* 상세보기 스타일은 이 주석 바로 밑에서 바꾸기 */
              var content_home = `
                  <div class="_tmap_preview_popup_text">
                      <div class="_tmap_preview_popup_info">
                          <div class="_tmap_preview_popup_title">\${name_home}</div>
                          <div class="_tmap_preview_popup_address" style="width:150px;">\${bldAddr_home}</div>
                          <div class="_tmap_preview_popup_address">\${zipCode_home}</div>
                          <div class="_tmap_preview_popup_address">\${bizCatName_home}</div>
              `;
              // 상세보기 클릭 시 지도에 표출할 popup창
/*                     var content = "<div style=' border-radius:10px 10px 10px 10px;background-color:#2f4f4f; position: relative;"
                      + "line-height: 15px; padding: 5 5px 2px 4; right:65px; width:150px; padding: 5px;'>"
                      + "<div style='font-size: 11px; font-weight: bold ; line-height: 15px; color : white'>"
                      + name
                      + "</br>"
                      + address 
                      + "</br>"
                      + bizCatName;
*/                            
              if(tel_home !== "") {
            	  content_home += `<div class="_tmap_preview_popup_address">\${tel_home}</div>`;
              }
              if(parkingString_home !== "") {
            	  content_home += `<div class="_tmap_preview_popup_address">\${parkingString_home}</div>`;
              }
              
              content_home += "</div></div>";
          
              var labelInfo2_home = new Tmapv2.InfoWindow({
                  position: labelPosition, //Popup 이 표출될 맵 좌표
                  content: content_home, //Popup 표시될 text
                  border:'0px solid #FF0000', //Popup의 테두리 border 설정.
                  background: false,
                  offset: new Tmapv2.Point(-12, -6),
                  type: 2, //Popup의 type 설정.
                  align: Tmapv2.InfoWindowOptions.ALIGN_CENTERTOP,
                  map: map_div_home //Popup이 표시될 맵 객체
              });
/* 
              var labelInfo2 = new Tmapv2.Label({
                  position : labelPosition,
                  content : content,
                  zIndex: 999,
                  align: 'ct',
                  map : map
              });
               */
              //popup 생성
  
              // LABEL이 마커보다 상위에 표시되도록 수정함. 
              $("#map_div ._tmap_preview_popup_text").parent().parent().css('z-index', 10);
              // popup들을 담을 배열에 팝업 저장
              labelArr_home.push(labelInfo2_home);
              
              map_div_home.setCenter(labelPosition);
          },
          onProgress: function() {},
          onError: function() {}
      }
      tData_home.getPOIDataFromIdJson(poiId_home,optionObj_home, params_home);
  }        
  // (API 공통) 맵에 그려져있는 라인, 마커, 팝업을 지우는 함수
  function reset_home() {
      // 기존 라인 지우기
      if(lineArr_home.length > 0){
          for(var i_home in lineArr_home) {
        	  lineArr_home[i].setMap(null);
          }
          //지운뒤 배열 초기화
          lineArr_home = [];
      }
  
      // 기존 마커 지우기
      if(markerStart_home) {
    	  markerStart_home.setMap(null);
      }
      if(markerEnd_home) {
    	  markerEnd_home.setMap(null);
      }
      if(markerArr_home.length > 0){
          for(var i_home in markerArr_home){
        	  markerArr_home[i_home].setMap(null);
          }
          markerArr_home = [];
      }
      // 기존 markerLayer 지우기
      if (markerLayer) {
          markerLayer.clearMarkers(); // Clearing the existing markers from the markerLayer
      }
      // poi 마커 지우기
      if(markerPoi_home.length > 0){
          for(var i_home in markerPoi_home){
        	  markerPoi_home[i_home].setMap(null);
          }
          markerPoi_home = [];
      }
      // 경로찾기 point 마커 지우기
      if(markerPoint_home.length > 0){
          for(var i_home in markerPoint_home){
        	  markerPoint_home[i_home].setMap(null);
          }
          markerPoint_home = [];
      }
      
      // 기존 팝업 지우기
      if(labelArr_home.length > 0){
          for(var i_home in labelArr_home){
        	  labelArr_home[i_home].setMap(null);
          }
          labelArr_home = [];
      }
  }
  
 

	  $(document).on('click', "[class*=table-box] [id^=title]", function () { 

	  	$(".card-title1").focus();
	  	
	  	// 일정표를 클릭하면 메모장 날짜 텍스트 출력
	  	$('#datepicker').val($("[id^=date]").text());
	  	
	  	// 일정표와 메모장의 연결을 위함, 메모장의 제목 텍스트의 아이디 값에 클릭한 일정의 아이디 값 연결함.
	  	document.querySelector('#memo_text_id').setAttribute("value",$(this).attr('id'));
	  	
	  	$.ajax({
		    url: "/event_print",
		    type: "post",
		    dataType: "json",
		    data: {
		        "event_id": card_uuid
		    },
		    success: function (data2) {
		        console.log("Server response:", data2);

		        	var firstItem = data2.data2[0];
		            var location_TITLE = firstItem.event_title;
		            var location_TIME = firstItem.event_datetime;
		            var location_NAME = firstItem.event_place;
		            var location_LAT = firstItem.event_lat;
		            var location_LNG = firstItem.event_lng;
		            var location_MEMO = firstItem.event_memo;
		            var location_REVIEW = firstItem.event_review;

		            var dateTime = new Date(location_TIME);
		            var time = dateTime.toISOString().split('T')[1].split('.')[0];
		            
		      	    $.ajax({
		  	  	      url: '/handleMapData',
		  	  	      type: 'post',
		  	  	      data: {
		  	  	        latitude: location_LAT,
		  	  	        longitude: location_LNG
		  	  	      },
		  	  	      success: function(response) {
		  	  	    	  
		  	  	      if (map_div_home && markerLayer) {
		  	  	        if (marker1_home) {
		  	  	            markerLayer.removeMarker(marker1_home);
		  	  	        }
		  	  	        addMarker(map_div_home, markerLayer, response.latitude, response.longitude);
		  	  	    } else {
		  	  	        console.error('Map or markerLayer is not initialized');
		  	  	    }

		  	  	      console.log("response.latitude : " + response.latitude);
		  	  	      
		  	  	      var { map, markerLayer } = initMap(response.latitude, response.longitude);
		  	  	      addMarker(map, markerLayer, response.latitude, response.longitude);
		  	  	      },
		  	  	      error: function(error) {
		  	  	        console.error('데이터 전송 중 오류가 발생했습니다:', error);
		  	  	      }
		  	  	    });

		            $('#memo_text').val(location_TITLE);
		            $('#memo_time').val(time);
		            $('#memo_place').val(location_NAME);
		            $('#memo_place_lat').val(location_LAT);
		            $('#memo_place_lng').val(location_LNG);
		            $('#memo_content').val(location_MEMO);
		            $('#review_content').val(location_REVIEW);
		    },
		    error: function (xhr, status, error) {
		        console.error("POST 요청 오류:", xhr);
		        console.error("상태:", status);
		        console.error("에러:", error);
		    }
		});
	  });
  

	  function initMap(latitude, longitude) {
		    var lonlat = new Tmapv2.LatLng(latitude, longitude);
		    if (!map_div_home) {
		        map_div_home = new Tmapv2.Map("map_div_home", {
		            center: lonlat,
		            width: "500px",
		            height: "740px",
		            zoom: 14
		        });
		        markerLayer = new Tmapv2.Layer.Markers(); // 마커 레이어 초기화
		        map_div_home.addLayer(markerLayer); // 맵에 마커 레이어 추가
		    } else {
		        map_div_home.setCenter(lonlat); // 기존 맵의 중심 좌표 변경
		    }
		    return { map: map_div_home, markerLayer: markerLayer };
		}

	  function addMarker(map, markerLayer, latitude, longitude) {
		    if (marker1_home) {
		        // Move the existing marker to the new position
		        var lonlat = new Tmapv2.LatLng(latitude, longitude);
		        marker1_home.setPosition(lonlat); // Use the setPosition method to update the marker's position
		        map_div_home.setCenter(lonlat); // Center the map on the new marker position
		    } else {
		        var lonlat = new Tmapv2.LatLng(latitude, longitude);
		        var size = new Tmapv2.Size(24, 38);
		        var offset = new Tmapv2.Point(-(size.w / 2), -size.h);
		        var icon = new Tmapv2.MarkerImage("http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png", new Tmapv2.Size(24, 38), new Tmapv2.Point(-(24 / 2), -38));

		        var marker = new Tmapv2.Marker(lonlat, { icon: icon });
		        markerLayer.addMarker(marker);
		        marker1_home = marker; // Update the global marker variable
		    }
		    return marker1_home;
		}
	  
 

</script>
</body>
</html>