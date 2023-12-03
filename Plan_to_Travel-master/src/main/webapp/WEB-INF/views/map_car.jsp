<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false" %>
<!-- 선언부 -->

<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <title>Tmap API Example</title>
        <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <link href="resources/css/map_car.css" rel="stylesheet" />
    <script type="text/javascript" src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7 autoload=false"></script><!--  autoload=false -->
</head>
<body>
    <div id="map_div_car">
    <input type="hidden" id="searchAddress_car" />
    <input type="hidden" id="startx_car" />
    <input type="hidden" id="starty_car" />
    <input type="hidden" id="endx_car" />
    <input type="hidden" id="endy_car" />
    <div class="_map_layer_overlay">
        <div class="__space_15_h"></div>
        <div class="_map_overlay_row">
        	<div id="car_start_div">
            <input type="text" id="searchStartAddress_car" class="_search_entry _search_entry_short" placeholder="출발지를 입력하세요" onkeyup="onKeyupSearchPoi(this);">
            <button id="car_start_btn" onclick="clickSearchPois_car(this);" class="_search_address_btn btn btn-primary btn-sm" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">
            출발
            </button>
            </div>
            
            <div class="__space_13_w"></div>
            
            <div id="car_end_div">
            <input type="text" id="searchEndAddress_car" class="_search_entry _search_entry_short" placeholder="목적지를 입력하세요" onkeyup="onKeyupSearchPoi(this);">
            <button id="car_end_btn" onclick="clickSearchPois_car(this);" class="_search_address_btn btn btn-primary btn-sm" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">
            도착
            </button>
            </div>
            
                        <div class="__space_10_w"></div>
            <div class="_btn_action_car _btn_action-search __color_grey btn btn-primary btn-sm" style="margin-top: -85px; margin-left: 240px;" onclick="apiSearchRoutes_car();">검색</div>
        </div>
        
        <div id="wpList_car">
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry_car _search_entry_short" style="margin-top: -40px;" onkeyup="onKeyupSearchPoi(this);" placeholder="경유지를 입력하세요.">
                <button onclick="clickSearchPois_car(this);" class="_search_address_btn btn btn-primary btn-sm" style="margin-top: -40px; margin-bottom: 14px; pointer-events: all; cursor: pointer;">경유지</button>
                <div style="width: 90px;"></div>
                <!-- <button onclick="onMultiButton(this);" class="_search_address_btn" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button> -->
            </div>
        </div>
        
        <div class="scroll_box_car">
        <div class="__flex_expand"></div>
        <div id="apiResult_car" class="_map_overlay_row">
            <div class="_result_panel_bg ">
                <div class="_result_panel">
                        
                    <div class="__disable_text">경유지 경로 안내<br>
                    <div id="car_result"></div>
                    </div>
                                        </div>
            </div>
        </div>
    </div>
    </div>
</div>

<script>
var map_car;

