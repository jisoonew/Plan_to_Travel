document.getElementById('map_div_car').style.display = 'none';
document.getElementById('map_div_ped').style.display = 'none';

var date1 = document.getElementsByClassName('date1');
var travel_memo_array = [];
var cardInfoArray = [];
var cardId;
var itemList = [];
var clickedCardIndex, clickedCardIndex2;
var formattedDate;
var items;
var table_array = [];
var table_date_array = [];
var card_uuid;
var fullId, remove_id;
var cancle_event_arr = [];
var dynamicVariables = []; // 일정 변수 생성'
var numberOfSchedules // 날짜 총 일 수



// 마이페이지 오프캔버스
// 이벤트 리스너 추가
$(document).ready(function () {
	$('#myOffcanvas').on('shown.bs.offcanvas', function () {
		// 다른 오프캔버스가 나타날 때 실행할 작업을 여기에 작성합니다.
		console.log('Offcanvas is shown.');
	});

	$('#Favorites').click(function () {
		$('#Offcanvas_Favorites').offcanvas('show');
	});

	//히스토리 클릭
	$('#History').click(function () {

		console.log("History 버튼 클릭!");

		// 이 부분에서 "/getHistory" 엔드 포인트로 GET 요청을 보내도록 설정
		$.ajax({
			type: 'GET',
			url: '/getHistory',
			dataType: 'json',
			success: function (data) {
				console.log(JSON.stringify(data) + ' 데이터');

				// 'data' 값을 사용하여 텍스트를 추가
				//$('#Offcanvas_History .offcanvas-body ul').html('<li>' + data + '</li>');

				// 'data' 값을 사용하여 텍스트를 엘리먼트에 추가
				var ulElement = $('#Offcanvas_History .offcanvas-body ul');
				ulElement.empty(); // 기존 내용 삭제

				// 'data'의 결과를 반복하여 목록으로 표시
				data.forEach(function (result) {
					var liElement = '<li class="nav-item">';
					liElement += '<button class="nav-link active HistorySChe" type="button" aria-current="page" id="History" value="' + result.sche_id + '">' + result.sche_title + '</button>';
					liElement += '<button type="button" id="History_delete"><i class="bi bi-x"></i></button>';
					liElement += '</li>';
					ulElement.append(liElement);
				});

				$('#Offcanvas_History').offcanvas('show');
			},
			error: function () {
				//요청이 실패하면 실행되는 코드
				console.error('요청 실패');
			}
		});
		console.log("History 클릭 js 함수 완료");
	});

	$('#Journal').click(function () {
		$('#Offcanvas_Journal').offcanvas('show');
	});

});

