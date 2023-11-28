<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<!-- 선언부 -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="en">

<head>
<meta charset="utf-8">
<script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
<link href="resources/css/map_pedestrian.css" rel="stylesheet" />
<script type="text/javascript"
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7 autoload=false"></script>
<!--  autoload=false -->

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
<title>보행자 경로 + 경유지</title>

</head>


<!--MAIN HOME UI-->
<body>
	<div id="map_div_ped">
		<input type="hidden" id="searchAddress_ped" /> <input type="hidden"
			id="startx_ped" /> <input type="hidden" id="starty_ped" /> <input
			type="hidden" id="endx_ped" /> <input type="hidden" id="endy_ped" />
		<div class="_map_layer_overlay">
			<div class="__space_15_h"></div>
			<div class="_map_overlay_row">
				<input type="text" id="searchStartAddress_ped"
					class="_search_entry _search_entry_short" placeholder="출발지를 입력하세요"
					onkeyup="onKeyupSearchPoi_ped(this);">
				<button onclick="clickSearchPois_ped(this);"
					class="_search_address_btn_ped btn btn-primary btn-sm"
					style="margin-bottom: 14px; pointer-events: all; cursor: pointer;">
					출발</button>
				<div class="__space_13_w"></div>
				<input type="text" id="searchEndAddress_ped"
					class="_search_entry _search_entry_short" placeholder="목적지를 입력하세요"
					onkeyup="onKeyupSearchPoi_ped(this);">
				<button onclick="clickSearchPois_ped(this);"
					class="_search_address_btn_ped btn btn-primary btn-sm"
					style="margin-top: 53px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">
					도착</button>
				<div class="__space_10_w"></div>
				<button
					class="_btn_action_ped _btn_action-search __color_grey btn btn-primary btn-sm"
					onclick="apiSearchRoutes_ped();">검색</button>
			</div>
			<div id="wpList">
				<div class="__space_10_h"></div>
				<div class="waypoint_input _map_overlay_row" data-idx_ped="0">
					<input type="hidden" name="multipos" /> <input type="text"
						class="_search_entry_text _search_entry_short"
						style="margin-top: 10px;" onkeyup="onKeyupSearchPoi_ped(this);"
						placeholder="경유지를 입력하세요.">
					<button onclick="clickSearchPois_ped(this);"
						class="_search_address_btn_ped btn btn-primary btn-sm"
						style="width: 60px; margin-top: 10px; margin-left: 5px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">경유지</button>
					<div style="width: 90px;"></div>
					<!-- <button onclick="onMultiButton_ped(this);" class="_search_address_btn_ped" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button> -->
				</div>
			</div>

			<div class="scroll_box_pedestrian">
				<div class="__flex_expand"></div>
				<div id="apiResult_ped" class="_map_overlay_row">
					<div class="_result_panel_bg_ped ">
						<div class="_result_panel">
							<div id="result"></div>
							<div class="__disable_text">경유지 경로 안내</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<script>

	var map_ped;