function map_car_show(){	 
	$('#map_div_car').show();
  	$('#map_div_home').hide();
  	$('#map_div_ped').hide();
  	
  	$('#place_add').hide();
  	$('#place_add_car').show();
  	$('#place_add_ped').hide();
  	};

  	map_car = new Tmapv2.Map("map_div_car", { // 지도가 생성될 div
        center: new Tmapv2.LatLng(37.570028, 126.986072),    // 지도의 중심좌표
        width : "500px", // 지도의 넓이
        height : "740px", // 지도의 높이
        zoom : 18, // 지도의 줌레벨
        httpsMode: true,    // https모드 설정
    });
    
    // 지도 타입 변경: ROAD
    map_car.setMapType(Tmapv2.Map.MapType.ROAD);
    /* API시작 */
    // 마커 초기화
    var markerStart_car = null;
    var markerEnd_car = null;
    var markerWp = [];
    var markerPoi = [];
    var markerPoint = [];
    var markerArr = [], lineArr = [], labelArr = [];
    var marker1 = new Tmapv2.Marker({
        icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_a.png",
        iconSize : new Tmapv2.Size(24, 38),
        map : map_car
    });
    var tData = new Tmapv2.extension.TData();
        
    
    // (장소API) 주소 찾기
    //경로 탐색 우클릭 시 인접도로 검색
    map_car.addListener("contextmenu", function onContextmenu(evt) {
        var mapLatLng = evt.latLng;
        //기존 마커 삭제
        marker1.setMap(null);
        var markerPosition = new Tmapv2.LatLng(
                mapLatLng._lat, mapLatLng._lng);
        //마커 올리기
        marker1 = new Tmapv2.Marker({
            position : markerPosition,
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
            map : map_car
        });
        var lon = mapLatLng._lng;
        var lat = mapLatLng._lat;
        if(labelArr.length > 0){
            for(var i in labelArr){
                labelArr[i].setMap(null);
            }
            labelArr = [];
        }
        // poi 마커 지우기
        if(markerPoi.length > 0){
            for(var i in markerPoi){
                markerPoi[i].setMap(null);
            }
            markerPoi = [];
        }
        var params = {
            appKey : '5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7',
            lon,
lat
        }
        const option = {
            method: 'GET',
            headers: {
                'Content-Type': 'application/json;charset=utf-8',
            },
            body: JSON.stringify(params),
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
                
                var resultHeader, resultlinkPoints;
                
                if(response.resultData.header){
                    resultHeader = response.resultData.header;
                    resultlinkPoints = response.resultData.linkPoints;
                    
                    var tDistance = resultHeader.totalDistance;
                    var tTime = resultHeader.speed;	
                    var rName = resultHeader.roadName;
                    
                    
                    // 기존 라인 지우기
                    if(lineArr.length > 0){
                        for(var k=0; k<lineArr.length ; k++){
                            lineArr[k].setMap(null);
                        }
                        //지운뒤 배열 초기화
                        lineArr = [];
                    }
                    
                    var drawArr = [];
                    
                    // Tmapv2.LatLng객체로 이루어진 배열을 만듭니다.
                    for(var i in resultlinkPoints){
                        var lineLatLng = new Tmapv2.LatLng(resultlinkPoints[i].location.latitude, resultlinkPoints[i].location.longitude);
                        
                        drawArr.push(lineLatLng);
                    }
                    
                    //그리기
                    var polyline_ = new Tmapv2.Polyline({
                            path : drawArr,	//만든 배열을 넣습니다.
                            strokeColor : "#FF0000",
                            strokeWeight: 6,
                            map : map_car
                    });
                    
                    //라인 정보를 배열에 담습니다.
                    lineArr.push(polyline_);
                    let resultStr = `
                        <div class="_result_panel_bg">
                            <div class="_result_panel_area">
                                <div class="__reverse_geocoding_result" style="flex-grow: 1;">
                                    <p class="_result_text_line">총거리 : \${tDistance}m</p>
                                    <p class="_result_text_line">제한속도 : \${tTime}km/h</p>
                                    <p class="_result_text_line">도로명 : \${rName}</p>
                                    <p class="_result_text_line"></p>
                                </div>
                                <div>
                                    <div class="_search_item_button_panel">
                                            <div class="_search_item_button" onclick="enterDest('start', '\${rName}', '\${lon}', '\${lat}');">
                                                출발
                                            </div>
                                            <div class="_search_item_button" onclick="enterDest('end', '\${rName}', '\${lon}', '\${lat}');">
                                                도착
                                            </div>
                                                <div class="_search_item_button" onclick="enterDest('wp', '\${rName}', '\${lon}', '\${lat}');">
                                                    경유
                                                </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        `;
                    var resultDiv = document.getElementById("apiResult_car");
                    resultDiv.innerHTML = resultStr;
                    
                }else{
                    $("#result").text("가까운 도로 검색 결과가 없습니다.");
                }
            },
            error:function(request,status,error){
                console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
            }
        });
        // tData.getAddressFromGeoJson(lat, lon, optionObj, params);
    });
    map_car.addListener("click", function onClick(evt) {
        var mapLatLng = evt.latLng;
        //기존 마커 삭제
        marker1.setMap(null);
        // 기존 라인 지우기
        if(lineArr.length > 0){
            for(var k=0; k<lineArr.length ; k++){
                lineArr[k].setMap(null);
            }
            //지운뒤 배열 초기화
            lineArr = [];
        }
        var markerPosition = new Tmapv2.LatLng(
                mapLatLng._lat, mapLatLng._lng);
        //마커 올리기
        marker1 = new Tmapv2.Marker({
            position : markerPosition,
            icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png",
            iconHTML: `
            <div class='_t_marker' style="position:relative;" >
                <img src="/lib/img/_icon/marker_blue.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                P</div>
            </div>
            `,
            offset: new Tmapv2.Point(24, 38),
            iconSize : new Tmapv2.Size(24, 38),
            map : map_car
        });
        var lon = mapLatLng._lng;
        var lat = mapLatLng._lat;
       
        var optionObj = {
            coordType: "WGS84GEO",       //응답좌표 타입 옵션 설정 입니다.
            addressType: "A10"           //주소타입 옵션 설정 입니다.
        };
        var params = {
            onComplete:function(result) { //데이터 로드가 성공적으로 완료 되었을때 실행하는 함수 입니다.
                // 기존 팝업 지우기
                if(labelArr.length > 0){
                    for(var i in labelArr){
                        labelArr[i].setMap(null);
                    }
                    labelArr = [];
                }
                
                // poi 마커 지우기
                if(markerPoi.length > 0){
                    for(var i in markerPoi){
                        markerPoi[i].setMap(null);
                    }
                    markerPoi = [];
                }
                $("#searchAddress_car").val('');
                $("._btn_radio").removeClass('__color_blue_fill');
                var arrResult = result._responseData.addressInfo;
                var fullAddress = arrResult.fullAddress.split(",");
                var newRoadAddr = fullAddress[2];
                var jibunAddr = fullAddress[1];
                if (arrResult.buildingName != '') {//빌딩명만 존재하는 경우
                    jibunAddr += (' ' + arrResult.buildingName);
                }
                let resultStr = `
                <div class="_result_panel_bg">
                    <div class="_result_panel_area">
                        <div class="__reverse_geocoding_result" style="flex-grow: 1;">
                            <p class="_result_text_line">새주소 : \${newRoadAddr}</p>
                            <p class="_result_text_line_memo_print_car" style="display: none;">\${newRoadAddr}</p>
                            <p class="_result_text_line">지번주소 : \${jibunAddr}</p>
                            <p class="_result_text_line">좌표 (WSG84) : \${lat}, \${lon}</p>
                            <p class="_result_text_line" id="_result_text_line_memo_lat_car">\${lat}</p>
                            <p class="_result_text_line" id="_result_text_line_memo_lng_car">\${lon}</p>
                            <p class="_result_text_line"></p>
                        </div>
                        <div>
                            <div class="_search_item_button_panel">
                                    <div class="_search_item_button" onclick="enterDest('start', '\${newRoadAddr}', '\${lon}', '\${lat}');">
                                        출발
                                    </div>
                                    <div class="_search_item_button" onclick="enterDest('end', '\${newRoadAddr}', '\${lon}', '\${lat}');">
                                        도착
                                    </div>
                                        <div class="_search_item_button" onclick="enterDest('wp', '\${newRoadAddr}', '\${lon}', '\${lat}');">
                                            경유
                                        </div>
                            </div>
                        </div>
                    </div>
                </div>
                `;
                
                var resultDiv = document.getElementById("apiResult_car");
                resultDiv.innerHTML = resultStr;
            },      
            onProgress:function() {},   //데이터 로드 중에 실행하는 함수 입니다.
            onError:function() {        //데이터 로드가 실패했을때 실행하는 함수 입니다.
                alert("onError");
            }             
        };
        tData.getAddressFromGeoJson(lat, lon, optionObj, params);
    });
    // (장소API) 통합 검색 함수
    function searchPois() {
        var searchKeyword = $("#searchAddress_car").val();
        var optionObj = {
            resCoordType : "WGS84GEO",
            reqCoordType : "WGS84GEO",
            count: 10
        };
        var params = {
            onComplete: function(result) {
                // 데이터 로드가 성공적으로 완료되었을 때 발생하는 이벤트입니다.
                var resultpoisData = result._responseData.searchPoiInfo.pois.poi;
                // 기존 마커, 팝업 제거
                reset();
                $("._btn_radio").removeClass('__color_blue_fill');
                if(marker1) {
                    marker1.setMap(null);
                }
                
                var innerHtml =    // Search Reulsts 결과값 노출 위한 변수
                `
                <div class="_result_panel_bg _scroll_padding">
                    <div class="_result_panel_scroll">
                `;
                var positionBounds = new Tmapv2.LatLngBounds();        //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                
                for(var k in resultpoisData){
                    // POI 정보의 ID
                    var id = resultpoisData[k].id;
                    
                    var name_car = resultpoisData[k].name;
                    
                    var lat = Number(resultpoisData[k].noorLat);
                    var lon = Number(resultpoisData[k].noorLon);
                    
                    var frontLat = Number(resultpoisData[k].frontLat);
                    var frontLon = Number(resultpoisData[k].frontLon);
                    
                    var markerPosition = new Tmapv2.LatLng(lat, lon);
                    
                    var fullAddressRoad_car = resultpoisData[k].newAddressList.newAddress[0].fullAddressRoad;
                    
                    const marker3_car = new Tmapv2.Marker({
                        position : markerPosition,
                        icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + k + ".png",
                        iconHTML:`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                            \${Number(k)+1}</div>
                            </div>
                        `,
                        iconSize : new Tmapv2.Size(24, 38),
                        title : name_car,
                        label: `<span style="display:none;">\${k}_\${id}</span>`,
                        map:map_car
                    });
                    
                    // 마커 클릭 이벤트 추가
                    marker3_car.addListener("click", function(evt) {
                        for(let tMarker of markerPoi) {
                            const labelInfo_car = $(tMarker.getOtherElements()).text();
                            const forK = labelInfo_car.split("_")[0];
                            tMarker.setIconHTML(`
                                <div class='_t_marker' style="position:relative;" >
                                <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                \${Number(forK)+1}</div>
                                </div>
                            `);
                             // marker z-index 초기화
                             $(tMarker.getOtherElements()).next('div').css('z-index', 100);
                        }
                        // 선택한 marker z-index 처리 
                        $(marker3_car.getOtherElements()).next('div').css('z-index', 101);
                        const labelInfo_car = $(marker3_car.getOtherElements()).text();
                        const thisK = labelInfo_car.split("_")[0];
                        const thisId = labelInfo_car.split("_")[1];
                        marker3_car.setIconHTML(`
                            <div class='_t_marker' style="position:relative;" >
                            <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                            \${Number(thisK)+1}</div>
                            </div>
                        `);
                        poiDetail(thisId, thisK);
                    });
                    
                    innerHtml += `
                        <div class="_search_item" id="poi_\${k}">
                            <div class="_search_item_poi">
                                <div class="_search_item_poi_icon _search_item_poi_icon_grey">
                                    <div class="_search_item_poi_icon_text">\${Number(k)+1}</div>
                                </div>
                            </div>
                            <div class="_search_item_info">
                                <p class="_search_item_info_title">\${name_car}</p>
                                <p class="_search_item_info_address">\${fullAddressRoad_car}</p>
                                <p class="_search_item_info_address">중심점 : \${lat}, \${lon}</p>
                                <p class="_search_item_info_address">입구점 : \${frontLat}, \${frontLon}</p>
                            </div>
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button __color_blue" onclick='poiDetail("\${id}", "\${k}");'>
                                    상세정보
                                </div>
                            </div>
                            <div class="_search_item_button_panel">
                                <div class="_search_item_button" onclick="enterDest('start', '\${name_car}', '\${lon}', '\${lat}');">
                                    출발
                                </div>
                                <div class="_search_item_button" onclick="enterDest('end', '\${name_car}', '\${lon}', '\${lat}');">
                                    도착
                                </div>
                                <div class="_search_item_button" onclick="enterDest('wp', '\${name_car}', '\${lon}', '\${lat}');">
                                    경유
                                </div>
                            </div>
                            
                        </div>
                        \${(resultpoisData.length-1) == Number(k) ? "": `<div class="_search_item_split"></div>`}
                    `;
                    markerPoi.push(marker3_car);
                    positionBounds.extend(markerPosition);    // LatLngBounds의 객체 확장
                }
                
                innerHtml += "</div></div>";
                $("#apiResult_car").html(innerHtml);    //searchResult 결과값 노출
                map_car.panToBounds(positionBounds);    // 확장된 bounds의 중심으로 이동시키기
                map_car.zoomOut();
            },
            onProgress: function() {},
            onError: function(){}
        }
        tData.getPOIDataFromSearchJson(searchKeyword, optionObj, params);
        
    }    
        
    // POI 상세검색 함수
    function poiDetail(poiId, thisK) {
        for(let tMarker of markerPoi) {
            const labelInfo_car = $(tMarker.getOtherElements()).text();
            const forK = labelInfo_car.split("_")[0];
            tMarker.setIconHTML(`
                <div class='_t_marker' style="position:relative;" >
                <img src="/lib/img/_icon/marker_grey.svg" style="width:48px;height:48px;position:absolute;"/>
                <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                \${Number(forK)+1}</div>
                </div>
            `);
             // marker z-index 초기화
             $(tMarker.getOtherElements()).next('div').css('z-index', 100);
        }
        markerPoi[thisK].setIconHTML(`
            <div class='_t_marker' style="position:relative;" >
            <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
            \${Number(thisK)+1}</div>
            </div>
        `);
        // 선택한 marker z-index 처리 
        $(markerPoi[thisK].getOtherElements()).next('div').css('z-index', 101);
        var scrollOffset = $("#poi_"+thisK)[0].offsetTop - $("._result_panel_scroll")[0].offsetTop
        $("._result_panel_scroll").animate({scrollTop: scrollOffset}, 'slow');
        $("._result_panel_scroll ._search_item_poi_icon").removeClass("_search_item_poi_icon_blue");
        $("#poi_"+thisK).find('._search_item_poi_icon').addClass("_search_item_poi_icon_blue");
        // 기존 라벨 지우기
        if(labelArr.length > 0){
            for(var i in labelArr){
                labelArr[i].setMap(null);
            }
            labelArr = [];
        }
    
        var optionObj = {
            resCoordType: "WGS84GEO"
        }
        var params = {
            onComplete: function(result) {
                // 응답받은 POI 정보
                var detailInfo = result._responseData.poiDetailInfo;
                console.log(detailInfo);
                var name_car = detailInfo.name;
                var bldAddr = detailInfo.bldAddr;
                var tel = detailInfo.tel;
                var bizCatName = detailInfo.bizCatName;
                var parkingString = (detailInfo.parkFlag == "0"? "주차 불가능": (detailInfo.parkFlag == "1" ? "주차 가능": ""));
                var zipCode = detailInfo.zipCode;
                var lat = Number(detailInfo.lat);
                var lon = Number(detailInfo.lon);
                var bldNo1 = detailInfo.bldNo1;
                var bldNo2 = detailInfo.bldNo2;
                
                var labelPosition = new Tmapv2.LatLng(lat, lon);
                if(bldNo1 !== "") {
                    bldAddr += ` \${bldNo1}`;
                }
                if(bldNo2 !== "") {
                    bldAddr += `-\${bldNo2}`;
                }
                var content = `
                    <div class="_tmap_preview_popup_text">
                        <div class="_tmap_preview_popup_info">
                            <div class="_tmap_preview_popup_title">\${name_car}</div>
                            <div class="_tmap_preview_popup_address">\${bldAddr}</div>
                            <div class="_tmap_preview_popup_address">\${zipCode}</div>
                            <div class="_tmap_preview_popup_address">\${bizCatName}</div>
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
                if(tel !== "") {
                    content += `<div class="_tmap_preview_popup_address">\${tel}</div>`;
                }
                if(parkingString !== "") {
                    content += `<div class="_tmap_preview_popup_address">\${parkingString}</div>`;
                }
                
                content += "</div></div>";
            
                var labelInfo2 = new Tmapv2.InfoWindow({
                    position: labelPosition, //Popup 이 표출될 맵 좌표
                    content: content, //Popup 표시될 text
                    border:'0px solid #FF0000', //Popup의 테두리 border 설정.
                    background: false,
                    offset: new Tmapv2.Point(-12, -6),
                    type: 2, //Popup의 type 설정.
                    align: Tmapv2.InfoWindowOptions.ALIGN_CENTERTOP,
                    map: map_car //Popup이 표시될 맵 객체
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
                $("#map_div_car ._tmap_preview_popup_text").parent().parent().css('z-index', 10);
                // popup들을 담을 배열에 팝업 저장
                labelArr.push(labelInfo2);
                
                map_car.setCenter(labelPosition);
            },
            onProgress: function() {},
            onError: function() {}
        }
        tData.getPOIDataFromIdJson(poiId,optionObj, params);
    }        
    
    // 지도에 그릴 모드 선택
    var drawMode = "apiRoutesMulti_0";
    // 경로 API [검색] 버튼 동작
    async function apiSearchRoutes_car() {
        marker1.setMap(null);
        var startx_car = $("#startx_car").val();
        var starty_car = $("#starty_car").val();
        var endx_car = $("#endx_car").val();
        var endy_car = $("#endy_car").val();
        if($("._btn_action").hasClass('__color_grey')) {
            return false;
        }
        if(startx_car == "" || starty_car == "" || endx_car == "" || endy_car == "") {
            alert("정확한 주소를 입력하세요.");
            return false;
        }

        
        $("#apiResult_car").empty();
        reset();
        
        await routesCarInit();

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
    async function routesCarInit() {
        var modes = [0, 1, 2, 3, 4, 10, 12, 19];
        for(var mode of modes) {
            await routesCar(mode)
                .then(v =>{ console.log("complete routePlan: mode: ", v); });
            await sleep(500).then(() => console.log("done!"));
        }
    }
    function routesCar(mode) {
        // 각 searchOption별로 비동기 호출하기 때문에 promise객체로 동작보장
        // (한개의 경로만 조회할 시 아래의 promise 필요X)
        return new Promise(function(resolve, reject) {
            // 출발지, 목적지의 좌표를 조회
            var startx_car = $("#startx_car").val();
            var starty_car = $("#starty_car").val();
            var endx_car = $("#endx_car").val();
            var endy_car = $("#endy_car").val();
            var modes = {
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
            var viaPoints = [];
            $(".waypoint_input").each(function(idx) {
                var pos = $(this).find("input[name='multipos']").val();
                if(pos == "") {
                    return true;
                }
                var viaX = pos.split(',')[0];
                var viaY = pos.split(',')[1];
                viaPoints.push(viaX + "," + viaY);
            });
            var passList = viaPoints.join("_");
            var s_latlng = new Tmapv2.LatLng (starty_car, startx_car);
            var e_latlng = new Tmapv2.LatLng (endy_car, endx_car);
            var optionObj = {
                reqCoordType:"WGS84GEO", //요청 좌표계 옵셥 설정입니다.
                resCoordType:"WGS84GEO",  //응답 좌표계 옵셥 설정입니다.
                trafficInfo:"Y",
                passList: passList,
                searchOption: mode
            };
            var params = {
                onComplete: function(result) {
                    var resultData = result._responseData.features;
                    var appendHtml = `
                        <div class="_route_item">
                            <div class="_route_item_type \${drawMode == "apiRoutesCar_" + mode || drawMode == "apiRoutesMulti_" + mode ? "__color_blue" : ""}" onclick="routesRedrawMap('apiRoutesCar', '\${mode}');">\${modes[mode]}</div>
                            <div class="_route_item_info">
                                \${(resultData[0].properties.totalTime / 60).toFixed(0)}분 
                                | \${(resultData[0].properties.totalDistance / 1000).toFixed(1)}km 
                                | \${resultData[0].properties.totalFare}원 
                                | 택시 \${resultData[0].properties.taxiFare}원</div>
                        </div>
                    `;
                    writeApiResultHtml("apiRoutesCar_"+mode, appendHtml);
                    if(drawMode == "apiRoutesCar_" + mode || drawMode == "apiRoutesMulti_" + mode) {
                        reset();
                        var positionBounds = new Tmapv2.LatLngBounds(); //맵에 결과물 확인 하기 위한 LatLngBounds객체 생성
                        for ( var i in resultData) { //for문 [S]
                            var geometry = resultData[i].geometry;
                            var properties = resultData[i].properties;
                            if (geometry.type == "LineString") {
                                //교통 정보도 담음
                                // chktraffic.push(geometry.traffic);
                                var sectionInfos = [];
                                var trafficArr = geometry.traffic || [];
                                for ( var j in geometry.coordinates) {
                                    var latlng = new Tmapv2.LatLng(geometry.coordinates[j][1], geometry.coordinates[j][0]);
                                    positionBounds.extend(latlng);  // LatLngBounds의 객체 확장
                                    sectionInfos.push(latlng);
                                }
                                drawLine(sectionInfos, trafficArr);
                            } else {
                                var markerPosition = new Tmapv2.LatLng(geometry.coordinates[1], geometry.coordinates[0]);
                                if (properties.pointType == "S") { //출발지 마커
                                	markerStart_car = new Tmapv2.Marker({
                                        position : markerPosition,
                                        iconHTML: `
                                        <div class='_t_marker' style="position:relative;" >
                                            <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                            출발</div>
                                        </div>
                                        `,
                                        offset: new Tmapv2.Point(24, 38),
                                        iconSize : new Tmapv2.Size(24, 38),
                                        map : map_car
                                    });
                                } else if (properties.pointType == "E") { //도착지 마커
                                	markerEnd_car = new Tmapv2.Marker({
                                        position : markerPosition,
                                        iconHTML: `
                                        <div class='_t_marker' style="position:relative;" >
                                            <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                                            <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                                            도착</div>
                                        </div>
                                        `,
                                        offset: new Tmapv2.Point(24, 38),
                                        iconSize : new Tmapv2.Size(24, 38),
                                        map : map_car
                                    });
                                } else { //각 포인트 마커
                                    var marker_p = new Tmapv2.Marker({
                                        position : markerPosition,
                                        icon : "http://topopen.tmap.co.kr/imgs/point.png",
                                        iconSize : new Tmapv2.Size(8, 8),
                                        zIndex:1,
                                        map : map_car
                                    });
                            
                                    markerPoint.push(marker_p);
                                }
                            }
                        }//for문 [E]
                        map_car.panToBounds(positionBounds);
                        map_car.zoomOut();
                        resolve(mode);
                    } else {
                        resolve(mode);
                    }
                },
                onProgress: function() {},
                onError: function() {}
            };
            tData.getRoutePlanJson(s_latlng, e_latlng, optionObj, params);
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
            map : map_car
        });

        markerArr.push(marker_p);
    }
    //라인그리기
    function drawLine(arrPoint, traffic) {
        var polyline_;

            // 교통정보 혼잡도를 체크
            // strokeColor는 교통 정보상황에 다라서 변화
            // traffic :  0-정보없음, 1-원활, 2-서행, 3-지체, 4-정체  (black, green, yellow, orange, red)

            var lineColor = "";

            if (traffic != "0") {
                if (traffic.length == 0) { //length가 0인것은 교통정보가 없으므로 검은색으로 표시

                    lineColor = "#06050D";
                    //라인그리기[S]
                    polyline_ = new Tmapv2.Polyline({
                        path : arrPoint,
                        strokeColor : lineColor,
                        strokeWeight : 6,
                        map : map_car
                    });
                    lineArr.push(polyline_);
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
                        polyline_ = new Tmapv2.Polyline({
                            path : noInfomationPoint,
                            strokeColor : "#06050D",
                            strokeWeight : 6,
                            map : map_car
                        });
                        //라인그리기[E]
                        lineArr.push(polyline_);

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
                            polyline_ = new Tmapv2.Polyline({
                                path : sectionPoint,
                                strokeColor : lineColor,
                                strokeWeight : 6,
                                map : map_car
                            });
                            //라인그리기[E]
                            lineArr.push(polyline_);
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
                            polyline_ = new Tmapv2.Polyline({
                                path : sectionPoint,
                                strokeColor : lineColor,
                                strokeWeight : 6,
                                map : map_car
                            });
                            //라인그리기[E]
                            lineArr.push(polyline_);
                        }
                    }
                }
            } 
    }
    // 경유지 추가 컨트롤 함수
    function onMultiButton(btn) {
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
            if(markerWp.length > 0){
                for(var i in markerWp){
                    if(markerWp[i]) {
                        markerWp[i].setMap(null);
                    }
                }
                markerWp = [];
            }
            $(".waypoint_input").each(function(idx) {
                // 차례번호 재생성

                $(this).attr('data-idx', idx);
                var pos = $(this).find("input[name='multipos']").val();
                if(pos == "") {
                    return true;
                }
                var viaX = pos.split(',')[0];
                var viaY = pos.split(',')[1];
                markerWp[idx] = new Tmapv2.Marker({
                    position : new Tmapv2.LatLng(viaY, viaX),
                    icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx + ".png",
                    iconSize : new Tmapv2.Size(24, 38),
                    map:map_car
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
        $("#wpList_car").append(`
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button class="wp_add" onclick="onMultiButton(this);"></button>
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
    function clickSearchPois_car(buttonObj) {
        const $input = $(buttonObj).prev('input');
        if($(buttonObj).hasClass('_search_address_btn')) {
            $("#searchAddress_car").val($input.val());
            searchPois();
        } else if($(buttonObj).parent('div').hasClass('waypoint_input')) {
            // 경유지 제거
            const $_deleteObj = $(buttonObj).parent('div.waypoint_input');
            clearWaypoint($_deleteObj[0]);
        } else {
            const type = $input.attr('id') || '';
            if(type == "searchStartAddress_car") {
                $("#startx_car").val('');
                $("#starty_car").val('');
                if(markerStart_car) {
                	markerStart_car.setMap(null);
                }
        
            } else if(type == "searchEndAddress_car") {
                $("#endx_car").val('');
                $("#endy_car").val('');
                if(markerEnd_car) {
                	markerEnd_car.setMap(null);
                }
            }
            $input.val('');
            $("#searchAddress_car").val('');
            $(buttonObj).removeClass('_delete_address_btn');
            $(buttonObj).addClass('_search_address_btn');
            $("._btn_action").addClass('__color_grey');
/*                 if(($("#searchStartAddress_car").val() == "") || ($("#searchEndAddress_car").val() == "")) {
                console.log("remove1");
                $("._btn_action").addClass('__color_grey');
            } else {
                console.log("remove2");
                $("._btn_action").removeClass('__color_grey');
            }
 */            }
    }
    
    //(경로API공통) 엔터키 통합검색 함수
    function onKeyupSearchPoi(inputText) {
        /*
        if(($("#searchStartAddress_car").val() == "") || ($("#searchEndAddress_car").val() == "")) {
            $("._btn_action").addClass('__color_grey');
        } else {
            $("._btn_action").removeClass('__color_grey');
        }
        */
        $("._btn_action").addClass('__color_grey');
        if($(inputText).next('button').hasClass('_delete_address_btn')) {
            $(inputText).val('');
        }
        $(inputText).next('button').removeClass('_delete_address_btn');
        $(inputText).next('button').addClass('_search_address_btn');
        if (window.event.keyCode == 13) {
            // 엔터키가 눌렸을 때 실행하는 반응
            var isWaypoint = $(inputText).parent('div.waypoint_input').length == 1;
            if(isWaypoint) {
                // 경유지입력시 엔터키대상 li에대해 class추가
                $(".waypoint_input").each(function() {
                    $(this).removeClass('texton');
                });
                $(inputText).parent('div.waypoint_input').addClass('texton');
            }
            $("#searchAddress_car").val($(inputText).val());
            searchPois();
        }
    }
    
    // (경로API공통) 지도위의 경로 안내 효과 다시그림
    function routesRedrawMap(mode, carmode) {
        
        if (mode == "apiRoutesPedestrian") {
            drawMode = mode;
            routesPedestrian();
        } else if (mode == "apiRoutesCar" || mode == "apiRoutesMulti") {
            drawMode = mode+"_"+carmode;
            routesCar(carmode);
        }
        $("#apiResult_car").find('._route_item_type').removeClass('__color_blue');
        $("#apiResult_car").find('#'+drawMode).find('._route_item_type').addClass('__color_blue');
    }
    // (경로API공통) 출발지와 도착지의 좌표를 설정한다.
    function enterDest(type, address, x, y) {
        marker1.setMap(null);
        // 기존 라인 지우기
        if(lineArr.length > 0){
            for(var i in lineArr) {
                lineArr[i].setMap(null);
            }
            //지운뒤 배열 초기화
            lineArr = [];
        }
        // 경로찾기 point 마커 지우기
        if(markerPoint.length > 0){
            for(var i in markerPoint){
                markerPoint[i].setMap(null);
            }
            markerPoint = [];
        }
        if(type == 'start') {
            if(markerStart_car) {
            	markerStart_car.setMap(null);
            }
            $("#startx_car").val(x);
            $("#starty_car").val(y);
            $("#searchStartAddress_car").val(address);
            $("#searchStartAddress_car").next('button').removeClass('_search_address_btn');
            $("#searchStartAddress_car").next('button').addClass('_delete_address_btn');
            
            markerStart_car = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y, x),
                icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    출발</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_car
            });
        } else if(type == 'end') {
            if(markerEnd_car) {
            	markerEnd_car.setMap(null);
            }
            $("#endx_car").val(x);
            $("#endy_car").val(y);
            $("#searchEndAddress_car").val(address);
            $("#searchEndAddress_car").next('button').removeClass('_search_address_btn');
            $("#searchEndAddress_car").next('button').addClass('_delete_address_btn');
            
            markerEnd_car = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(y, x),
                icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="/lib/img/_icon/marker_red.svg" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    도착</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map : map_car
            });
        } else if(type == 'wp') {
            const currentSize = $(".waypoint_input").length;
            const prependHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _wp_not_empty _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos" value="\${x},\${y}">
                <input type="text" value="\${address}" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_car(this);" class="_delete_address_btn" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
            const emptyHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_car(this);" class="_search_address_btn" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
            if(currentSize < 5) {
                const $_deleteObj = $("#wpList_car .waypoint_input:last");
                $_deleteObj.prev('.__space_10_h').remove();
                $_deleteObj.remove();
                $("#wpList_car").append(prependHtml);
                $("#wpList_car").append(emptyHtml);
            } else {
                const $_deleteObj = $("#wpList_car .waypoint_input:last");
                $_deleteObj.prev('.__space_10_h').remove();
                $_deleteObj.remove();
                $("#wpList_car").append(prependHtml);
            }
            redrawRouteMarker();
        }
        /* 검색버튼 활성화/비활성화 체크  */
        var startx_car = $("#startx_car").val();
        var starty_car = $("#starty_car").val();
        var endx_car = $("#endx_car").val();
        var endy_car = $("#endy_car").val();
        if(startx_car == "" || starty_car == "" || endx_car == "" || endy_car == "") {
            $("._btn_action").addClass('__color_grey');
        } else {
            $("._btn_action").removeClass('__color_grey');
        }
        
        // reset();
    }
    function clearWaypoint(destObj) {
        const currentSize = $(".waypoint_input._wp_not_empty").length;
        console.log("clearWaypoint: ", currentSize);
        const emptyHtml = `
            <div class="__space_10_h"></div>
            <div class="waypoint_input _map_overlay_row" data-idx="0">
                <input type="hidden" name="multipos" />
                <input type="text" class="_search_entry _search_entry_short" onkeyup="onKeyupSearchPoi(this);" placeholder="경유지를 입력하세요." style="padding-right: 45px;">
                <button onclick="clickSearchPois_car(this);" class="_search_address_btn" style="margin-top: 14px; margin-bottom: 14px; pointer-events: all; cursor: pointer;"></button>
                <div style="width: 90px;"></div>
            </div>
            `;
        const $_deleteObj = $(destObj);
        $_deleteObj.prev('.__space_10_h').remove();
        $_deleteObj.remove();
        if(currentSize == 5) {
        $("#wpList_car").append(emptyHtml);
        }
        redrawRouteMarker();
    }
    /* 경로검색시 경유지 마커 다시 그림 */
    function redrawRouteMarker() {
        if(markerWp.length > 0){
            for(var i in markerWp) {
                markerWp[i].setMap(null);
            }
            //지운뒤 배열 초기화
            markerWp = [];
        }
        $(".waypoint_input").each(function(idx) {
            // 차례번호 재생성
            $(this).attr('data-idx', idx);
            var pos = $(this).find("input[name='multipos']").val();
            if(pos == "") {
                return true;
            }
            var viaX = pos.split(',')[0];
            var viaY = pos.split(',')[1];
            markerWp[idx] = new Tmapv2.Marker({
                position : new Tmapv2.LatLng(viaY, viaX),
                icon : "http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_" + idx + ".png",
                iconHTML: `
                <div class='_t_marker' style="position:relative;" >
                    <img src="http://tmapapi.sktelecom.com/upload/tmap/marker/pin_b_m_p.png" style="width:48px;height:48px;position:absolute;"/>
                    <div style="position:absolute; width:48px;height:42px; display:flex; align-items:center; justify-content: center; color:#FAFBFF; font-family: 'SUIT';font-style: normal;font-weight: 700;font-size: 15px;line-height: 19px;">
                    \${idx+1}</div>
                </div>
                `,
                offset: new Tmapv2.Point(24, 38),
                iconSize : new Tmapv2.Size(24, 38),
                map:map_car
            });
        });
    }
    // (경로API공통) API 결과값 기록
    function writeApiResultHtml(type, string) {
        if($("#apiResult_car div#results").length == 0) {
            $("#apiResult_car").empty();
            $("#apiResult_car").html(`
                <div class="_result_panel_bg">
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
            if($("#apiResult_car #apiRoutesCar").find("#"+type).length == 0 ) {
                $("#apiResult_car #apiRoutesCar").append(`<div id="\${type}">\${string}</div>`);
            }
        } else if(type.startsWith("apiRouteSequential_") || type.startsWith("routesOptimization")) {
            if($("#apiResult_car #apiRoutesMulti").find("#"+type).length == 0 ) {
                $("#apiResult_car #apiRoutesMulti").append(`<div id="\${type}">\${string}</div>`);
            }
        } else {
            $("#apiResult_car").find("#"+type).html(string);
        }
    }   
    // (API 공통) 맵에 그려져있는 라인, 마커, 팝업을 지우는 함수
    function reset() {
        // 기존 라인 지우기
        if(lineArr.length > 0){
            for(var i in lineArr) {
                lineArr[i].setMap(null);
            }
            //지운뒤 배열 초기화
            lineArr = [];
        }
    
        // 기존 마커 지우기
        if(markerStart_car) {
        	markerStart_car.setMap(null);
        }
        if(markerEnd_car) {
        	markerEnd_car.setMap(null);
        }
        if(markerArr.length > 0){
            for(var i in markerArr){
                markerArr[i].setMap(null);
            }
            markerArr = [];
        }
        // poi 마커 지우기
        if(markerPoi.length > 0){
            for(var i in markerPoi){
                markerPoi[i].setMap(null);
            }
            markerPoi = [];
        }
        // 경로찾기 point 마커 지우기
        if(markerPoint.length > 0){
            for(var i in markerPoint){
                markerPoint[i].setMap(null);
            }
            markerPoint = [];
        }
        
        // 기존 팝업 지우기
        if(labelArr.length > 0){
            for(var i in labelArr){
                labelArr[i].setMap(null);
            }
            labelArr = [];
        }
    }
    
    
    // 메모에 장소명 추가
    $(document).on('click', ".place_add_car", function () {
    	$('#memo_place').val($("._result_text_line_memo_print_car").text());
    	$('#memo_place_lat').val($("#_result_text_line_memo_lat_car").text());
    	$('#memo_place_lng').val($("#_result_text_line_memo_lng_car").text());
    });
    
    
    // 버튼 클릭 시 reset_ped 함수 호출
    // reset 버튼 클릭 이벤트 핸들러
    $("#resetButton").on("click", function () {
   	 function resetMap() {
     	for (var i in markerList) {
            markerList[i].setMap(null);
        }
        markerList = [];

        for (var i in new_polyLine) {
            new_polyLine[i].setMap(null);
        }
        new_polyLine = [];
        
        $('#car_result').empty();
   	    }

   	    resetMap();
   	    
   	 	reset();
    });


    //=================================================
	// 일정 날짜를 클릭하게 되면 DB 데이터를 불러와 다중 경유지를 보여주게 된다.
	var markerList = [];
	var new_polyLine = [];
	$(document).on('click', "[id^=date]", function () {
        $.ajax({
            url: '/latlng_print',
            type: 'post',
            data: {
            	sche_id: $('#location_uuid').val(),
            	event_datetime: $(this).text()
            },
            success: function (response) {
         
         var new_Click_polyLine = [];

         function drawData(data) {
        	    // 지도위에 선은 다 지우기
        	    /* routeData = data; */
        	    var resultStr = "";
        	    var distance = 0;
        	    var idx = 1;
        	    var newData = [];
        	    var equalData = [];
        	    var pointId1 = "-1234567";
        	    var ar_line = [];

        	    for (var i = 0; i < data.features.length; i++) {
        	        var feature = data.features[i];
        	        // 배열에 경로 좌표 저장
        	        if (feature.geometry.type == "LineString") {
        	            ar_line = [];
        	            for (var j = 0; j < feature.geometry.coordinates.length; j++) {
        	                var startPt = new Tmapv2.LatLng(feature.geometry.coordinates[j][1], feature.geometry.coordinates[j][0]);
        	                ar_line.push(startPt);
        	                pointArray.push(feature.geometry.coordinates[j]);
        	            }
        	            var polyline = new Tmapv2.Polyline({
        	                path: ar_line,
        	                strokeColor: "#ff0000",
        	                strokeWeight: 6, // 폴리라인 두께 설정
        	                map: map_car
        	            });
        	            new_polyLine.push(polyline);
        	        }
        	        var pointId2 = feature.properties.viaPointId;
        	        if (pointId1 != pointId2) {
        	            equalData = [];
        	            equalData.push(feature);
        	            newData.push(equalData);
        	            pointId1 = pointId2;
        	        } else {
        	            equalData.push(feature);
        	        }
        	    }
        	    geoData = newData;
        	    var markerCnt = 1;
        	    for (var i = 0; i < newData.length; i++) {
        	        var mData = newData[i];
        	        var type = mData[0].geometry.type;
        	        var pointType = mData[0].properties.pointType;
        	        var pointTypeCheck = false; // 경유지 일때만 true
        	        if (mData[0].properties.pointType == "S") {
        	            var img = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_s.png';
        	            var lon = mData[0].geometry.coordinates[0];
        	            var lat = mData[0].geometry.coordinates[1];
        	        } else if (mData[0].properties.pointType == "E") {
        	            var img = 'http://tmapapi.sktelecom.com/upload/tmap/marker/pin_r_m_e.png';
        	            var lon = mData[0].geometry.coordinates[0];
        	            var lat = mData[0].geometry.coordinates[1];
        	        } else {
        	            markerCnt = i;
        	            var lon = mData[0].geometry.coordinates[0];
        	            var lat = mData[0].geometry.coordinates[1];
        	        }
        	    }
        	}
         // 2. 시작, 도착 심볼찍기
         var pointArray = [];
         
         console.log(response[0]);
         var lastIndex_lng = response.length - 2;
         var lastIndex_lat = response.length - 1;
         var lastIndex_ = response.length - 3;
         
         	// 시작
         	addMarker("llStart",response[0],response[1],1);
         	// 도착 
         	addMarker("llEnd",response[lastIndex_lng],response[lastIndex_lat],2);
         	
         	function addMarker(status, lon, lat, tag) {
         	//출도착경유구분
         	//이미지 파일 변경.
         	var markerLayer;
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
         	};
         	var marker = new Tmapv2.Marker({
         		position: new Tmapv2.LatLng(lat,lon),
         		icon: imgURL,
         		map: map_car
         	});
         	// 마커 드래그 설정
         	marker.tag = tag;
         	marker.addListener("dragend", function (evt) {
         	markerListenerEvent(evt);
             });
             marker.addListener("drag", function (evt) {    	
             	markerObject = markerList[tag];
             });
             markerList[tag] = marker;
         	return marker;
         }

         	var passList = ""; // 경유지 생성 변수

            // 처음 두 개와 마지막 두 개를 제외한 값들만 추출
            if (response.length > 4) {
                // 패턴 생성
                for (var i = 2; i < response.length - 2; i += 2) {
                	addMarker("llPass",response[i],response[i+1],i+1);
                    passList += response[i] + "," + response[i + 1] + "_";
                }

                // 마지막에 추가된 밑줄 제거
                passList = passList.substring(0, passList.length - 1);
            }
         	
         // 4. 경로탐색 API 사용요청
         	var startX = response[0];
         	var startY = response[1];
         	var endX = response[lastIndex_lng];
         	var endY = response[lastIndex_lat];
         	var prtcl;
         	var headers = {};
         	headers["appKey"]="5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7";
         	$.ajax({
         			method:"POST", 
         			headers : headers, 
         			url:"https://apis.openapi.sk.com/tmap/routes?version=1&format=json",
         			async:false,
         			data:{ 
         				startX : startX,
         				startY : startY,
         				endX : endX,
         				endY : endY,
         				passList : passList,
         				reqCoordType : "WGS84GEO",
         				resCoordType : "WGS84GEO",
         				angle : "172",
         				searchOption : "0",
         				trafficInfo : "Y"
         			},
         			success:function(response){
         				var resultData = response.features;

         			    var tDistance = "총 거리 : " + (resultData[0].properties.totalDistance / 1000).toFixed(1) + "km,";
         			    var tTime = " 총 시간 : " + (resultData[0].properties.totalTime / 60).toFixed(0) + "분,";
         			    var tFare = " 총 요금 : " + resultData[0].properties.totalFare + "원,";
         			    var taxiFare = " 예상 택시 요금 : " + resultData[0].properties.taxiFare + "원";

         			    console.log("tDistance:", tDistance);
         			    console.log("tTime:", tTime);
         			    console.log("tFare:", tFare);
         			    console.log("taxiFare:", taxiFare);

         			    $("#car_result").html(tDistance + tTime + tFare + taxiFare);
         			    
         			   var appendHtml = `
                           <div class="_route_item">
                             
                               <div class="_route_item_info">
                                   \${(resultData[0].properties.totalTime / 60).toFixed(0)}분 
                                   | \${(resultData[0].properties.totalDistance / 1000).toFixed(1)}km 
                                   | \${resultData[0].properties.totalFare}원 
                                   | 택시 \${resultData[0].properties.taxiFare}원</div>
                           </div>
                       `;
                       writeApiResultHtml("apiRoutesCar_0", appendHtml);
						
         			prtcl = response;
         			
         			// 5. 경로탐색 결과 Line 그리기 
         			var trafficColors = {
         				extractStyles:true,
         				/* 실제 교통정보가 표출되면 아래와 같은 Color로 Line이 생성됩니다. */
         				trafficDefaultColor:"#636f63", //Default
         				trafficType1Color:"#19b95f", //원할
         				trafficType2Color:"#f15426", //지체
         				trafficType3Color:"#ff970e"  //정체		
         			};    			
         			var style_red = {
         				fillColor:"#FF0000",
         				fillOpacity:0.2,
         				strokeColor: "#FF0000",
         				strokeWidth: 3,
         				strokeDashstyle: "solid",
         				pointRadius: 2,
         				title: "this is a red line"
         			};
         			drawData(prtcl);
         		// 6. 경로탐색 결과 반경만큼 지도 레벨 조정
        			var newData = geoData[0];
        			PTbounds = new Tmapv2.LatLngBounds();
        					for (var i = 0; i < newData.length; i++) {
        						var mData = newData[i];
        						var type = mData.geometry.type;
        						var pointType = mData.properties.pointType;
        						if(type == "Point"){
        							var linePt = new Tmapv2.LatLng(mData.geometry.coordinates[1],mData.geometry.coordinates[0]);
        							PTbounds.extend(linePt);
        						}
        						else{
        							var startPt,endPt;
        							for (var j = 0; j < mData.geometry.coordinates.length; j++) {
        								var linePt = new Tmapv2.LatLng(mData.geometry.coordinates[j][1],mData.geometry.coordinates[j][0]);
        								PTbounds.extend(linePt);
        							}
        					}
        				}

        				// 지도 레벨 조정
        				map_car.fitBounds(PTbounds);
         		
         			},
         			error:function(request,status,error){
         			console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
         		}
         	});
},
error: function (xhr, status, error) {
 console.error("POST 요청 오류: " + error);
}
});
});

</script>


</body>
</html>