//히스토리 목록에 있는 스케줄 클릭 ->  해당 스케줄 가져오기
// 이벤트 위임을 사용하여 동적으로 생성된 버튼에 대한 클릭 이벤트 처리
$(document).on('click', '.HistorySChe', function () {

    var buttonValue = $(this).val(); // 클릭한 버튼의 value를 가져옴
    console.log('버튼 클릭: ' + buttonValue);

    // 클릭한 버튼의 텍스트를 사용하여 GET 요청을 보냅니다.
    $.ajax({
        type: 'GET',
        url: '/historySche', // 서버의 엔드포인트 URL
        data: {
            buttonValue: buttonValue
        }, // 필요한 데이터를 전달할 수 있습니다.
        dataType: 'json', // 서버에서 받을 데이터의 형식을 명시합니다.
        success: function (data) {
            // 서버에서 받은 응답에 대한 처리를 여기에 추가
            console.log(JSON.stringify(data) + ' 데이터');
            // 예를 들어, 스케줄을 화면에 표시하거나 다른 작업을 수행할 수 있습니다.

            // travel_table 요소 초기화
            $('#travel_table').empty();

            // 날짜 컨테이너 초기화
            $('#dateRangeOutput').empty();

            // 객체를 사용하여 날짜별로 일정 그룹화
            var scheduleGroups = {};

            // 받은 데이터를 기반으로 일정 표 생성
            var tableBoxIndex = 1; // 초기값 설정

            for (var i = 0; i < data.length; i++) {
                var date = data[i].event_datetime.split(' ')[0];
                var eventTitle = data[i].event_title;

                // 만약 해당 날짜의 그룹이 없다면 새로운 그룹을 생성
                if (!scheduleGroups[date]) {
                    scheduleGroups[date] = [];
                }

                // 날짜별로 일정 그룹에 추가
                scheduleGroups[date].push(eventTitle);
            }

            // 날짜 컨테이너와 일정을 travel_table에 추가
            for (var date in scheduleGroups) {
                // 날짜 컨테이너에 날짜 추가
                $('#dateRangeOutput').append('<div class="date" style="width:150px;">' + date + '</div>');

                // 해당 날짜의 일정 그룹을 travel_table에 추가
                var scheduleHtml = '<div class="column table-box' + tableBoxIndex + '" name="table-box' + tableBoxIndex + '">';
                for (var j = 0; j < scheduleGroups[date].length; j++) {
                    var eventTitle = scheduleGroups[date][j];

                    scheduleHtml += '<div class="card text-white bg-info card_package" id="box_title_' + (j + 1) + '_' + (i + 1) + '">';
                    scheduleHtml += '<div class="card-title">';
                    scheduleHtml += '<div class="title" id="title' + (j + 1) + '_' + (i + 1) + '" tabindex="-1">' + eventTitle + '</div>';
                    scheduleHtml += '<div class="deleteBox">x</div>';
                    scheduleHtml += '</div>';
                    scheduleHtml += '</div>';
                }
                scheduleHtml += '<label class="createBox' + tableBoxIndex + '">[추가]</label></div>';

                // 해당 날짜의 일정을 travel_table에 추가
                $('#travel_table').append(scheduleHtml);

                tableBoxIndex++;

                // 닫혔는지 확인하고, 닫혀 있다면 다시 닫지 않도록 체크
                if ($('#Offcanvas_History').hasClass('show')) {
                    $('#Offcanvas_History').offcanvas('hide');
                }

                // 닫혔는지 확인하고, 닫혀 있다면 다시 닫지 않도록 체크
                if ($('#offcanvasNavbar').hasClass('show')) {
                    $('#offcanvasNavbar').offcanvas('hide');
                }
            }
        },
        error: function () {
            // 요청이 실패하면 실행되는 코드
            console.error('GET 요청 실패');
        }
    });
});

//히스토리 -스케줄 추가하기
$('#new_schedule').click(function () {

    // travel_table 요소 초기화
    $('#travel_table').empty();

    // 날짜 컨테이너 초기화
    $('#dateRangeOutput').empty();

    // 닫혔는지 확인하고, 닫혀 있다면 다시 닫지 않도록 체크
    if ($('#Offcanvas_History').hasClass('show')) {
        $('#Offcanvas_History').offcanvas('hide');
    }

    // 닫혔는지 확인하고, 닫혀 있다면 다시 닫지 않도록 체크
    if ($('#offcanvasNavbar').hasClass('show')) {
        $('#offcanvasNavbar').offcanvas('hide');
    }
});

// 히스토리 삭제 버튼 클릭
$(document).on('click', '#History_delete', function () {

    console.log("History 삭제 버튼 클릭!");

    // 모달을 띄우기
    $('#deleteConfirmationModal').modal('show');

    // 클릭한 삭제 버튼이 속한 li 요소에서 HistorySChe 버튼의 value 값을 가져옴
    var sche_id = $(this).siblings('.HistorySChe').val();
    console.log("sche_id : " + sche_id);


    // 확인 버튼 클릭 시 작업 수행
    $('#confirmDelete').click(function () {
        // 모달을 닫기
        $('#deleteConfirmationModal').modal('hide');

        // 이 부분에서 "/hisDelete" 엔드 포인트로 GET 요청을 보내도록 설정
        $.ajax({
            type: 'GET',
            url: '/hisDelete',
            data: {
                sche_id: sche_id
            },
            success: function (data) {
                console.log(data);
                // 삭제 성공 메시지 등을 처리
                // 성공 모달 띄우기
                $('#deleteSuccessModal').modal('show');

            },
            error: function () {
                // 요청이 실패하면 실행되는 코드
                console.error('요청 실패');
            }
        });
        console.log("History 삭제 버튼 클릭 js 함수 완료");
    });
});

