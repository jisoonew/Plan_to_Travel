<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>

<!-- 태그 모음 -->
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
	src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ

 autoload=false"></script>
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
					style="position: absolute; width: 50px; height: 31px; margin-top: 14px; margin-left: 185px; pointer-events: all; cursor: pointer;">
					출발</button>
				<div class="__space_13_w"></div>
				<input type="text" id="searchEndAddress_ped"
					class="_search_entry _search_entry_short" placeholder="목적지를 입력하세요"
					onkeyup="onKeyupSearchPoi_ped(this);">
				<button onclick="clickSearchPois_ped(this);"
					class="_search_address_btn_ped btn btn-primary btn-sm"
					style="position: absolute; width: 50px; height: 31px; margin-top: 53px; margin-left: 185px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">
					도착</button>
				<div class="__space_10_w"></div>
				<button
					class="_btn_action_ped _btn_action-search __color_grey btn btn-primary btn-sm"
					onclick="routesRedrawMap_ped('apiRoutesPedestrian');">검색</button>
			</div>
			<div id="wpList">
				<div class="__space_10_h"></div>
				<div class="waypoint_input _map_overlay_row" data-idx_ped="0">
					<input type="hidden" name="multipos_ped" /> <input type="text"
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
  	
  	$('#place_add').hide();
  	$('#place_add_car').hide();
  	$('#place_add_ped').show();
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
                <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                P</div>
            </div>
            `,
            offset: new Tmapv2.Point(24, 38),
            iconSize : new Tmapv2.Size(24, 38),
            map : map_ped
        });
        var lon_ped = mapLatLng_ped._lng;
        var lat_ped = mapLatLng_ped._lat;
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
            appKey : '3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ',
            lon_ped,
            lat_ped
        }
        const option_ped = {
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
                appKey : "3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ",
                lon_ped,
                lat_ped
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
                                            <div class="_search_item_button" onclick="enterDest_ped('start', '\${rName_ped}', '\${lon_ped}', '\${lat_ped}');">
                                                출발
                                            </div>
                                            <div class="_search_item_button" onclick="enterDest_ped('end', '\${rName_ped}', '\${lon_ped}', '\${lat_ped}');">
                                                도착
                                            </div>
                                                <div class="_search_item_button" onclick="enterDest_ped('wp', '\${rName_ped}', '\${lon_ped}', '\${lat_ped}');">
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
                    $("#result").text("가까운 도로 검색 결과가 없습니다.");
                }
            },
            error:function(request,status,error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
        tData.getAddressFromGeoJson(lat_ped, lon_ped, optionObj_ped, params_ped);
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
                <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                P</div>
            </div>
            `,
            offset: new Tmapv2.Point(24, 38),
            iconSize : new Tmapv2.Size(24, 38),
            map : map_ped
        });
        var lon_ped = mapLatLng_ped._lng;
        var lat_ped = mapLatLng_ped._lat;
       
        var optionObj_ped = {
            coordType: "WGS84GEO",       //응답좌표 타입 옵션 설정 입니다.
            addressType: "A10"           //주소타입 옵션 설정 입니다.
        };
        var params_ped = {
            onComplete:function(result) { //데이터 로드가 성공적으로 완료 되었을때 실행하는 함수 입니다.
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
                var arrResult_ped = result._responseData.addressInfo;
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
                            <p class="_result_text_line_memo_print_ped" style="display: none;">\${newRoadAddr_ped}</p>
                            <p class="_result_text_line">지번주소 : \${jibunAddr_ped}</p>
                            <p class="_result_text_line">좌표 (WSG84) : \${lat_ped}, \${lon_ped}</p>
                            <p class="_result_text_line" id="_result_text_line_memo_lat_ped">\${lat_ped}</p>
                            <p class="_result_text_line" id="_result_text_line_memo_lng_ped">\${lon_ped}</p>
                            <p class="_result_text_line"></p>
                        </div>
                        <div>
                            <div class="_search_item_button_panel">
                                    <div class="_search_item_button" onclick="enterDest_ped('start', '\${newRoadAddr_ped}', '\${lon_ped}', '\${lat_ped}');">
                                        출발
                                    </div>
                                    <div class="_search_item_button" onclick="enterDest_ped('end', '\${newRoadAddr_ped}', '\${lon_ped}', '\${lat_ped}');">
                                        도착
                                    </div>
                                        <div class="_search_item_button" onclick="enterDest_ped('wp', '\${newRoadAddr_ped}', '\${lon_ped}', '\${lat_ped}');">
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
        tData_ped.getAddressFromGeoJson(lat_ped, lon_ped, optionObj_ped, params_ped);
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
            onComplete: function(result) {
                // 데이터 로드가 성공적으로 완료되었을 때 발생하는 이벤트입니다.
                var resultpoisData_ped = result._responseData.searchPoiInfo.pois.poi;
                // 기존 마커, 팝업 제거
                reset_pedMap();
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
                    
                    var lat_ped = Number(resultpoisData_ped[k].noorLat);
                    var lon_ped = Number(resultpoisData_ped[k].noorLon);
                    
                    var frontLat = Number(resultpoisData_ped[k].frontLat);
                    var frontLon = Number(resultpoisData_ped[k].frontLon);
                    
                    var markerPosition_ped = new Tmapv2.LatLng(lat_ped, lon_ped);
                    
                    var fullAddressRoad = resultpoisData_ped[k].newAddressList.newAddress[0].fullAddressRoad;
                    
                    const marker3_ped = new Tmapv2.Marker({
                        position : markerPosition_ped,
                        //icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png",
                        iconHTML:`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="https://openapi.sk.com/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
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
                        for(let tMarker_ped of markerPoi_ped) {
                            const labelInfo_ped = $(tMarker_ped.getOtherElements()).text();
                            const forK_ped = labelInfo_ped.split("_")[0];
                            tMarker_ped.setIconHTML(`
                                <div class='_t_marker' style="position:relative;" >
                                <img src="https://openapi.sk.com/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                \${Number(forK_ped)+1}</div>
                                </div>
                            `);
                             // marker z-index 초기화
                             $(tMarker_ped.getOtherElements()).next('div').css('z-index', 100);
                        }
                        // 선택한 marker z-index 처리 
                        $(marker3_ped.getOtherElements()).next('div').css('z-index', 101);
                        const labelInfo_ped = $(marker3_ped.getOtherElements()).text();
                        const thisK_ped = labelInfo_ped.split("_")[0];
                        const thisId_ped = labelInfo_ped.split("_")[1];
                        marker3_ped.setIconHTML(`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
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
                                <p class="_search_item_info_address">중심점 : \${lat_ped}, \${lon_ped}</p>
                                <p class="_search_item_info_address">입구점 : \${frontLat}, \${frontLon}</p>
                            </div>
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button __color_blue" onclick='poiDetail_ped("\${id}", "\${k}");'>
                                    상세 정보
                                </div>
                            </div>
                            
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button" onclick="enterDest_ped('start', '\${name_ped}', '\${lon_ped}', '\${lat_ped}');">
                                    출발
                                </div>
                                <div class="_search_item_button" onclick="enterDest_ped('end', '\${name_ped}', '\${lon_ped}', '\${lat_ped}');">
                                    도착
                                </div>
                                <div class="_search_item_button" onclick="enterDest_ped('wp', '\${name_ped}', '\${lon_ped}', '\${lat_ped}');">
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
        for(let tMarker_ped of markerPoi_ped) {
            const labelInfo_ped = $(tMarker_ped.getOtherElements()).text();
            const forK_ped = labelInfo_ped.split("_")[0];
            tMarker_ped.setIconHTML(`
                    <div class='_t_marker' style="position:relative;" >
                    <img src="https://openapi.sk.com/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    \${Number(forK_ped)+1}</div>
                    </div>
                `);
             // marker z-index 초기화
             $(tMarker_ped.getOtherElements()).next('div').css('z-index', 100);
        }
        
        /* 도보 장소 검색 이후 상세 정보를 클릭하면 파란색 마커가 출력된다. */
        markerPoi_ped[thisK_ped].setIconHTML(`
            <div class='_t_marker' style="position:relative;" >
            <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
            \${Number(thisK_ped)+1}</div>
            </div>
        `);
        
        // 선택한 marker z-index 처리 
        $(markerPoi_ped[thisK_ped].getOtherElements()).next('div').css('z-index', 101);
        var scrollOffset = $("#poi_"+thisK_ped)[0].offsetTop - $("._result_panel_scroll")[0].offsetTop
        $("._result_panel_scroll").animate({scrollTop: scrollOffset}, 'slow');
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
            onComplete: function(result) {
                // 응답받은 POI 정보
                var detailInfo_ped = result._responseData.poiDetailInfo;
                console.log(detailInfo_ped);
                var name_ped = detailInfo_ped.name;
                var bldAddr_ped = detailInfo_ped.bldAddr;
                var tel_ped = detailInfo_ped.tel;
                var bizCatName_ped = detailInfo_ped.bizCatName;
                var parkingString = (detailInfo_ped.parkFlag == "0"? "주차 불가능": (detailInfo_ped.parkFlag == "1" ? "주차 가능": ""));
                var zipCode_ped = detailInfo_ped.zipCode;
                var lat_ped = Number(detailInfo_ped.lat);
                var lon_ped = Number(detailInfo_ped.lon);
                var bldNo1_ped = detailInfo_ped.bldNo1;
                var bldNo2_ped = detailInfo_ped.bldNo2;
                
                var labelPosition_ped = new Tmapv2.LatLng(lat_ped, lon_ped);
                if(bldNo1_ped !== "") {
                	bldAddr_ped += ` \${bldNo1_ped}`;
                }
                if(bldNo2_ped !== "") {
                	bldAddr_ped += `-\${bldNo2_ped}`;
                }
                
                /* 상세 정보를 클릭 이후 정보에 대한 정보 출력 */
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
                if(parkingString !== "") {
                	content_ped += `<div class="_tmap_preview_popup_address">\${parkingString}</div>`;
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
        reset_pedMap();
        
        await routesPedestrian_ped();
        await routesCarInit_ped();

    }
    
    // (경로API) 보행자 경로 안내 API
    function routesPedestrian_ped() {
        return new Promise(function(resolve, reject) {
            // 출발지, 목적지의 좌표를 조회
            var startx_ped = $("#startx_ped").val();
            var starty_ped = $("#starty_ped").val();
            var endx_ped = $("#endx_ped").val();
            var endy_ped = $("#endy_ped").val();
            var startLatLng_ped = new Tmapv2.LatLng(starty_ped, startx_ped);
            var endLatLng_ped = new Tmapv2.LatLng(endy_ped, endx_ped);
            // 경유지 좌표 파라미터 생성
            var viaPoints_ped = [];
            $(".waypoint_input").each(function(idx) {
                var pos_ped = $(this).find("input[name='multipos_ped']").val();
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
                onComplete: function (result) {
                    var resultData_ped = result._responseData.features;
                    //결과 출력
                    var appendHtml_ped = `
                        <div class="_route_item">
                            <div class="_route_item_type \${drawMode_ped == "apiRoutesPedestrian" ? "__color_blue" : ""}" style="cursor:">보행자 경로 안내</div>
                            <div class="_route_item_info">도보 : \${((resultData_ped[0].properties.totalTime) / 60).toFixed(0)}분 | \${((resultData_ped[0].properties.totalDistance) / 1000).toFixed(1)}km</div>
                        </div>
                    `;
                    // $("#apiResult_ped").append(appendHtml_ped);
                    writeApiResultHtml_ped("apiRoutesPedestrian", appendHtml_ped);
                    if (drawMode_ped == "apiRoutesPedestrian") {
                        //기존 그려진 라인 & 마커가 있다면 초기화
                        reset_pedMap();
                        // 시작마커설정
                        markerStart_ped = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(starty_ped, startx_ped),
                            // icon: "http://topopen.tmap.co.kr/imgs/start.png",
                            iconHTML: `
                            <div class='_t_marker' style="position:relative;">
                                <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
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
                                <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
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
                        var jsonForm_ped = jsonObject_ped.read(result._responseData);
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
                    resolve();
                },
                onProgress: function () {
                },
                onError: function () {
                    alert('보행자 경로 - 결과 값이 없습니다.');

                }
            };
            tData_ped.getRoutePlanForPeopleJson(startLatLng_ped, endLatLng_ped, "출발지", "도착지", optionObj_ped, params_ped);
        });
    }
    
    
    function sleep(ms) {
        return new Promise((r) => setTimeout(r, ms));
    }
    //마커 생성하기
    function addMarkers(infoObj) {
        var size = new Tmapv2.Size(24, 38);//아이콘 크기 설정합니다.

        if (infoObj.pointType == "P") { //포인트점일때는 아이콘 크기를 줄입니다.
            size = new Tmapv2.Size(8, 8);
        }

        marker_p = new Tmapv2.Marker({
            position : new Tmapv2.LatLng(infoObj.lat, infoObj.lng),
            icon : infoObj.markerImage,
            iconSize : size,
            map : map_ped
        });

        markerArr_ped.push(marker_p);
    }
    //라인그리기
    function drawLine_ped(arrPoint, traffic) {
        var polyline_ped;

            // 교통정보 혼잡도를 체크
            // strokeColor는 교통 정보상황에 다라서 변화
            // traffic :  0-정보없음, 1-원활, 2-서행, 3-지체, 4-정체  (black, green, yellow, orange, red)

            var lineColor = "";

            if (traffic != "0") {
                if (traffic.length == 0) { //length가 0인것은 교통정보가 없으므로 검은색으로 표시

                    lineColor = "#06050D";
                    //라인그리기[S]
                    polyline_ped = new Tmapv2.Polyline({
                        path : arrPoint,
                        strokeColor : lineColor,
                        strokeWeight : 6,
                        map : map_ped
                    });
                    lineArr_ped.push(polyline_ped);
                    //라인그리기[E]
                } else { //교통정보가 있음

                    if (traffic[0][0] != 0) { //교통정보 시작인덱스가 0이 아닌경우
                        var trafficObject = "";
                        var tInfo = [];

                        for (var z = 0; z < traffic.length; z++) {
                            trafficObject = {
                                "startIndex" : traffic[z][0],
                                "endIndex" : traffic[z][1],
                                "trafficIndex" : traffic[z][2],
                            };
                            tInfo.push(trafficObject)
                        }

                        var noInfomationPoint = [];

                        for (var p = 0; p < tInfo[0].startIndex; p++) {
                            noInfomationPoint.push(arrPoint[p]);
                        }

                        //라인그리기[S]
                        polyline_ped = new Tmapv2.Polyline({
                            path : noInfomationPoint,
                            strokeColor : "#06050D",
                            strokeWeight : 6,
                            map : map_ped
                        });
                        //라인그리기[E]
                        lineArr_ped.push(polyline_ped);

                        for (var x = 0; x < tInfo.length; x++) {
                            var sectionPoint = []; //구간선언

                            for (var y = tInfo[x].startIndex; y <= tInfo[x].endIndex; y++) {
                                sectionPoint.push(arrPoint[y]);
                            }

                            if (tInfo[x].trafficIndex == 0) {
                                lineColor = "#06050D";
                            } else if (tInfo[x].trafficIndex == 1) {
                                lineColor = "#61AB25";
                            } else if (tInfo[x].trafficIndex == 2) {
                                lineColor = "#FFFF00";
                            } else if (tInfo[x].trafficIndex == 3) {
                                lineColor = "#E87506";
                            } else if (tInfo[x].trafficIndex == 4) {
                                lineColor = "#D61125";
                            }

                            //라인그리기[S]
                            polyline_ped = new Tmapv2.Polyline({
                                path : sectionPoint,
                                strokeColor : lineColor,
                                strokeWeight : 6,
                                map : map_ped
                            });
                            //라인그리기[E]
                            lineArr_ped.push(polyline_ped);
                        }
                    } else { //0부터 시작하는 경우

                        var trafficObject = "";
                        var tInfo = [];

                        for (var z = 0; z < traffic.length; z++) {
                            trafficObject = {
                                "startIndex" : traffic[z][0],
                                "endIndex" : traffic[z][1],
                                "trafficIndex" : traffic[z][2],
                            };
                            tInfo.push(trafficObject)
                        }

                        for (var x = 0; x < tInfo.length; x++) {
                            var sectionPoint = []; //구간선언

                            for (var y = tInfo[x].startIndex; y <= tInfo[x].endIndex; y++) {
                                sectionPoint.push(arrPoint[y]);
                            }

                            if (tInfo[x].trafficIndex == 0) {
                                lineColor = "#06050D";
                            } else if (tInfo[x].trafficIndex == 1) {
                                lineColor = "#61AB25";
                            } else if (tInfo[x].trafficIndex == 2) {
                                lineColor = "#FFFF00";
                            } else if (tInfo[x].trafficIndex == 3) {
                                lineColor = "#E87506";
                            } else if (tInfo[x].trafficIndex == 4) {
                                lineColor = "#D61125";
                            }

                            //라인그리기[S]
                            polyline_ped = new Tmapv2.Polyline({
                                path : sectionPoint,
                                strokeColor : lineColor,
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
            $("#multiInput").find("button").each(function(idx) {
                if((cnt0-1) == idx) {
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
            $(".waypoint_input").each(function(idx) {
                // 차례번호 재생성
                $(this).attr('data-idx', idx);
                var pos_ped = $(this).find("input[name='multipos_ped']").val();
                if(pos_ped == "") {
                    return true;
                }
                var viaX_ped = pos_ped.split(',')[0];
                var viaY_ped = pos_ped.split(',')[1];
                markerWp_ped[idx] = new Tmapv2.Marker({
                    position : new Tmapv2.LatLng(viaY_ped, viaX_ped),
                    icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx + ".png",
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
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos_ped" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="margin-top: 10px;">
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
        $(".waypoint_input").each(function(idx) {
            $(this).removeClass('wp_add wp_clear');
            $(this).attr('data-idx', idx);
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
            const $_deleteObj = $(buttonObj).parent('div.waypoint_input');
            clearWaypoint_ped($_deleteObj[0]);
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
        if(($("#searchStartAddress").val() == "") || ($("#searchEndAddress_ped").val() == "")) {
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
    function routesRedrawMap_ped(mode, carmode) {
        
        if (mode == "apiRoutesPedestrian") {
        	drawMode_ped = mode;
        	routesPedestrian_ped();
        } else if (mode == "apiRoutesCar" || mode == "apiRoutesMulti") {
        	drawMode_ped = mode+"_"+carmode;
        	routesCar_ped(carmode);
        }
        $("#apiResult_ped").find('._route_item_type').removeClass('__color_blue');
        $("#apiResult_ped").find('#'+drawMode_ped).find('._route_item_type').addClass('__color_blue');
    }
    // (경로API공통) 출발지와 도착지의 좌표를 설정한다.
    function enterDest_ped(type, address, x, y) {
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
        if(type == 'start') {
            if(markerStart_ped) {
            	markerStart_ped.setMap(null);
            }
            $("#startx_ped").val(x);
            $("#starty_ped").val(y);
            $("#searchStartAddress_ped").val(address);
            $("#searchStartAddress_ped").next('button').removeClass('_search_address_btn_ped');
            $("#searchStartAddress_ped").next('button').addClass('_delete_address_btn');
            
            markerStart_ped = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y, x),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    출발</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_ped
            });
        } else if(type == 'end') {
            if(markerEnd_ped) {
            	markerEnd_ped.setMap(null);
            }
            $("#endx_ped").val(x);
            $("#endy_ped").val(y);
            $("#searchEndAddress_ped").val(address);
            $("#searchEndAddress_ped").next('button').removeClass('_search_address_btn_ped');
            $("#searchEndAddress_ped").next('button').addClass('_delete_address_btn');
            
            markerEnd_ped = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y, x),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    도착</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_ped
            });
        } else if(type == 'wp') {
        	// 경유지 삭제
            const currentSize = $(".waypoint_input").length;
            const prependHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _wp_not_empty _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos_ped" value="\${x},\${y}">
                <input type="text" value="\${address}" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." id="stopover_btn">
                <button onclick="clickSearchPois_ped(this);" class="_delete_address_btn btn btn-primary btn-sm" style="pointer-events: all; cursor: pointer;">삭제</button>
                <div style="width: 90px;"></div>
            </div>
            `;
            const emptyHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos_ped" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="margin-top: 10px;">
                <button onclick="clickSearchPois_ped(this);" class="_search_address_btn_ped btn btn-primary btn-sm" style="margin-top: 10px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">경유 검색</button>
                <div style="width: 90px;"></div>
            </div>
            `;
            if(currentSize < 5) {
                const $_deleteObj = $("#wpList .waypoint_input:last");
                $_deleteObj.prev('.__space_10_h').remove();
                $_deleteObj.remove();
                $("#wpList").append(prependHtml);
                $("#wpList").append(emptyHtml);
            } else {
                const $_deleteObj = $("#wpList .waypoint_input:last");
                $_deleteObj.prev('.__space_10_h').remove();
                $_deleteObj.remove();
                $("#wpList").append(prependHtml);
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
        
        // reset_pedMap();
    }
    function clearWaypoint_ped(destObj) {
        const currentSize = $(".waypoint_input._wp_not_empty").length;
        console.log("clearWaypoint_ped: ", currentSize);
        const emptyHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos_ped" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi_ped(this);" placeholder="경유지를 입력하세요." style="margin-top: 10px;">
                <button onclick="clickSearchPois_ped(this);" class="_search_address_btn_ped btn btn-primary btn-sm" style="margin-top: 10px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">경유 검색</button>
                <div style="width: 90px;"></div>
            </div>
            `;
        const $_deleteObj = $(destObj);
        $_deleteObj.prev('.__space_10_h').remove();
        $_deleteObj.remove();
        if(currentSize == 5) {
        $("#wpList").append(emptyHtml);
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
        $(".waypoint_input").each(function(idx) {
            // 차례번호 재생성
            $(this).attr('data-idx', idx);
            var pos_ped = $(this).find("input[name='multipos_ped']").val();
            if(pos_ped == "") {
                return true;
            }
            var viaX_ped = pos_ped.split(',')[0];
            var viaY_ped = pos_ped.split(',')[1];

            markerWp_ped[idx] = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(viaY_ped, viaX_ped),
                // icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx + ".png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    \${idx+1}</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map:map_ped
            });
            
            console.log("여기는 경유지 : " + markerWp_ped[idx]);
        });
    }
    // (경로API공통) API 결과값 기록
    function writeApiResultHtml_ped(type, string) {
        if($("#apiResult_ped div#results").length == 0) {
            $("#apiResult_ped").empty();
            $("#apiResult_ped").html(`
                <div class="_result_panel_bg_ped">
                    <div class="_result_panel_scroll">
                        <div class="__space_10_h"></div>
                        <div id="results"></div>
                        <div id="apiRoutesPedestrian"></div>
                        <div id="apiRoutesCar"></div>
                        <div id="apiRoutesMulti"></div>
                    </div>
                </div>
            `);
        }
        if(type.startsWith("apiRoutesCar_")) {
            if($("#apiResult_ped #apiRoutesCar").find("#"+type).length == 0 ) {
                $("#apiResult_ped #apiRoutesCar").append(`<div id="\${type}">\${string}</div>`);
            }
        } else if(type.startsWith("apiRouteSequential_") || type.startsWith("routesOptimization")) {
            if($("#apiResult_ped #apiRoutesMulti").find("#"+type).length == 0 ) {
                $("#apiResult_ped #apiRoutesMulti").append(`<div id="\${type}">\${string}</div>`);
            }
        } else {
            $("#apiResult_ped").find("#"+type).html(string);
        }
    }   
    // (API 공통) 맵에 그려져있는 라인, 마커, 팝업을 지우는 함수
    function reset_pedMap() {
    	
        // 기존 라인 지우기
    if (lineArr_ped.length > 0) {
        for (var i in lineArr_ped) {
            lineArr_ped[i].setMap(null); // 라인을 지도에서 삭제
        }
        // 지운 뒤 배열 초기화
        lineArr_ped = [];
    }
    
        // 기존 마커 지우기
        if(markerStart_ped) {
        	markerStart_ped.setMap(null);
        }
        if(markerEnd_ped) {
        	markerEnd_ped.setMap(null);
        }
        if(markerArr_ped.length > 0){
            for(var i in markerArr_ped){
            	markerArr_ped[i].setMap(null);
            }
            markerArr_ped = [];
        }
        // poi 마커 지우기
        if(markerPoi_ped.length > 0){
            for(var i in markerPoi_ped){
            	markerPoi_ped[i].setMap(null);
            }
            markerPoi_ped = [];
        }
        // 경로찾기 point 마커 지우기
        if(markerPoint_ped.length > 0){
            for(var i in markerPoint_ped){
            	markerPoint_ped[i].setMap(null);
            }
            markerPoint_ped = [];
        }
        
        // 기존 팝업 지우기
        if(labelArr_ped.length > 0){
            for(var i in labelArr_ped){
            	labelArr_ped[i].setMap(null);
            }
            labelArr_ped = [];
        }
    }
    
    
 // 메모에 장소명 추가
    $(document).on('click', ".place_add_ped", function () {
    	$('#memo_place').val($("._result_text_line_memo_print_ped").text());
    	$('#memo_place_lat').val($("#_result_text_line_memo_lat_ped").text());
    	$('#memo_place_lng').val($("#_result_text_line_memo_lng_ped").text());
    });

    
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
	        
                for(var i in markerWp_ped){
                    if(markerWp_ped[i]) {
                    	markerWp_ped[i].setMap(null);
                    }
                }
                markerWp_ped = [];
            
	        
	        $('#result').empty();
	    }

	    resetMap();
	    
	    // 티맵 검색으로 생성된 마커와 폴리라인 초기화
	    reset_pedMap();
 });


    
    var totalMarkerArr = []; // 전역 범위에서 정의
    var resultdrawArr = [];
    $(document).on('click', "[id^=date]", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $(this).text()
            },
            success: function (response) {
            	var marker_s, marker_e, marker_p1, marker_p2;
            	var drawInfoArr_ped = [];
            	var lastIndex_lng = response.length - 2;
                var lastIndex_lat = response.length - 1;
                var lastIndex_ = response.length - 3;            		

                        // 시작
                        addMarker("llStart", response[0], response[1], 1);
                        // 도착
                        addMarker("llEnd", response[lastIndex_lng], response[lastIndex_lat], 2);

                        var passList_ped = ""; // 경유지 생성 변수

                        if (response.length > 4) {
                            // 패턴 생성
                            for (var i = 2; i < response.length - 2; i += 2) {
                                addMarker("llPass", response[i], response[i + 1], i + 1);
                                passList_ped += response[i] + "," + response[i + 1] + "_";
                            }
                            // 마지막에 추가된 밑줄 제거
                            passList_ped = passList_ped.substring(0, passList_ped.length - 1);
                        }

            		// 3. 경로탐색 API 사용요청
            	var startX = response[0];
             	var startY = response[1];
             	var endX = response[lastIndex_lng];
             	var endY = response[lastIndex_lat];
            		var headers = {}; 
            			headers["appKey"]="3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ";

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
            					"passList": passList_ped // 경유지 배열을 문자열로 변환하여 전달
            				},
            				success: function(response) {
            				    var resultData_ped = response.features;

            				    // 경로 데이터가 비어 있는지 확인
            				    if (resultData_ped.length === 0) {
            				        console.error("경로 데이터가 비어 있습니다.");
            				        return;
            				    }

            				    // 경로 그리기 함수 호출 전에 폴리라인을 그릴 경로 점 배열 초기화
            				    var drawInfoArr_ped = [];

            				    // 결과 출력 및 폴리라인 그리기
            				    var appendHtml_ped = `
            				        <div class="_route_item">
            				            <div class="_route_item_type \${drawMode_ped == "apiRoutesPedestrian" ? "__color_blue" : ""}" onclick="routesRedrawMap_ped('apiRoutesPedestrian');" style="cursor:">보행자 경로 안내</div>
            				            <div class="_route_item_info">도보 : \${((resultData_ped[0].properties.totalTime) / 60)
            				                .toFixed(0)}분 | \${((resultData_ped[0].properties.totalDistance) / 1000)
            				                .toFixed(1)}km</div>
            				        </div>
            				    `;

            				    writeApiResultHtml_ped("apiRoutesPedestrian", appendHtml_ped);

            				    // 기존에 그려진 라인 및 마커 초기화
            				    /* reset_ped(); */

            				    for (var i = 0; i < resultData_ped.length; i++) {
            				        var geometry_ped = resultData_ped[i].geometry;

            				        if (geometry_ped.type === "LineString") {
            				            for (var j = 0; j < geometry_ped.coordinates.length; j++) {
            				                var latlng = new Tmapv2.Point(
            				                    geometry_ped.coordinates[j][0],
            				                    geometry_ped.coordinates[j][1]
            				                );
            				                var convertPoint = new Tmapv2.Projection.convertEPSG3857ToWGS84GEO(
            				                    latlng
            				                );
            				                var convertChange = new Tmapv2.LatLng(
            				                    convertPoint._lat,
            				                    convertPoint._lng
            				                );
            				                drawInfoArr_ped.push(convertChange); // 폴리라인을 그릴 경로 점 배열에 추가
            				            }            				            
            				        } else {
            				            // 마커 추가 등의 코드
            				        }
            				    }
            				    drawPolyline(drawInfoArr_ped); // 폴리라인 그리기 함수 호출
            				},
            				error : function(request, status, error) {
            					console.log("code:" + request.status + "\n"
            							+ "message:" + request.responseText + "\n"
            							+ "error:" + error);
            				}
            			});
            		
            		function addMarker(status, lon_ped, lat_ped, tag) {
                        var imgURL;
                        switch (status) {
                            case "llStart":
                                imgURL = `
                                    <div class='_t_marker' style="position:relative;" >
                                    <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                    출발</div>
                                </div>
                                `;
                                break;
                            case "llPass":
                                imgURL = `
                                    <div class='_t_marker' style="position:relative;" >
                                    <img src="https://openapi.sk.com/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                    P</div>
                                </div>
                                `;
                                break;
                            case "llEnd":
                                imgURL = `
                                    <div class='_t_marker' style="position:relative;" >
                                    <img src="https://openapi.sk.com/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                    도착</div>
                                </div>
                                `;
                                break;
                            default:
                        }
                        var marker = new Tmapv2.Marker({
                            position: new Tmapv2.LatLng(lat_ped, lon_ped),
                            iconHTML: imgURL,
                            offset: new Tmapv2.Point(24, 38),
                            iconSize: new Tmapv2.Size(24, 38),
                            map: map_ped
                        });
                        totalMarkerArr.push(marker);
                        return marker;
                    }

            		function addComma(num) {
                        var regexp = /\B(?=(\d{3})+(?!\d))/g;
                        return num.toString().replace(regexp, ',');
                    }
            }
        });
    });
    
 // 폴리 라인을 그리는 함수
function drawPolyline(polylineCoordinates) {
    var polylineOptions = {
        path: polylineCoordinates, // 폴리 라인을 구성하는 좌표 배열
        strokeColor: '#FF0000', // 폴리 라인의 색상 (여기서는 빨간색으로 설정)
        strokeOpacity: 1.0, // 폴리 라인의 투명도 (0.0부터 1.0까지 설정 가능)
        strokeWeight: 3 // 폴리 라인의 두께
    };

    // 폴리 라인을 생성하여 지도에 표시합니다.
    var polyline = new Tmapv2.Polyline(polylineOptions);
    polyline.setMap(map_ped); // 지도 객체에 폴리 라인을 추가합니다.
    resultdrawArr.push(polyline); // 폴리 라인 객체를 배열에 추가
}
    
    function reset_ped() {        
     // 기존 라인 지우기
        if (lineArr_ped.length > 0) {
            for (var i in lineArr_ped) {
                lineArr_ped[i].setMap(null); // 라인을 지도에서 삭제
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