function map_div_pedestrian_show(){	 
	$('#map_div_car').hide();
  	$('#map_div_home').hide();
  	$('#map_div_ped').show();
  	};
  	
    map_ped = new Tmapv2.Map("map_div_ped", { // 지도가 생성될 div
        center: new Tmapv2.LatLng(37.570028, 126.986072),    // 지도의 중심좌표
        width : "500px", // 지도의 넓이
        height : "740px", // 지도의 높이
        zoom : 15, // 지도의 줌레벨
        httpsMode: true,    // https모드 설정
    });
    
    // 지도 타입 변경: ROAD
    map_ped.setMapType(Tmapv2.Map.MapType.ROAD);
    /* API시작 */
    // 마커 초기화
    var markerStart_ped = null;
    var markerEnd_ped = null;
    var markerWp_ped = [];
    var markerPoi_ped = [];
    var markerPoint_ped = [];
    var markerArr_ped = [], lineArr_ped = [], labelArr_ped = [];
    var marker1_ped = new Tmapv2.Marker({
        icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
        iconSize : new Tmapv2.Size(24, 38),
        map : map_ped
    });
    var tData_ped = new Tmapv2.extension.TData();
        
    
    // (장소API) 주소 찾기
    //경로 탐색 우클릭 시 인접도로 검색
    map_ped.addListener("contextmenu", function onContextmenu(evt) {
        var mapLatLng_ped = evt.latLng;
        //기존 마커 삭제
        marker1_ped.setMap(null);
        var markerPosition_ped = new Tmapv2.LatLng(
        		mapLatLng_ped._lat, mapLatLng_ped._lng);
        //마커 올리기
        marker1_ped = new Tmapv2.Marker({
            position : markerPosition_ped,
            // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png",
            iconHTML: `
            <div class='_t_marker' style="position:relative;" >
                <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                P</div>
            </div>
            `,
            offset: new Tmapv2.Point(24, 38),
            iconSize : new Tmapv2.Size(24, 38),
            map : map_ped
        });
        var lon = mapLatLng_ped._lng;
        var lat = mapLatLng_ped._lat;
        if(labelArr_ped.length > 0){
            for(var i in labelArr_ped){
            	labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }
        // poi 마커 지우기
        if(markerPoi_ped.length > 0){
            for(var i in markerPoi_ped){
            	markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        var params_ped = {
            appKey : '5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7',
            lon,
lat
        }
        const option = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json;charset=utf-8',
            },
            body: JSON.stringify(params_ped),
        };
        $.ajax({
            method:"GET",
            url:"https://apis.openapi.sk.com/tmap/road/nearToRoad?version=1",//가까운 도로 찾기 api 요청 url입니다.
            async:false,
            data:{
                appKey : "5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7",
                lon,
                lat
            },
            success:function(response){
                
                var resultHeader_ped, resultlinkPoints_ped;
                
                if(response.resultData.header){
                	resultHeader_ped = response.resultData.header;
                	resultlinkPoints_ped = response.resultData.linkPoints;
                    
                    var tDistance_ped = resultHeader_ped.totalDistance;
                    var tTime_ped = resultHeader_ped.speed;	
                    var rName_ped = resultHeader_ped.roadName;
                    
                    
                    // 기존 라인 지우기
                    if(lineArr_ped.length > 0){
                        for(var k=0; k<lineArr_ped.length ; k++){
                        	lineArr_ped[k].setMap(null);
                        }
                        //지운뒤 배열 초기화
                        lineArr_ped = [];
                    }
                    
                    var drawArr_ped = [];
                    
                    // Tmapv2.LatLng객체로 이루어진 배열을 만듭니다.
                    for(var i in resultlinkPoints_ped){
                        var lineLatLng_ped = new Tmapv2.LatLng(resultlinkPoints_ped[i].location.latitude, resultlinkPoints_ped[i].location.longitude);
                        
                        drawArr_ped.push(lineLatLng_ped);
                    }
                    
                    //그리기
                    var polyline_ped = new Tmapv2.Polyline({
                            path : drawArr_ped,	//만든 배열을 넣습니다.
                            strokeColor : "#FF0000",
                            strokeWeight: 6,
                            map : map_ped
                    });
                    
                    //라인 정보를 배열에 담습니다.
                    lineArr_ped.push(polyline_ped);
                    let resultStr_ped = `
                        <div class="_result_panel_bg_ped">
                            <div class="_result_panel_area">
                                <div class="__reverse_geocoding_result" style="flex-grow: 1;">
                                    <p class="_result_text_line">총거리 : \${tDistance_ped}m</p>
                                    <p class="_result_text_line">제한속도 : \${tTime_ped}km/h</p>
                                    <p class="_result_text_line">도로명 : \${rName_ped}</p>
                                    <p class="_result_text_line"></p>
                                </div>
                                <div>
                                    <div class="_search_item_button_panel">
                                            <div class="_search_item_button" onclick="enterDest_ped('start', '\${rName_ped}', '\${lon}', '\${lat}');">
                                                출발
                                            </div>
                                            <div class="_search_item_button" onclick="enterDest_ped('end', '\${rName_ped}', '\${lon}', '\${lat}');">
                                                도착
                                            </div>
                                                <div class="_search_item_button" onclick="enterDest_ped('wp', '\${rName_ped}', '\${lon}', '\${lat}');">
                                                    경유
                                                </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        `;
                    var resultDiv_ped = document.getElementById("apiResult_ped");
                    resultDiv_ped.innerHTML = resultStr_ped;
                    
                }else{
                    $("#result_ped").text("가까운 도로 검색 결과가 없습니다.");
                }
            },
            error:function(request,status,error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
        // tData.getAddressFromGeoJson(lat, lon, optionObj, params_ped);
    });
    map_ped.addListener("click", function onClick(evt) {    
    	
    	
    	
        var mapLatLng_ped = evt.latLng;
        //기존 마커 삭제
        marker1_ped.setMap(null);
        // 기존 라인 지우기
        if(lineArr_ped.length > 0){
            for(var k=0; k<lineArr_ped.length ; k++){
            	lineArr_ped[k].setMap(null);
            }
            //지운뒤 배열 초기화
            lineArr_ped = [];
        }
        var markerPosition_ped = new Tmapv2.LatLng(
        		mapLatLng_ped._lat, mapLatLng_ped._lng);
        //마커 올리기
        marker1_ped = new Tmapv2.Marker({
            position : markerPosition_ped,
            // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png",
            iconHTML: `
            <div class='_t_marker' style="position:relative;" >
                <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                P</div>
            </div>
            `,
            offset: new Tmapv2.Point(24, 38),
            iconSize : new Tmapv2.Size(24, 38),
            map : map_ped
        });
        var lon = mapLatLng_ped._lng;
        var lat = mapLatLng_ped._lat;
       
        var optionObj_ped = {
            coordType: "WGS84GEO",       //응답좌표 타입 옵션 설정 입니다.
            addressType: "A10"           //주소타입 옵션 설정 입니다.
        };
        var params_ped = {
            onComplete:function(result_ped) { //데이터 로드가 성공적으로 완료 되었을때 실행하는 함수 입니다.
                // 기존 팝업 지우기
                if(labelArr_ped.length > 0){
                    for(var i in labelArr_ped){
                    	labelArr_ped[i].setMap(null);
                    }
                    labelArr_ped = [];
                }
                
                // poi 마커 지우기
                if(markerPoi_ped.length > 0){
                    for(var i in markerPoi_ped){
                    	markerPoi_ped[i].setMap(null);
                    }
                    markerPoi_ped = [];
                }
                $("#searchAddress_ped").val('');
                $("._btn_radio").removeClass('__color_blue_fill');
                var arrResult_ped = result_ped._responseData.addressInfo;
                var fullAddress_ped = arrResult_ped.fullAddress.split(",");
                var newRoadAddr_ped = fullAddress_ped[2];
                var jibunAddr_ped = fullAddress_ped[1];
                if (arrResult_ped.buildingName != '') {//빌딩명만 존재하는 경우
                	jibunAddr_ped += (' ' + arrResult_ped.buildingName);
                }
                let resultStr_ped = `
                <div class="_result_panel_bg_ped">
                    <div class="_result_panel_area">
                        <div class="__reverse_geocoding_result" style="flex-grow: 1;">
                            <p class="_result_text_line">새주소 : \${newRoadAddr_ped}</p>
                            <p class="_result_text_line">지번주소 : \${jibunAddr_ped}</p>
                            <p class="_result_text_line">좌표 (WSG84) : \${lat}, \${lon}</p>
                            <p class="_result_text_line"></p>
                        </div>
                        <div>
                            <div class="_search_item_button_panel">
                                    <div class="_search_item_button" onclick="enterDest_ped('start', '\${newRoadAddr_ped}', '\${lon}', '\${lat}');">
                                        출발
                                    </div>
                                    <div class="_search_item_button" onclick="enterDest_ped('end', '\${newRoadAddr_ped}', '\${lon}', '\${lat}');">
                                        도착
                                    </div>
                                        <div class="_search_item_button" onclick="enterDest_ped('wp', '\${newRoadAddr_ped}', '\${lon}', '\${lat}');">
                                            경유
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
                `;
                
                var resultDiv_ped = document.getElementById("apiResult_ped");
                resultDiv_ped.innerHTML = resultStr_ped;
            },      
            onProgress:function() {},   //데이터 로드 중에 실행하는 함수 입니다.
            onError:function() {        //데이터 로드가 실패했을때 실행하는 함수 입니다.
                alert("onError");
            }             
        };
        tData_ped.getAddressFromGeoJson(lat, lon, optionObj_ped, params_ped);
    });
    // (장소API) 통합 검색 함수
    function searchPois_ped() {
        var searchKeyword_ped = $("#searchAddress_ped").val();
        var optionObj_ped = {
            resCoordType : "WGS84GEO",
            reqCoordType : "WGS84GEO",
            count: 10
        };
        var params_ped = {
            onComplete: function(result_ped) {
                // 데이터 로드가 성공적으로 완료되었을 때 발생하는 이벤트입니다.
                var resultpoisData_ped = result_ped._responseData.searchPoiInfo.pois.poi;
                // 기존 마커, 팝업 제거
                reset_ped();
                $("._btn_radio").removeClass('__color_blue_fill');
                if(marker1_ped) {
                	marker1_ped.setMap(null);
                }
                
                var innerHtml_ped =    // Search Reulsts 결과값 노출 위한 변수
                `
                <div class="_result_panel_bg_ped _scroll_padding">
                    <div class="_result_panel_scroll">
                `;
                var positionBounds_ped = new Tmapv2.LatLngBounds();        //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                
                for(var k in resultpoisData_ped){
                    // POI 정보의 ID
                    var id = resultpoisData_ped[k].id;
                    
                    var name_ped = resultpoisData_ped[k].name;
                    
                    var lat = Number(resultpoisData_ped[k].noorLat);
                    var lon = Number(resultpoisData_ped[k].noorLon);
                    
                    var frontLat = Number(resultpoisData_ped[k].frontLat);
                    var frontLon = Number(resultpoisData_ped[k].frontLon);
                    
                    var markerPosition_ped = new Tmapv2.LatLng(lat, lon);
                    
                    var fullAddressRoad = resultpoisData_ped[k].newAddressList.newAddress[0].fullAddressRoad;
                    
                    const marker3_ped = new Tmapv2.Marker({
                        position : markerPosition_ped,
                        //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png",
                        iconHTML:`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                            \${Number(k)+1}</div>
                            </div>
                        `,
                        iconSize : new Tmapv2.Size(24, 38),
                        title : name_ped,
                        label: `<span style="display:none;">\${k}_\${id}</span>`,
                        map:map_ped
                    });
                    
                    // 마커 클릭 이벤트 추가
                    marker3_ped.addListener("click", function(evt) {
                        for(let tMarker of markerPoi_ped) {
                            const labelInfo_ped = $(tMarker.getOtherElements()).text();
                            const forK_ped = labelInfo_ped.split("_")[0];
                            tMarker.setIconHTML(`
                                <div class='_t_marker' style="position:relative;" >
                                <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                \${Number(forK_ped)+1}</div>
                                </div>
                            `);
                             // marker z-index 초기화
                             $(tMarker.getOtherElements()).next('div').css('z-index', 100);
                        }
                        // 선택한 marker z-index 처리 
                        $(marker3_ped.getOtherElements()).next('div').css('z-index', 101);
                        const labelInfo_ped = $(marker3_ped.getOtherElements()).text();
                        const thisK_ped = labelInfo_ped.split("_")[0];
                        const thisId_ped = labelInfo_ped.split("_")[1];
                        marker3_ped.setIconHTML(`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                            \${Number(thisK_ped)+1}</div>
                            </div>
                        `);
                        poiDetail_ped(thisId_ped, thisK_ped);
                    });
                    
                    innerHtml_ped += `
                        <div class="_search_item" id="poi_\${k}">
                            <div class="_search_item_poi">
                                <div class="_search_item_poi_icon _search_item_poi_icon_grey">
                                    <div class="_search_item_poi_icon_text">\${Number(k)+1}</div>
                                </div>
                            </div>
                            <div class="_search_item_info">
                                <p class="_search_item_info_title">\${name_ped}</p>
                                <p class="_search_item_info_address">\${fullAddressRoad}</p>
                                <p class="_search_item_info_address">중심점 : \${lat}, \${lon}</p>
                                <p class="_search_item_info_address">입구점 : \${frontLat}, \${frontLon}</p>
                            </div>
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button __color_blue" onclick='poiDetail_ped("\${id}", "\${k}");'>
                                    상세정보
                                </div>
                            </div>
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button" onclick="enterDest_ped('start', '\${name_ped}', '\${lon}', '\${lat}');">
                                    출발
                                </div>
                                <div class="_search_item_button" onclick="enterDest_ped('end', '\${name_ped}', '\${lon}', '\${lat}');">
                                    도착
                                </div>
                                <div class="_search_item_button" onclick="enterDest_ped('wp', '\${name_ped}', '\${lon}', '\${lat}');">
                                    경유
                                </div>
                            </div>
                            
                        </div>
                        \${(resultpoisData_ped.length-1) == Number(k) ? "": `<div class="_search_item_split"></div>`}
                    `;
                    markerPoi_ped.push(marker3_ped);
                    positionBounds_ped.extend(markerPosition_ped);    // LatLngBounds의 객체 확장
                }
                
                innerHtml_ped += "</div></div>";
                $("#apiResult_ped").html(innerHtml_ped);    //searchResult 결과값 노출
                map_ped.panToBounds(positionBounds_ped);    // 확장된 bounds의 중심으로 이동시키기
                map_ped.zoomOut();
            },
            onProgress: function() {},
            onError: function(){}
        }
        tData_ped.getPOIDataFromSearchJson(searchKeyword_ped, optionObj_ped, params_ped);
        
    }    
        
    // POI 상세검색 함수
    function poiDetail_ped(poiId_ped, thisK_ped) {
        for(let tMarker of markerPoi_ped) {
            const labelInfo_ped = $(tMarker.getOtherElements()).text();
            const forK_ped = labelInfo_ped.split("_")[0];
            tMarker.setIconHTML(`
                <div class='_t_marker' style="position:relative;" >
                <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                \${Number(forK_ped)+1}</div>
                </div>
            `);
             // marker z-index 초기화
             $(tMarker.getOtherElements()).next('div').css('z-index', 100);
        }
        markerPoi_ped[thisK_ped].setIconHTML(`
            <div class='_t_marker' style="position:relative;" >
            <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
            \${Number(thisK_ped)+1}</div>
            </div>
        `);
        // 선택한 marker z-index 처리 
        $(markerPoi_ped[thisK_ped].getOtherElements()).next('div').css('z-index', 101);
        var scrollOffset_ped = $("#poi_"+thisK_ped)[0].offsetTop - $("._result_panel_scroll")[0].offsetTop
        $("._result_panel_scroll").animate({scrollTop: scrollOffset_ped}, 'slow');
        $("._result_panel_scroll ._search_item_poi_icon").removeClass("_search_item_poi_icon_blue");
        $("#poi_"+thisK_ped).find('._search_item_poi_icon').addClass("_search_item_poi_icon_blue");
        // 기존 라벨 지우기
        if(labelArr_ped.length > 0){
            for(var i in labelArr_ped){
            	labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }
    
        var optionObj_ped = {
            resCoordType: "WGS84GEO"
        }
        var params_ped = {
            onComplete: function(result_ped) {
                // 응답받은 POI 정보
                var detailInfo_ped = result_ped._responseData.poiDetailInfo;
                console.log(detailInfo_ped);
                var name_ped = detailInfo_ped.name;
                var bldAddr_ped = detailInfo_ped.bldAddr;
                var tel_ped = detailInfo_ped.tel;
                var bizCatName_ped = detailInfo_ped.bizCatName;
                var parkingString_ped = (detailInfo_ped.parkFlag == "0"? "주차 불가능": (detailInfo_ped.parkFlag == "1" ? "주차 가능": ""));
                var zipCode_ped = detailInfo_ped.zipCode;
                var lat = Number(detailInfo_ped.lat);
                var lon = Number(detailInfo_ped.lon);
                var bldNo1_ped = detailInfo_ped.bldNo1;
                var bldNo2_ped = detailInfo_ped.bldNo2;
                
                var labelPosition_ped = new Tmapv2.LatLng(lat, lon);
                if(bldNo1_ped !== "") {
                	bldAddr_ped += ` \${bldNo1_ped}`;
                }
                if(bldNo2_ped !== "") {
                	bldAddr_ped += `-\${bldNo2_ped}`;
                }
                var content_ped = `
                    <div class="_tmap_preview_popup_text">
                        <div class="_tmap_preview_popup_info">
                            <div class="_tmap_preview_popup_title">\${name_ped}</div>
                            <div class="_tmap_preview_popup_address">\${bldAddr_ped}</div>
                            <div class="_tmap_preview_popup_address">\${zipCode_ped}</div>
                            <div class="_tmap_preview_popup_address">\${bizCatName_ped}</div>
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
                if(tel_ped !== "") {
                	content_ped += `<div class="_tmap_preview_popup_address">\${tel_ped}</div>`;
                }
                if(parkingString_ped !== "") {
                	content_ped += `<div class="_tmap_preview_popup_address">\${parkingString_ped}</div>`;
                }
                
                content_ped += "</div></div>";
            
                var labelInfo2_ped = new Tmapv2.InfoWindow({
                    position: labelPosition_ped, //Popup 이 표출될 맵 좌표
                    content: content_ped, //Popup 표시될 text
                    border:'0px solid #FF0000', //Popup의 테두리 border 설정.
                    background: false,
                    offset: new Tmapv2.Point(-12, -6),
                    type: 2, //Popup의 type 설정.
                    align: Tmapv2.InfoWindowOptions.ALIGN_CENTERTOP,
                    map: map_ped //Popup이 표시될 맵 객체
                });
/* 
                var labelInfo2_ped = new Tmapv2.Label({
                    position : labelPosition_ped,
                    content : content_ped,
                    zIndex: 999,
                    align: 'ct',
                    map : map
                });
                 */
                //popup 생성
    
                // LABEL이 마커보다 상위에 표시되도록 수정함. 
                $("#map_div_ped ._tmap_preview_popup_text").parent().parent().css('z-index', 10);
                // popup들을 담을 배열에 팝업 저장
                labelArr_ped.push(labelInfo2_ped);
                
                map_ped.setCenter(labelPosition_ped);
            },
            onProgress: function() {},
            onError: function() {}
        }
        tData_ped.getPOIDataFromIdJson(poiId_ped,optionObj_ped, params_ped);
    }        
    
    // 지도에 그릴 모드 선택
    var drawMode_ped = "apiRoutesMulti_0";
    // 경로 API [검색] 버튼 동작
    async function apiSearchRoutes_ped() {
    	marker1_ped.setMap(null);
        var startx_ped = $("#startx_ped").val();
        var starty_ped = $("#starty_ped").val();
        var endx_ped = $("#endx_ped").val();
        var endy_ped = $("#endy_ped").val();
        if($("._btn_action_ped").hasClass('__color_grey')) {
            return false;
        }
        if(startx_ped == "" || starty_ped == "" || endx_ped == "" || endy_ped == "") {
            alert("정확한 주소를 입력하세요.");
            return false;
        }

        
        $("#apiResult_ped").empty();
        reset_ped();
        
        await routesPedestrian_ped();
        await routesCarInit_ped();

    }
    
    // (경로API) 보행자 경로 안내 API
    function routesPedestrian_ped() {
        return new Promise(function(resolve_ped, reject_ped) {
            // 출발지, 목적지의 좌표를 조회
            var startx_ped = $("#startx_ped").val();
            var starty_ped = $("#starty_ped").val();
            var endx_ped = $("#endx_ped").val();
            var endy_ped = $("#endy_ped").val();
            var startLatLng_ped = new Tmapv2.LatLng(starty_ped, startx_ped);
            var endLatLng_ped = new Tmapv2.LatLng(endy_ped, endx_ped);
            // 경유지 좌표 파라미터 생성
            var viaPoints_ped = [];
            $(".waypoint_input").each(function(idx_ped) {
                var pos_ped = $(this).find("input[name='multipos']").val();
                if(pos_ped == "") {
                    return true;
                }
                var viaX_ped = pos_ped.split(',')[0];
                var viaY_ped = pos_ped.split(',')[1];
                viaPoints_ped.push(viaX_ped + "," + viaY_ped);
            });
            var passList_ped = viaPoints_ped.join("_");
            var optionObj_ped = {
                reqCoordType: "WGS84GEO",
                resCoordType: "WGS84GEO",
                    passList: passList_ped,
            };
            var params_ped = {
                onComplete: function (result_ped) {
                    var resultData_ped = result_ped._responseData.features;
                    //결과 출력
                    var appendHtml_ped = `
                        <div class="_route_item">
                            <div class="_route_item_type \${drawMode_ped == "apiRoutesPedestrian_ped" ? "__color_blue" : ""}" onclick="routesRedrawMap_ped('apiRoutesPedestrian_ped');" style="cursor:">보행자 경로 안내</div>
                            <div class="_route_item_info">\${((resultData_ped[0].properties.totalTime) / 60).toFixed(0)}분 | \${((resultData_ped[0].properties.totalDistance) / 1000).toFixed(1)}km</div>
                        </div>
                    `;
                    // $("#apiResult").append(appendHtml_ped);
                    writeApiResultHtml_ped("apiRoutesPedestrian_ped", appendHtml_ped);
                    if (drawMode_ped == "apiRoutesPedestrian_ped") {
                        //기존 그려진 라인 & 마커가 있다면 초기화
                        reset_ped();
                        // 시작마커설정
                        markerStart_ped = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(starty_ped, startx_ped),
                            // icon: "http://topopen.tmap.co.kr/imgs/start.png",
                            iconHTML: `
                            <div class='_t_marker' style="position:relative;" >
                                <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                출발</div>
                            </div>
                            `,
                            offset: new Tmapv2.Point(24, 38),
                            iconSize: new Tmapv2.Size(24, 38),
                            map: map_ped
                        });
                        // 도착마커설정
                        markerEnd_ped = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(endy_ped, endx_ped),
                            // icon: "http://topopen.tmap.co.kr/imgs/arrival.png",
                            iconHTML: `
                            <div class='_t_marker' style="position:relative;" >
                                <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                도착</div>
                            </div>
                            `,
                            offset: new Tmapv2.Point(24, 38),
                            iconSize: new Tmapv2.Size(24, 38),
                            map: map_ped
                        });
                        // markerArr.push(marker_s);
                        // markerArr.push(marker_e);
                        // GeoJSON함수를 이용하여 데이터 파싱 및 지도에 그린다.
                        var jsonObject_ped = new Tmapv2.extension.GeoJSON();
                        var jsonForm_ped = jsonObject_ped.read(result_ped._responseData);
                        jsonObject_ped.drawRoute(map_ped, jsonForm_ped, {}, function (e) {
                            // 경로가 표출된 이후 실행되는 콜백 함수.
                            for (var m of e.markers) {
                            	markerArr_ped.push(m);
                            }
                            for (var l of e.polylines) {
                            	lineArr_ped.push(l);
                            }
                            var positionBounds_ped = new Tmapv2.LatLngBounds(); //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                            for (var polyline of e.polylines) {
                                for (var latlng of polyline.getPath().path) {
                                	positionBounds_ped.extend(latlng);  // LatLngBounds의 객체 확장
                                }
                            }
                            map_ped.panToBounds(positionBounds_ped);
                            map_ped.zoomOut();
                        });
                    }
                    resolve_ped();
                },
                onProgress: function () {
                },
                onError: function () {
                }
            };
            tData_ped.getRoutePlanForPeopleJson(startLatLng_ped, endLatLng_ped, "출발지", "도착지", optionObj_ped, params_ped);
        });
    }
    
    // (경로API) 자동차 경로 안내 API
    /* 
    mode: 
    - 0: 교통최적+추천(기본값)
    - 1: 교통최적+무료우선
    - 2: 교통최적+최소시간
    - 3: 교통최적+초보
    - 4: 교통최적+고속도로우선
    - 10: 최단거리+유/무료
    - 12: 이륜차도로우선
    - 19: 교통최적+어린이보호구역 회피
    */
    async function routesCarInit_ped() {
        var modes_ped = [0, 1, 2, 3, 4, 10, 12, 19];
        for(var mode_ped of modes_ped) {
            await routesCar_ped(mode_ped)
                .then(v =>{ console.log("complete routePlan: mode_ped: ", v); });
            await sleep_ped(500).then(() => console.log("done!"));
        }
    }
    function routesCar_ped(mode_ped) {
        // 각 searchOption별로 비동기 호출하기 때문에 promise객체로 동작보장
        // (한개의 경로만 조회할 시 아래의 promise 필요X)
        return new Promise(function(resolve_ped, reject_ped) {
            // 출발지, 목적지의 좌표를 조회
            var startx_ped = $("#startx_ped").val();
            var starty_ped = $("#starty_ped").val();
            var endx_ped = $("#endx_ped").val();
            var endy_ped = $("#endy_ped").val();
            var modes_ped = {
                0: "교통최적+추천(기본값)",
                1: "교통최적+무료우선",
                2: "교통최적+최소시간",
                3: "교통최적+초보",
                4: "교통최적+고속도로우선",
                10: "최단거리+유/무료",
                12: "이륜차도로우선",
                19: "교통최적+어린이보호구역 회피"
            }
            // 경유지 좌표 파라미터 생성
            var viaPoints_ped = [];
            $(".waypoint_input").each(function(idx_ped) {
                var pos_ped = $(this).find("input[name='multipos']").val();
                if(pos_ped == "") {
                    return true;
                }
                var viaX_ped = pos_ped.split(',')[0];
                var viaY_ped = pos_ped.split(',')[1];
                viaPoints_ped.push(viaX_ped + "," + viaY_ped);
            });
            var passList_ped = viaPoints_ped.join("_");
            var s_latlng_ped = new Tmapv2.LatLng (starty_ped, startx_ped);
            var e_latlng_ped = new Tmapv2.LatLng (endy_ped, endx_ped);
            var optionObj_ped = {
                reqCoordType:"WGS84GEO", //요청 좌표계 옵셥 설정입니다.
                resCoordType:"WGS84GEO",  //응답 좌표계 옵셥 설정입니다.
                trafficInfo:"Y",
                passList: passList_ped,
                searchOption: mode_ped
            };
            var params_ped = {
                onComplete: function(result_ped) {
                    var resultData_ped = result_ped._responseData.features;
                    var appendHtml_ped = `
                        <div class="_route_item">
                            <div class="_route_item_type \${drawMode_ped == "apiRoutesCar_" + mode_ped || drawMode_ped == "apiRoutesMulti_" + mode_ped ? "__color_blue" : ""}" onclick="routesRedrawMap_ped('apiRoutesCar_ped', '\${mode_ped}');">\${modes_ped[mode_ped]}</div>
                            <div class="_route_item_info">
                                \${(resultData_ped[0].properties.totalTime / 60).toFixed(0)}분 
                                | \${(resultData_ped[0].properties.totalDistance / 1000).toFixed(1)}km 
                                | \${resultData_ped[0].properties.totalFare}원 
                                | 택시 \${resultData_ped[0].properties.taxiFare}원</div>
                        </div>
                    `;
                    writeApiResultHtml_ped("apiRoutesCar_"+mode_ped, appendHtml_ped);
                    if(drawMode_ped == "apiRoutesCar_" + mode_ped || drawMode_ped == "apiRoutesMulti_" + mode_ped) {
                    	reset_ped();
                        var positionBounds_ped = new Tmapv2.LatLngBounds(); //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                        for ( var i in resultData_ped) { //for문 [S]
                            var geometry_ped = resultData_ped[i].geometry;
                            var properties = resultData_ped[i].properties;
                            if (geometry_ped.type == "LineString") {
                                //교통 정보도 담음
                                // chktraffic.push(geometry.traffic);
                                var sectionInfos_ped = [];
                                var trafficArr_ped = geometry_ped.traffic || [];
                                for ( var j in geometry_ped.coordinates) {
                                    var latlng = new Tmapv2.LatLng(geometry_ped.coordinates[j][1], geometry_ped.coordinates[j][0]);
                                    positionBounds_ped.extend(latlng);  // LatLngBounds의 객체 확장
                                    sectionInfos_ped.push(latlng);
                                }
                                drawLine_ped(sectionInfos_ped, trafficArr_ped);
                            } else {
                                var markerPosition_ped = new Tmapv2.LatLng(geometry_ped.coordinates[1], geometry_ped.coordinates[0]);
                                if (properties.pointType == "S") { //출발지 마커
                                	markerStart_ped = new Tmapv2.Marker({
                                        position : markerPosition_ped,
                                        iconHTML: `
                                        <div class='_t_marker' style="position:relative;" >
                                            <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                            출발</div>
                                        </div>
                                        `,
                                        offset: new Tmapv2.Point(24, 38),
                                        iconSize : new Tmapv2.Size(24, 38),
                                        map : map_ped
                                    });
                                } else if (properties.pointType == "E") { //도착지 마커
                                	markerEnd_ped = new Tmapv2.Marker({
                                        position : markerPosition_ped,
                                        iconHTML: `
                                        <div class='_t_marker' style="position:relative;" >
                                            <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                            도착</div>
                                        </div>
                                        `,
                                        offset: new Tmapv2.Point(24, 38),
                                        iconSize : new Tmapv2.Size(24, 38),
                                        map : map_ped
                                    });
                                } else { //각 포인트 마커
                                    var marker_p_ped = new Tmapv2.Marker({
                                        position : markerPosition_ped,
                                        icon : "http://topopen.tmap.co.kr/imgs/point.png",
                                        iconSize : new Tmapv2.Size(8, 8),
                                        zIndex:1,
                                        map : map_ped
                                    });
                            
                                    markerPoint_ped.push(marker_p_ped);
                                }
                            }
                        }//for문 [E]
                        map_ped.panToBounds(positionBounds_ped);
                        map_ped.zoomOut();
                        resolve_ped(mode_ped);
                    } else {
                    	resolve_ped(mode_ped);
                    }
                },
                onProgress: function() {},
                onError: function() {}
            };
            tData_ped.getRoutePlanJson(s_latlng_ped, e_latlng_ped, optionObj_ped, params_ped);
        });
    }
    function sleep_ped(ms) {
        return new Promise((r) => setTimeout(r, ms));
    }
    //마커 생성하기
    function addMarkers_ped(infoObj_ped) {
        var size_ped = new Tmapv2.Size(24, 38);//아이콘 크기 설정합니다.

        if (infoObj_ped.pointType == "P") { //포인트점일때는 아이콘 크기를 줄입니다.
        	size_ped = new Tmapv2.Size(8, 8);
        }

        marker_p_ped = new Tmapv2.Marker({
            position : new Tmapv2.LatLng(infoObj_ped.lat, infoObj_ped.lng),
            icon : infoObj_ped.markerImage,
            iconSize : size_ped,
            map : map_ped
        });

        markerArr_ped.push(marker_p_ped);
    }
    //라인그리기
    function drawLine_ped(arrPoint_ped, traffic_ped) {
        var polyline_ped;

            // 교통정보 혼잡도를 체크
            // strokeColor는 교통 정보상황에 다라서 변화
            // traffic :  0-정보없음, 1-원활, 2-서행, 3-지체, 4-정체  (black, green, yellow, orange, red)

            var lineColor_ped = "";

            if (traffic_ped != "0") {
                if (traffic_ped.length == 0) { //length가 0인것은 교통정보가 없으므로 검은색으로 표시

                	lineColor_ped = "#06050D";
                    //라인그리기[S]
                    polyline_ped = new Tmapv2.Polyline({
                        path : arrPoint_ped,
                        strokeColor : lineColor_ped,
                        strokeWeight : 6,
                        map : map_ped
                    });
                    lineArr_ped.push(polyline_ped);
                    //라인그리기[E]
                } else { //교통정보가 있음

                    if (traffic_ped[0][0] != 0) { //교통정보 시작인덱스가 0이 아닌경우
                        var trafficObject_ped = "";
                        var tInfo_ped = [];

                        for (var z = 0; z < traffic_ped.length; z++) {
                        	trafficObject_ped = {
                                "startIndex" : traffic_ped[z][0],
                                "endIndex" : traffic_ped[z][1],
                                "trafficIndex" : traffic_ped[z][2],
                            };
                        	tInfo_ped.push(trafficObject_ped)
                        }

                        var noInfomationPoint_ped = [];

                        for (var p = 0; p < tInfo_ped[0].startIndex; p++) {
                        	noInfomationPoint_ped.push(arrPoint_ped[p]);
                        }

                        //라인그리기[S]
                        polyline_ped = new Tmapv2.Polyline({
                            path : noInfomationPoint_ped,
                            strokeColor : "#06050D",
                            strokeWeight : 6,
                            map : map_ped
                        });
                        //라인그리기[E]
                        lineArr_ped.push(polyline_ped);

                        for (var x = 0; x < tInfo_ped.length; x++) {
                            var sectionPoint_ped = []; //구간선언

                            for (var y = tInfo_ped[x].startIndex; y <= tInfo_ped[x].endIndex; y++) {
                            	sectionPoint_ped.push(arrPoint_ped[y]);
                            }

                            if (tInfo_ped[x].trafficIndex == 0) {
                            	lineColor_ped = "#06050D";
                            } else if (tInfo_ped[x].trafficIndex == 1) {
                            	lineColor_ped = "#61AB25";
                            } else if (tInfo_ped[x].trafficIndex == 2) {
                            	lineColor_ped = "#FFFF00";
                            } else if (tInfo_ped[x].trafficIndex == 3) {
                            	lineColor_ped = "#E87506";
                            } else if (tInfo_ped[x].trafficIndex == 4) {
                            	lineColor_ped = "#D61125";
                            }

                            //라인그리기[S]
                            polyline_ped = new Tmapv2.Polyline({
                                path : sectionPoint_ped,
                                strokeColor : lineColor_ped,
                                strokeWeight : 6,
                                map : map_ped
                            });
                            //라인그리기[E]
                            lineArr_ped.push(polyline_ped);
                        }
                    } else { //0부터 시작하는 경우

                        var trafficObject_ped = "";
                        var tInfo_ped = [];

                        for (var z = 0; z < traffic_ped.length; z++) {
                        	trafficObject_ped = {
                                "startIndex" : traffic_ped[z][0],
                                "endIndex" : traffic_ped[z][1],
                                "trafficIndex" : traffic_ped[z][2],
                            };
                        	tInfo_ped.push(trafficObject_ped)
                        }

                        for (var x = 0; x < tInfo_ped.length; x++) {
                            var sectionPoint_ped = []; //구간선언

                            for (var y = tInfo_ped[x].startIndex; y <= tInfo_ped[x].endIndex; y++) {
                            	sectionPoint_ped.push(arrPoint_ped[y]);
                            }

                            if (tInfo_ped[x].trafficIndex == 0) {
                            	lineColor_ped = "#06050D";
                            } else if (tInfo_ped[x].trafficIndex == 1) {
                            	lineColor_ped = "#61AB25";
                            } else if (tInfo_ped[x].trafficIndex == 2) {
                            	lineColor_ped = "#FFFF00";
                            } else if (tInfo_ped[x].trafficIndex == 3) {
                            	lineColor_ped = "#E87506";
                            } else if (tInfo_ped[x].trafficIndex == 4) {
                            	lineColor_ped = "#D61125";
                            }

                            //라인그리기[S]
                            polyline_ped = new Tmapv2.Polyline({
                                path : sectionPoint_ped,
                                strokeColor : lineColor_ped,
                                strokeWeight : 6,
                                map : map_ped
                            });
                            //라인그리기[E]
                            lineArr_ped.push(polyline_ped);
                        }
                    }
                }
            } 
    }
    // 경유지 추가 컨트롤 함수
    function onMultiButton_ped(btn) {
        // 삭제 버튼이면 li 지움
        if($(btn).hasClass('wp_clear')) {
            $(btn).parent().prev('.__space_10_h').remove();
            $(btn).parent().remove();
            // 경유지를 지우고 남은 마지막 버튼을 추가버튼으로 변경
            var cnt0 = $(".waypoint_input").length;
            $(".waypoint_input:last").removeClass('wp_add wp_clear');
            $(".waypoint_input:last").addClass('wp_add');
/*                 
            $("#multiInput").find("button").each(function(idx_ped) {
                if((cnt0-1) == idx_ped) {
                    $(this).removeClass();
                    $(this).addClass('add');
                }
            });
 */
            
            // 마커 다시 그리기
            if(markerWp_ped.length > 0){
                for(var i in markerWp_ped){
                    if(markerWp_ped[i]) {
                    	markerWp_ped[i].setMap(null);
                    }
                }
                markerWp_ped = [];
            }
            $(".waypoint_input").each(function(idx_ped) {
                // 차례번호 재생성
                $(this).attr('data-idx_ped', idx_ped);
                var pos_ped = $(this).find("input[name='multipos']").val();
                if(pos_ped == "") {
                    return true;
                }
                var viaX_ped = pos_ped.split(',')[0];
                var viaY_ped = pos_ped.split(',')[1];
                markerWp_ped[idx_ped] = new Tmapv2.Marker({
                    position : new Tmapv2.LatLng(viaY_ped, viaX_ped),
                    icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx_ped + ".png",
                    iconSize : new Tmapv2.Size(24, 38),
                    map:map_ped
                });
            });
            return false;
        }
        // 경유지 value empty체크
        var val = $(btn).parent().find("input[type='text']").val();
        if(val == "") {
            alert("경유지를 입력하세요.");
            return false;
        }
        // 기존 버튼들은 삭제 버튼으로 변경
        $(".waypoint_input > button").each(function() {
            $(this).removeClass('wp_add wp_clear');
            $(this).addClass('wp_clear');
        });
        $("#wpList").append(`
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx_ped="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button class="wp_add" onclick="onMultiButton_ped(this);"></button>
            </div>
        `);
        // 총 개수가 5개 이상이면 - 로 변경
        var cnt2 = $(".waypoint_input").length;
        if(cnt2 >= 5) {
            $(".waypoint_input > button").each(function() {
                $(this).removeClass('wp_add wp_clear');
                $(this).addClass('wp_clear');
            })
        }
        // 차례번호 재생성
        $(".waypoint_input").each(function(idx_ped) {
            $(this).removeClass('wp_add wp_clear');
            $(this).attr('data-idx_ped', idx_ped);
        });
        $(".waypoint_input").removeClass('texton');
        $(".waypoint_input:last").addClass("texton");
    }
    function clickSearchPois_ped(buttonObj) {
        const $input = $(buttonObj).prev('input');
        if($(buttonObj).hasClass('_search_address_btn_ped')) {
            $("#searchAddress_ped").val($input.val());
            searchPois_ped();
        } else if($(buttonObj).parent('div').hasClass('waypoint_input')) {
            // 경유지 제거
            const $_deleteObj_ped = $(buttonObj).parent('div.waypoint_input');
            clearWaypoint_ped($_deleteObj_ped[0]);
        } else {
            const type = $input.attr('id') || '';
            if(type == "searchStartAddress_ped") {
                $("#startx_ped").val('');
                $("#starty_ped").val('');
                if(markerStart_ped) {
                	markerStart_ped.setMap(null);
                }
        
            } else if(type == "searchEndAddress_ped") {
                $("#endx_ped").val('');
                $("#endy_ped").val('');
                if(markerEnd_ped) {
                	markerEnd_ped.setMap(null);
                }
            }
            $input.val('');
            $("#searchAddress_ped").val('');
            $(buttonObj).removeClass('_delete_address_btn');
            $(buttonObj).addClass('_search_address_btn_ped');
            $("._btn_action_ped").addClass('__color_grey');
/*                 if(($("#searchStartAddress_ped").val() == "") || ($("#searchEndAddress_ped").val() == "")) {
                console.log("remove1");
                $("._btn_action_ped").addClass('__color_grey');
            } else {
                console.log("remove2");
                $("._btn_action_ped").removeClass('__color_grey');
            }
 */            }
    }
    
    //(경로API공통) 엔터키 통합검색 함수
    function onKeyupSearchPoi_ped(inputText) {
        /*
        if(($("#searchStartAddress_ped").val() == "") || ($("#searchEndAddress_ped").val() == "")) {
            $("._btn_action_ped").addClass('__color_grey');
        } else {
            $("._btn_action_ped").removeClass('__color_grey');
        }
        */
        $("._btn_action_ped").addClass('__color_grey');
        if($(inputText).next('button').hasClass('_delete_address_btn')) {
            $(inputText).val('');
        }
        $(inputText).next('button').removeClass('_delete_address_btn');
        $(inputText).next('button').addClass('_search_address_btn_ped');
        if (window.event.keyCode == 13) {
            // 엔터키가 눌렸을 때 실행하는 반응
            var isWaypoint_ped = $(inputText).parent('div.waypoint_input').length == 1;
            if(isWaypoint_ped) {
                // 경유지입력시 엔터키대상 li에대해 class추가
                $(".waypoint_input").each(function() {
                    $(this).removeClass('texton');
                });
                $(inputText).parent('div.waypoint_input').addClass('texton');
            }
            $("#searchAddress_ped").val($(inputText).val());
            searchPois_ped();
        }
    }
    
    // (경로API공통) 지도위의 경로 안내 효과 다시그림
    function routesRedrawMap_ped(mode_ped, carmode_ped) {
        
        if (mode_ped == "apiRoutesPedestrian_ped") {
        	drawMode_ped = mode_ped;
            routesPedestrian_ped();
        } else if (mode_ped == "apiRoutesCar_ped" || mode_ped == "apiRoutesMulti_ped") {
        	drawMode_ped = mode_ped+"_"+carmode_ped;
            routesCar_ped(carmode_ped);
        }
        $("#apiResult_ped").find('._route_item_type').removeClass('__color_blue');
        $("#apiResult_ped").find('#'+drawMode_ped).find('._route_item_type').addClass('__color_blue');
    }
    // (경로API공통) 출발지와 도착지의 좌표를 설정한다.
    function enterDest_ped(type_ped, address_ped, x_ped, y_ped) {
    	marker1_ped.setMap(null);
        // 기존 라인 지우기
        if(lineArr_ped.length > 0){
            for(var i in lineArr_ped) {
            	lineArr_ped[i].setMap(null);
            }
            //지운뒤 배열 초기화
            lineArr_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if(markerPoint_ped.length > 0){
            for(var i in markerPoint_ped){
            	markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }
        if(type_ped == 'start') {
            if(markerStart_ped) {
            	markerStart_ped.setMap(null);
            }
            $("#startx_ped").val(x_ped);
            $("#starty_ped").val(y_ped);
            $("#searchStartAddress_ped").val(address_ped);
            $("#searchStartAddress_ped").next('button').removeClass('_search_address_btn_ped');
            $("#searchStartAddress_ped").next('button').addClass('_delete_address_btn');
            
            markerStart_ped = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y_ped, x_ped),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    출발</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_ped
            });
        } else if(type_ped == 'end') {
            if(markerEnd_ped) {
            	markerEnd_ped.setMap(null);
            }
            $("#endx_ped").val(x_ped);
            $("#endy_ped").val(y_ped);
            $("#searchEndAddress_ped").val(address_ped);
            $("#searchEndAddress_ped").next('button').removeClass('_search_address_btn_ped');
            $("#searchEndAddress_ped").next('button').addClass('_delete_address_btn');
            
            markerEnd_ped = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y_ped, x_ped),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    도착</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_ped
            });
        } else if(type_ped == 'wp') {
            const currentSize_ped = $(".waypoint_input").length;
            const prependHtml_ped = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _wp_not_empty _map_overlay_row" data-idx_ped="0">
                <input type="hidden" name="multipos" value="\${x_ped},\${y_ped}">
                <input type="text" value="\${address_ped}" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_ped(this);" class="_delete_address_btn" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
            const emptyHtml_ped = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx_ped="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_ped(this);" class="_search_address_btn_ped" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
            if(currentSize_ped < 5) {
                const $_deleteObj_ped = $("#wpList .waypoint_input:last");
                $_deleteObj_ped.prev('.__space_10_h').remove();
                $_deleteObj_ped.remove();
                $("#wpList").append(prependHtml_ped);
                $("#wpList").append(emptyHtml_ped);
            } else {
                const $_deleteObj_ped = $("#wpList .waypoint_input:last");
                $_deleteObj_ped.prev('.__space_10_h').remove();
                $_deleteObj_ped.remove();
                $("#wpList").append(prependHtml_ped);
            }
            redrawRouteMarker_ped();
        }
        /* 검색버튼 활성화/비활성화 체크  */
        var startx_ped = $("#startx_ped").val();
        var starty_ped = $("#starty_ped").val();
        var endx_ped = $("#endx_ped").val();
        var endy_ped = $("#endy_ped").val();
        if(startx_ped == "" || starty_ped == "" || endx_ped == "" || endy_ped == "") {
            $("._btn_action_ped").addClass('__color_grey');
        } else {
            $("._btn_action_ped").removeClass('__color_grey');
        }
        
        // reset();
    }
    
    function clearWaypoint_ped(destObj_ped) {
        const currentSize_ped = $(".waypoint_input._wp_not_empty").length;
        console.log("clearWaypoint_ped: ", currentSize_ped);
        const emptyHtml_ped = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx_ped="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_ped(this);" class="_search_address_btn_ped" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
        const $_deleteObj_ped = $(destObj_ped);
        $_deleteObj_ped.prev('.__space_10_h').remove();
        $_deleteObj_ped.remove();
        if(currentSize_ped == 5) {
        $("#wpList").append(emptyHtml_ped);
        }
        redrawRouteMarker_ped();
    }
    /* 경로검색시 경유지 마커 다시 그림 */
    function redrawRouteMarker_ped() {
        if(markerWp_ped.length > 0){
            for(var i in markerWp_ped) {
            	markerWp_ped[i].setMap(null);
            }
            //지운뒤 배열 초기화
            markerWp_ped = [];
        }
        $(".waypoint_input").each(function(idx_ped) {
            // 차례번호 재생성
            $(this).attr('data-idx_ped', idx_ped);
            var pos_ped = $(this).find("input[name='multipos']").val();
            if(pos_ped == "") {
                return true;
            }
            var viaX_ped = pos_ped.split(',')[0];
            var viaY_ped = pos_ped.split(',')[1];
            markerWp_ped[idx_ped] = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(viaY_ped, viaX_ped),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx_ped + ".png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    \${idx_ped+1}</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map:map_ped
            });
        });
    }
    // (경로API공통) API 결과값 기록
    function writeApiResultHtml_ped(type_ped, string) {
        if($("#apiResult_ped div#results").length == 0) {
            $("#apiResult_ped").empty();
            $("#apiResult_ped").html(`
                <div class="_result_panel_bg_ped">
                    <div class="_result_panel_scroll">
                        <div class="__space_10_h"></div>
                        <div id="results"></div>
                        <div id="apiRoutesPedestrian_ped"></div>
                        <div id="apiRoutesCar_ped"></div>
                        <div id="apiRoutesMulti_ped"></div>
                    </div>
                </div>
            `);
        }
        if(type_ped.startsWith("apiRoutesCar_")) {
            if($("#apiResult_ped #apiRoutesCar_ped").find("#"+type_ped).length == 0 ) {
                $("#apiResult_ped #apiRoutesCar_ped").append(`<div id="\${type_ped}">\${string}</div>`);
            }
        } else if(type_ped.startsWith("apiRouteSequential_") || type_ped.startsWith("routesOptimization")) {
            if($("#apiResult_ped #apiRoutesMulti_ped").find("#"+type_ped).length == 0 ) {
                $("#apiResult_ped #apiRoutesMulti_ped").append(`<div id="\${type_ped}">\${string}</div>`);
            }
        } else {
            $("#apiResult_ped").find("#"+type_ped).html(string);
        }
    } 
    
    
    // 버튼 클릭 시 reset_ped 함수 호출
 $("#resetButton").on("click", function () {
	 function resetMap() {
	        for (var i in totalMarkerArr) {
	            totalMarkerArr[i].setMap(null);
	        }
	        totalMarkerArr = [];

	        for (var i in resultdrawArr) {
	            resultdrawArr[i].setMap(null);
	        }
	        resultdrawArr = [];
	        
	        $('#result').empty();
	    }

	    resetMap();
 });


    
    var totalMarkerArr = []; // 전역 범위에서 정의
    var resultdrawArr = [];
    $(document).on('click', "#date1", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date1").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    $(document).on('click', "#date2", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date2").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    $(document).on('click', "#date3", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date3").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    
    $(document).on('click', "#date4", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date4").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    $(document).on('click', "#date5", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date5").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    $(document).on('click', "#date6", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date6").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
    
    
    $(document).on('click', "#date7", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $("#date7").text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList = passList.substring(0, passList.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            		             	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";

            		$.ajax({
            				method : "POST",
            				headers : headers,
            				url : "https://apis.openapi.sk.com/tmap/routes/pedestrian?version=1&format=json&callback=result",
            				async : false,
            				data : {
            					"startX" : startX,
            					"startY" : startY,
            					"endX" : endX,
            					"endY" : endY,
            					"reqCoordType" : "WGS84GEO",
            					"resCoordType" : "EPSG3857",
            					"startName" : "출발지",
            					"endName" : "도착지",
            						"passList": passList // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success : function(response) {
            					var resultData = response.features;

            					//결과 출력
            					var tDistance = "총 거리 : "
            							+ ((resultData[0].properties.totalDistance) / 1000)
            									.toFixed(1) + "km,";
            					var tTime = " 총 시간 : "
            							+ ((resultData[0].properties.totalTime) / 60)
            									.toFixed(0) + "분";

            					$("#result").text(tDistance + tTime);
            					
            					//기존 그려진 라인 & 마커가 있다면 초기화
            					if (resultdrawArr.length > 0) {
            						for ( var i in resultdrawArr) {
            							resultdrawArr[i].setMap(null);
            						}
            						resultdrawArr = [];
            					}
            					
            					drawInfoArr = [];

            					for ( var i in resultData) { //for문 [S]
            						var geometry = resultData[i].geometry;
            						var properties = resultData[i].properties;
            						var polyline_;


            						if (geometry.type == "LineString") {
            							for ( var j in geometry.coordinates) {
            								// 경로들의 결과값(구간)들을 포인트 객체로 변환 
            								var latlng = new Tmapv2.Point(
            										geometry.coordinates[j][0],
            										geometry.coordinates[j][1]);
            								// 포인트 객체를 받아 좌표값으로 변환
            								var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            										latlng);
            								// 포인트객체의 정보로 좌표값 변환 객체로 저장
            								var convertChange = new Tmapv2.LatLng(
            										convertPoint._lat,
            										convertPoint._lng);
            								// 배열에 담기
            								drawInfoArr.push(convertChange);
            							}
            						} else {
            							var markerImg = "";
            							var pType = "";
            							var size;

            							if (properties.pointType == "S") { //출발지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png";
            							    pType = "S";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "E") { //도착지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png";
            							    pType = "E";
            							    size = new Tmapv2.Size(24, 38);
            							} else if (properties.pointType == "P") { //경유지 마커
            							    markerImg = "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png";
            							    pType = "P";
            							    size = new Tmapv2.Size(24, 38);
            							} else { //기타 포인트 마커
            							    markerImg = "http://topopen.tmap.co.kr/imgs/point.png";
            							    pType = "0";
            							    size = new Tmapv2.Size(8, 8);
            							}
            							
            							// 경로들의 결과값들을 포인트 객체로 변환 
            							var latlon = new Tmapv2.Point(
            									geometry.coordinates[0],
            									geometry.coordinates[1]);

            							// 포인트 객체를 받아 좌표값으로 다시 변환
            							var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            									latlon);

            							var routeInfoObj = {
            								markerImage : markerImg,
            								lng : convertPoint._lng,
            								lat : convertPoint._lat,
            								pointType : pType
            							};

            						}
            					}//for문 [E]
            					drawLine(drawInfoArr);
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon, lat, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
                                break;
                            case "llPass":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png';
                                break;
                            case "llEnd":
                                imgURL = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat, lon),
                            icon: imgURL,
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }

                    function drawLine(arrPoint) {
                        var polyline_;

                        polyline_ = new Tmapv2.Polyline({
                            path: arrPoint,
                            strokeColor: "#DD0000",
                            strokeWeight: 6,
                            map: map_ped
                        });
                        resultdrawArr.push(polyline_);
                    }
            }
        });
    });
    
    function reset_ped() {
        // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null);
            }
            // 지운 뒤 배열 초기화
            lineArr_ped = [];
        }

        // 기존 마커 지우기
        if (markerStart_ped) {
            markerStart_ped.setMap(null);
        }
        if (markerEnd_ped) {
            markerEnd_ped.setMap(null);
        }
        if (markerArr_ped.length > 0) {
            for (var i in markerArr_ped) {
                markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if (markerPoi_ped.length > 0) {
            for (var i in markerPoi_ped) {
                markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if (markerPoint_ped.length > 0) {
            for (var i in markerPoint_ped) {
                markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }

        // 기존 팝업 지우기
        if (labelArr_ped.length > 0) {
            for (var i in labelArr_ped) {
                labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }

        // 기존 지도 객체가 있다면 삭제
        if (map_ped) {
            // 지도 객체를 초기화하고 다시 생성하거나, 필요에 따라 새로운 설정으로 생성
            map_ped = null;
        }
    }
</script>
</body>
</html>