// 삭제 성공 모달 닫힐 때 페이지 새로고침
$('#deleteSuccessModal').on('hidden.bs.modal', function () {
    location.reload();
});

// 메모장 날짜 선택

$.datepicker.setDefaults({
	dateFormat: 'yy-mm-dd',
	prevText: '이전 달',
	nextText: '다음 달',
	monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	showMonthAfterYear: true,
	yearSuffix: '년'
});

$(function () {
	$('.datepicker').datepicker();
});


// 일정 날짜 범위 선택
$(document).ready(function () {
	$("#datepicker_start,#datepicker_end").datepicker({
		changeMonth: true,
		changeYear: true,
		showMonthAfterYear: true,
		dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'],
		dateFormat: 'yy-mm-dd',
	});

	$('#datepicker_start').datepicker("option", "maxDate", $("#datepicker_end").val());
	$('#datepicker_start').datepicker("option", "onClose", function (selectedDate) {
		$("#datepicker_end").datepicker("option", "minDate", selectedDate);
	});

	$('#datepicker_end').datepicker();
	$('#datepicker_end').datepicker("option", "minDate", $("#datepicker_start").val());
	$('#datepicker_end').datepicker("option", "onClose", function (selectedDate) {
		$("#datepicker_start").datepicker("option", "maxDate", selectedDate);
	});


});


// 계획표 스크립트
$(document).on('click', ".title", function (event) {
	$("[class*=table-box]").sortable({
		// 드래그 앤 드롭 단위 css 선택자
		connectWith: ".column",
		// 움직이는 css 선택자
		handle: ".title",
		// 움직이지 못하는 css 선택자
		cancel: ".no-move",
		// 이동하려는 location에 추가 되는 클래스
		placeholder: "card-placeholder",
		stop: function (event, ui) {
			saveSortableOrder();
		},
		update: function (event, ui) {
			saveSortableOrder();
		},
		start: function (event, ui) {
			// 드래그 시작 시 포커스 유지
			ui.item.focus();

		}
	});
	// 해당 클래스 하위의 텍스트 드래그를 막는다.
	$(".column .card").disableSelection();
});



// 일정표를 이동하면 배열에 저장됨
function saveSortableOrder() {

	itemList = [];

	// 일정의 아이디와 텍스트를 배열 저장
	// 일정의 아이디는 메모장 배열과 연관이 있기때문이다.
	items.each(function () {
		itemList.push($(this).text()); // 제목
	});

	console.log("일정 : " + itemList);
}


//UUID 범용고유식별자 생성
function uuidv4() {
	return ([1e7] + -1e3 + -4e3 + -8e3 + -1e11).replace(/[018]/g, c =>
		(c ^ crypto.getRandomValues(new Uint8Array(1))[0] & 15 >> c / 4).toString(16)
	);
}

var generatedUuid;

// '날짜 범위 출력' 버튼 클릭 이벤트
$('#btnShowDates').on('click', function () {
	// 날짜 생성 버튼을 누르면 uuid 재발급

	var startDate = $('#datepicker_start').datepicker('getDate');
	var endDate = $('#datepicker_end').datepicker('getDate');

	// 최대 7일 뒤의 날짜를 계산
	var maxDate = new Date(startDate.getTime() + 24 * 60 * 60 * 1000);

	if (startDate && endDate && startDate <= endDate) {
		var currentDate = new Date(startDate);
		var dateRangeOutput = "";
		var a = parseInt(1);
		var travel_table = "";

		while (currentDate <= endDate) {
			formattedDate = $.datepicker.formatDate('yy-mm-dd', currentDate);
			dateRangeOutput += "<div class='date' id='date" + a + "' style='width:150px;'>" + formattedDate + "</div>";
			table_date_array.push(formattedDate);
			currentDate.setDate(currentDate.getDate() + 1);
			
			var timeDifference = endDate.getTime() - startDate.getTime();

			var daysDifference = Math.floor(timeDifference / (1000 * 60 * 60 * 24));
			
			// 일정 날짜 일 수
			var numberOfSchedules = daysDifference + 1;

			// 추가 버튼 함수 실행
	        $(document).on('click', `.createBox${a}`, handleCreateBoxClick(a - 1));
	        
	        $(document).on('click', `.table-box${a} [id^=title]`, function () {
	            handleScheduleClick(a, a-1, this);
	        });


			// 날짜 생성에 따라 배열 변수 생성
			for (var i = 0; i < daysDifference + 1; i++) {
			    var variableName = 'box_title_index' + i;
			    dynamicVariables[variableName] = 2;
			}
			
			var box_title

			generatedUuid = uuidv4();

			travel_table +=
				`<div class="column table-box` + a + `" name="table-box` + a + `">
            <div class="card text-white card_package` + a + `" id="box_title_` + a + `_1" style="background-color: #96B6C5">
              <div class="card-title` + a + ` uuid" id=${generatedUuid}>
                <div class="title" id="title` + a + `_1" style="font-size: 12px; align-items: center;">title</div>
                <div class="deleteBox">x</div>
              </div>
            </div>
            
            <label class="createBox` + a + `">[추가]</label>
          </div>`

			table_array.push("table-box" + a);

			a += 1;
		}

		$("#dateRangeOutput").html(dateRangeOutput);
		$("#travel_table").html(travel_table);

	} else {
		$("#dateRangeOutput").html("올바른 날짜 범위를 선택해주세요.");
		$("#travel_table").html("");
	}

});


//삭제 라벨
$(document).on('click', ".deleteBox", function () {
	$(this).parent().parent().remove();
	var cancle_event_id = $(this).parent().attr('id');
	cancle_event_arr.push(cancle_event_id); // 삭제하는 일정의 아이디 배열
});

var box_title_index = 2;
var box_title_index2 = 2;
var box_title_index3 = 2;
var box_title_index4 = 2;
var box_title_index5 = 2;
var box_title_index6 = 2;
var box_title_index7 = 2;

function handleCreateBoxClick(boxIndex) {
    return function () {
        generatedUuid = uuidv4();
            innerHtml = `
                <div class="card text-white bg-info card_package" id="box_title_${boxIndex + 1}_${box_title_index}">
                    <div class="card-title uuid" id=${generatedUuid}>
                        <div class="title" id="title${boxIndex + 1}_${box_title_index}" tabindex="-1">title</div>
                        <div class="deleteBox">x</div>
                    </div>
                </div>`;
            $(`.table-box${boxIndex + 1}`).append(innerHtml);
            box_title_index += 1;
    };
}


//일정에 하나씩 saveSortableOrder()를 넣은 이유는 클릭한 div에 있는 데이터들만 저장하기 위함임

function event_print() {
	// DB에 정상적으로 삽입되었다면, DB에 location_UUID와 location_ID를 확인된다면 출력!
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
	        if (firstItem && firstItem.event_title) {
	            var location_TITLE = firstItem.event_title;
	            var location_TIME = firstItem.event_datetime;
	            var location_NAME = firstItem.event_place;
	            var location_LAT = firstItem.event_lat;
	            var location_LNG = firstItem.event_lng;
	            var location_MEMO = firstItem.event_memo;
	            var location_REVIEW = firstItem.event_review;

	            var dateTime = new Date(location_TIME);
	            console.log("dateTime" + dateTime);
	            var time = dateTime.toISOString().split('T')[1].split('.')[0];

	            $('#memo_text').val(location_TITLE);
	            $('#memo_place').val(location_NAME);
	            $('#memo_place_lat').val(location_LAT);
	            $('#memo_place_lng').val(location_LNG);
	            $('#memo_content').val(location_MEMO);
	            $('#review_content').val(location_REVIEW);
	        } else {
	            console.error('Unexpected response format:', firstItem);
	        }
	    },
	    error: function (xhr, status, error) {
	        console.error("POST 요청 오류:", xhr);
	        console.error("상태:", status);
	        console.error("에러:", error);
	    }
	});
	}

function handleScheduleClick(boxIndex, dateIndex, clickedElement) {
    $(".card-title" + boxIndex).focus();
    
    // 메모장의 제목 텍스트의 아이디 값에 클릭한 일정의 아이디 값 연결함.
    document.querySelector('#memo_text_id').setAttribute("value", $(clickedElement).attr('id'));

    items = $(".table-box" + boxIndex + " [id^=title]");

    saveSortableOrder();

    // 인덱스 출력
    $("#clickedCardIndex_text").val("clickedCardIndex" + boxIndex);

    // 메모장에 쓴 제목 일정표에 삽입
    $("#memo_text_id").text($("#memo_text").text());

    // 클릭한 테이블의 클래스 저장
    $("#table-box_text").val("table-box" + boxIndex);

    fullId = $('.table-box' + boxIndex + ' [id^=uuid]').attr('id');
    remove_id = fullId;

    card_uuid = $(clickedElement).parent().attr('id');
    
    date_num = $(clickedElement).parent().parent().parent().attr('class').replace(/\D/g, '');
    
    // 일정표를 클릭하면 메모장 날짜 텍스트 출력
    $('#datepicker').val($("#date" + date_num).text());

    // 일정 클릭시 일치하는 아이디 값들을 메모장에 출력함
    event_print();
}


// 메모에 장소명 추가
$(document).on('click', ".place_add", function () {
	$('#memo_place').val($("._result_text_line_memo_print").text());
	$('#memo_place_lat').val($("#_result_text_line_memo_lat").text());
	$('#memo_place_lng').val($("#_result_text_line_memo_lng").text());
});


// 새로고침하면 uuid 다시 생성
document.getElementById('location_uuid').value = uuidv4();

// 일정표 DB 저장
$(document).on('click', "#travel_save", function () {
	document.getElementById("modal").style.display = "block";
});

$(document).on('click', "#save_btn", function () {
	var location_uuid = document.getElementById("location_uuid").value;
	var memo_text = document.getElementById("memo_text").value;
	var memo_text_id = document.getElementById("memo_text_id").value;
	var datepicker = document.getElementById("datepicker").value;
	var memo_time = document.getElementById("memo_time").value;
	var memo_place = document.getElementById("memo_place").value;
	var memo_place_lat = document.getElementById("memo_place_lat").value; // 위도
	var memo_place_lng = document.getElementById("memo_place_lng").value; // 경도
	var memo_content = document.getElementById("memo_content").value;
	var review_content = document.getElementById("review_content").value;
	var clickedCardIndex_text = document.getElementById("clickedCardIndex_text").value;

	var memoTextId = $('#table-box_text').val();
	items = $("." + memoTextId + " [id^=title]");

	saveSortableOrder();

	var array_date = 0;

	// 일정 저장 내용 지정을 안함
	if (memo_text_id == '') {
		document.getElementById("non_save_modal").style.display = "block";
	} else {

		$.ajax({
			url: "/sche_Chk",
			type: "post",
			traditional: true,
			data: {
				"sche_id": $('#location_uuid').val()
			},
			success: function (response) {
				// schedule에 sche_id와 일치하는 데이터가 없다면 데이터 삽입
				if (response == false) {
					// schedule DB 저장 ajax
					$.ajax({
						url: "/sche_save",
						type: "post",
						traditional: true,
						data: {
							"sche_id": location_uuid,
							"sche_title": $("#travel_title").val()
						},
						success: function (response) {},
						dataType: "json"
					});


					// "Semi-colon expected"이라는 오류가 뜰 수 있음 프로젝트에 아무런 영향을 끼치지 않은 오류임 설정에서 해당 오류를 안보이게 할 수 있음
					async function processTableData(array_num, array_date) {
						const currentArrayDate = array_date;

						var table_List = [];
						var table_items = $("." + table_array[array_num] + " [id^=title]");

						var event_uuid = $("." + table_array[array_num] + " [class*=uuid]");
						var event_uuid_arr = [];

						// 날짜 별 제목 배열
						table_items.each(function () {
							table_List.push($(this).text());
						});

						// event_id 배열
						event_uuid.each(function () {
							var id = $(this).attr("id");
							event_uuid_arr.push(id);

						});

						try {
							// 비동기 ajax 호출
							await $.ajax({
								url: "/event_insert",
								type: "post",
								traditional: true,
								data: {
									"event_id": event_uuid_arr,
									"sche_id": location_uuid,
									"itemList": table_List,
									"event_datetime": table_date_array[currentArrayDate] + " " + memo_time,
									"event_place": memo_place,
									"event_lat": memo_place_lat,
									"event_lng": memo_place_lng,
									"event_memo": memo_content,
									"event_content": review_content
								},
								success: function (response) {

									$.ajax({
										url: "/event_change",
										type: "post",
										traditional: true,
										data: {
											"event_id": card_uuid,
											"event_title": memo_text,
											"event_datetime": datepicker + " " + memo_time,
											"event_place": memo_place,
											"event_lat": memo_place_lat,
											"event_lng": memo_place_lng,
											"event_memo": memo_content,
											"event_review": review_content
										},
										success: function (response) {
											console.log("event_change DB");
										},
										dataType: "json"
									});
								},
								dataType: "json"
							});

						} catch (error) {
							console.error("AJAX Error: " + error);
						}
					}

					// 비동기 루프를 사용하여 table_array를 반복
					async function processTableArray() {
						for (var array_num = 0; array_num < table_array.length; array_num++) {
							await processTableData(array_num, array_date);
							array_date++;
						}

					}

					// 함수를 호출하여 table_array 처리
					processTableArray();



					// 저장 모달창 없애기
					document.getElementById("modal").style.display = "none";
				}

				// schedule에 sche_id와 일치하는 데이터가 있다면 데이터 수정
				else {
					// schedule에 sche_id와 event에 event_date가 일치하는 데이터가 있다면 수정
					// schedule DB 수정 ajax
					// sche_id 일치하면 sche_title 수정
					$.ajax({
						url: "/schedule_change",
						type: "post",
						traditional: true,
						data: {
							"sche_id": location_uuid,
							"sche_title": $("#travel_title").val(),
						},
						success: function (data2) {},
					});

					var elementCount = $("[class*=uuid]").length;

					async function REevent_change_Array(array_num) {

						var table_List = [];
						var table_items = $("." + table_array[array_num] + " [id^=title]");

						var event_uuid = $("." + table_array[array_num] + " [class*=uuid]");
						var event_uuid_arr = [];

						// 날짜 별 제목 배열
						table_items.each(function () {
							table_List.push($(this).text());
						});

						// event_id 배열
						event_uuid.each(function () {
							var id = $(this).attr("id");
							event_uuid_arr.push(id);
						});

						console.log("삭제 시킬 배열 : " + cancle_event_arr);

						try {
							$.ajax({
								url: "/REevent_change",
								type: "post",
								traditional: true,
								data: {
									"event_uuid_arr": event_uuid_arr,
									"cancle_event_arr": cancle_event_arr,
									"elementCount": elementCount,
									"card_uuid": $('#location_uuid').val(),
									"itemList": table_List,
									"event_id": card_uuid,
									"event_title": memo_text,
									"event_datetime": datepicker + " " + memo_time,
									"event_place": memo_place,
									"event_lat": memo_place_lat,
									"event_lng": memo_place_lng,
									"event_memo": memo_content,
									"event_review": review_content
								},
								success: function (response) {
									console.log("event_change DB");
								},
								dataType: "json"
							});
						} catch (error) {
							console.error("AJAX Error: " + error);
						}
					}

					// 비동기 루프를 사용하여 table_array를 반복
					async function REevent_change_Array_result() {
						for (var array_num = 0; array_num < table_array.length; array_num++) {
							await REevent_change_Array(array_num);
						}

					}

					// 함수를 호출하여 table_array 처리
					REevent_change_Array_result();


				}
				// 저장 모달창 없애기
				document.getElementById("modal").style.display = "none";
			},
			dataType: "json"
		});
	}

	// 메모장에 쓴 제목 일정표에 삽입
	$('#' + memo_text_id).text(memo_text);

	// 일정 제목 배열에 추가
	// 제목이 지정되어 있다면 메모장에 내용이 있고, 그렇지 않으면 사용자가 일정 추가로 추가만 해놓은 상태
	saveSortableOrder();

});



document.getElementById("modal").style.display = "none";
$('#memo_text').val("");


document.getElementById("modal_close_btn").onclick = function () {
	document.getElementById("modal").style.display = "none";
}



document.getElementById("box_title_modal_close").onclick = function () {
	document.getElementById("box_title_modal").style.display = "none";
}
