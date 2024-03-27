<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>가보자고</title>
  <!-- Air datepicker css -->
  <script src="./datepicker/js/datepicker.js"></script> <!-- Air datepicker js -->
  <script src="./datepicker/js/datepicker.ko.js"></script> <!-- 달력 한글 추가를 위해 커스텀 -->

  <link href="resources/css/main.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
  
  <!--TMAP 호출-->
  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ">
  </script>
  <script type="text/javascript"
    src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=3XaNTujjCH32qNOA2WdPX5eIwhNH8Adc9CUp7WIQ autoload=false">
  </script><!--  autoload=false -->

  <script src="http://code.jquery.com/jquery-latest.min.js"></script>
  
  <!-- jQuery 라이브러리 로드 -->
  <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>

  <!-- 날짜 데이트피커 라이브러리 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"
    integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.js"
    integrity="sha512-uto9mlQzrs59VwILcLiRYeLKPPbS/bT71da/OEBYEwcdNUk8jYIy+D176RYoop1Da+f9mvkYrmj5MCLZWEtQuA=="
    crossorigin="anonymous" referrerpolicy="no-referrer"></script>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jqueryui/1.12.1/jquery-ui.min.css"
    integrity="sha512-aOG0c6nPNzGk+5zjwyJaoRUgCdOrfSDhmMID2u4+OIslr0GjpLKo7Xm0Ao3xmpM4T8AmIouRkqwj1nrdVsLKEQ=="
    crossorigin="anonymous" referrerpolicy="no-referrer" />

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.0/font/bootstrap-icons.css">
</head>

<style>
@media (max-width: 1554px) and (min-width: 1300px) {

/* 지도와 버튼 컨테이너 */
#map_div_container {
  width: 550px;
  height: 1530px;
  margin-top: -850px;
  float: right;
  margin-right: 2%;
}

/* 광고 */
.advertisement {
  clear: left;
  width: 1500px;
  height: 100px;
  margin: 0 auto;
  margin-top: 680px;
  margin-bottom: 30px;
  border: 1px solid blue;
}

/* 여행 날짜 = 일정 날짜 범위 선택 */
#form_floating_div {
  width: 420px;
  margin-top: 2px;
  margin-left: 1%;
}

/* 일정표  */
#travel_table_container {
  border: 5px solid #6495ED;
  width: 785px;
  margin-top: -15px;
  margin-left: 1%;
  overflow-x: auto;
  display: flex;
  flex-direction: column; /* 세로 방향으로 나열 */
}

.date_container, .travel_table {
  display: flex;
  flex-direction: row;
  white-space: nowrap;
  width: max-content;
}

.travel_table {
    height: 620px;
  width: 1560px;
}


/* 메모장 */
.memo_padding {
  position: absolute;
  width: 950px;
  height: 500px;
  clear: left;
  padding-left: 3%;
}

.memo_write {
  position: absolute;
  width: 800px;
  height: 680px;
  clear: left;
}

/* 메모장 카드 크기 */
#card_size {
	width: 49rem;
}

/* 초기 스타일 설정 */
.card_package1 {
	cursor: pointer;
}
.selected {
	background-color: #ff0000; /* 클릭시 변경할 색상 */
}

#memo_content {
	width: 50rem;
}

#review_content {
	width: 57.5rem;
}


/* 일정표 제목과 저장 버튼 컨테이너 */
#title_container {
  width: 570px;
  margin-left: 15%;
  height: 70px;
  margin-top: -10px;
}

/* 일정표 제목 */
#travel_title {
  width: 270px;
  height: 50px;
  margin-top: 13px;
  margin-left: -5px;
  float: left;
}

/* 일정표 저장 버튼 */
#travel_save {
  margin-top: -55px;
  margin-bottom: 5px;
  width: 75px;
  margin-left: 495px;
  float: left;
  font-size: 15px;
  height: 50px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 1050px;
  height: 500px;
  clear: left;
  padding-left: 2.8%;
}

#memo_content {
	width: 46rem;
}
#review_content {
	width: 46rem;
}
}



@media (max-width: 1639px) and (min-width: 1555px) {
/* 지도와 버튼 컨테이너 */
#map_div_container {
  width: 550px;
  height: 1530px;
  margin-top: -850px;
  float: right;
  margin-right: 6%;
}

/* 광고 */
.advertisement {
  clear: left;
  width: 1500px;
  height: 100px;
  margin: 0 auto;
  margin-top: 680px;
  margin-bottom: 30px;
  border: 1px solid blue;
}

/* 여행 날짜 = 일정 날짜 범위 선택 */
#form_floating_div {
  width: 420px;
  margin-top: 2px;
  margin-left: 6.3%;
}

/* 일정표  */
#travel_table_container {
  border: 5px solid #6495ED;
  width: 785px;
  margin-top: -15px;
  margin-left: 6.5%;
  overflow-x: auto;
  display: flex;
  flex-direction: column; /* 세로 방향으로 나열 */
}

.date_container, .travel_table {
  display: flex;
  flex-direction: row;
  white-space: nowrap;
  width: max-content;
}

.travel_table {
    height: 620px;
  width: 1560px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 950px;
  height: 500px;
  clear: left;
  padding-left: 3%;
}

.memo_write {
  position: absolute;
  width: 800px;
  height: 680px;
  clear: left;
}

/* 메모장 카드 크기 */
#card_size {
	width: 49rem;
}

#memo_content {
	width: 50rem;
}

#review_content {
	width: 57.5rem;
}


/* 일정표 제목과 저장 버튼 컨테이너 */
#title_container {
  width: 570px;
  margin-left: 20%;
  height: 70px;
  margin-top: -10px;
}

/* 일정표 제목 */
#travel_title {
  width: 270px;
  height: 50px;
  margin-top: 13px;
  margin-left: 5px;
  float: left;
}

/* 일정표 저장 버튼 */
#travel_save {
  margin-top: -55px;
  margin-bottom: 5px;
  width: 75px;
  margin-left: 495px;
  float: left;
  font-size: 15px;
  height: 50px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 1050px;
  height: 500px;
  clear: left;
  padding-left: 7.8%;
}

#memo_content {
	width: 46rem;
}
#review_content {
	width: 46rem;
}
}

@media (max-width: 1739px) and (min-width: 1640px) {

/* 지도와 버튼 컨테이너 */
#map_div_container {
  width: 550px;
  height: 1530px;
  margin-top: -850px;
  float: right;
  margin-right: 6%;
}

/* 광고 */
.advertisement {
  clear: left;
  width: 1500px;
  height: 100px;
  margin: 0 auto;
  margin-top: 680px;
  margin-bottom: 30px;
  border: 1px solid blue;
}

/* 여행 날짜 = 일정 날짜 범위 선택 */
#form_floating_div {
  width: 420px;
  margin-top: 2px;
  margin-left: 6.3%;
}

/* 일정표  */
#travel_table_container {
  border: 5px solid #6495ED;
  width: 880px;
  margin-top: -15px;
  margin-left: 6.5%;
    overflow-x: auto;
  display: flex;
  flex-direction: column; /* 세로 방향으로 나열 */
}

.date_container, .travel_table {
  display: flex;
  flex-direction: row;
  white-space: nowrap;
  width: max-content;
}

.travel_table {
    height: 620px;
  width: 1560px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 950px;
  height: 500px;
  clear: left;
  padding-left: 3%;
}

.memo_write {
  position: absolute;
  width: 800px;
  height: 680px;
  clear: left;
}

/* 메모장 카드 크기 */
#card_size {
	width: 55rem;
}

#memo_content {
	width: 57.5rem;
}

#review_content {
	width: 57.5rem;
}

/* 일정표 제목과 저장 버튼 컨테이너 */
#title_container {
  width: 570px;
  margin-left: 25%;
  height: 70px;
  margin-top: -10px;
}

/* 일정표 제목 */
#travel_title {
  width: 300px;
  height: 50px;
  margin-top: 13px;
  margin-left: 80px;
  float: left;
}

/* 일정표 저장 버튼 */
#travel_save {
  margin-top: -55px;
  margin-bottom: 5px;
  width: 75px;
  margin-left: 495px;
  float: left;
  font-size: 15px;
  height: 50px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 1050px;
  height: 500px;
  clear: left;
  padding-left: 7.8%;
}

#memo_content {
	width: 52rem;
}
#review_content {
	width: 52rem;
}
}


@media (max-width: 1880px) and (min-width: 1740px) {

/* 지도와 버튼 컨테이너 */
#map_div_container {
  width: 550px;
  height: 1530px;
  margin-top: -850px;
  float: right;
  margin-right: 6%;
}

/* 광고 */
.advertisement {
  clear: left;
  width: 1500px;
  height: 100px;
  margin: 0 auto;
  margin-top: 680px;
  margin-bottom: 30px;
  border: 1px solid blue;
}

/* 여행 날짜 = 일정 날짜 범위 선택 */
#form_floating_div {
  width: 420px;
  margin-top: 2px;
  margin-left: 6.3%;
}

/* 일정표  */
#travel_table_container {
  border: 5px solid #6495ED;
  width: 960px;
  margin-top: -15px;
  margin-left: 6.5%;
  overflow-x: auto;
  display: flex;
  flex-direction: column; /* 세로 방향으로 나열 */
}

.date_container, .travel_table {
  display: flex;
  flex-direction: row;
  white-space: nowrap;
  width: max-content;
}

/* 일정표의 일정 div */
.travel_table {
  height: 620px;
  width: 1560px;
}

/* 메모장 */
.memo_padding {
  position: absolute;
  width: 950px;
  height: 500px;
  clear: left;
  padding-left: 3%;
}

.memo_write {
  position: absolute;
  width: 950px;
  height: 680px;
  clear: left;
}

/* 메모장 카드 크기 */
#card_size {
	width: 60.5rem;
}

#memo_content {
	width: 57.5rem;
}

#review_content {
	width: 57.5rem;
}



/* 일정표 제목과 저장 버튼 컨테이너 */
#title_container {
  width: 570px;
  margin-left: 29%;
  height: 70px;
  margin-top: -10px;
}

/* 일정표 제목 */
#travel_title {
  width: 300px;
  height: 50px;
  margin-top: 13px;
  margin-left: 140px;
  float: left;
}


}



@media screen and (min-width: 1880px) {
[class*="table-box"] {
  position: relative;
  border: 1px solid #cecece;
  padding-top: 10px;
  padding-bottom: 10px;
  height: 100%;
  width: 150px;
  float: left;
}

/* 지도와 버튼 컨테이너 */
#map_div_container {
  width: 550px;
  height: 1530px;
  margin-top: -850px;
  float: right;
  margin-right: 8%;
}

/* 여행 날짜 = 일정 날짜 범위 선택 */
#form_floating_div {
  width: 420px;
  margin-top: 2px;
  margin-left: 6%;
}

/* 일정표 컨테이너 */
#travel_table_container {
  border: 5px solid #6495ED;
  width: 1050px;
  margin-top: -15px;
  margin-left: 6%;
  overflow-x: auto;
  display: flex;
  flex-direction: column; /* 세로 방향으로 나열 */
}

.date_container, .travel_table {
  display: flex;
  flex-direction: row;
  white-space: nowrap;
  width: max-content;
}

.travel_table {
  height: 620px;
}


.memo_padding {
  position: absolute;
  width: 1050px;
  height: 500px;
  clear: left;
  padding-left: 8%;
}

/* 일정표 제목과 저장 버튼 컨테이너 */
#title_container {
  width: 570px;
  margin-left: 32%;
  height: 70px;
  margin-top: -10px;
}

/* 일정표 제목 */
#travel_title {
  width: 300px;
  height: 50px;
  margin-top: 13px;
  margin-left: 170px;
  float: left;
}

/* 일정표 저장 버튼 */
#travel_save {
  margin-top: -50px;
  margin-bottom: 5px;
  width: 75px;
  margin-left: 500px;
  float: left;
  font-size: 15px;
  height: 50px;
}
}
</style>


<!--MAIN HOME UI-->

<body>
  <nav class="navbar bg-light fixed-top border-bottom border-dark">
		<div class="container-fluid">
			<img src="resources/img/logo.png" alt="Logo" width="120" height="50">
			<button class="navbar-toggler" type="button"
				data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar"
				aria-controls="offcanvasNavbar" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="offcanvas offcanvas-end" tabindex="-1"
				id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
				<div class="offcanvas-header">
					<h5 class="offcanvas-title" id="offcanvasNavbarLabel">${user.u_id}님</h5>
					<button type="button" class="btn-close" data-bs-dismiss="offcanvas"
						aria-label="Close"></button>
				</div>
				<div class="offcanvas-body">
					<ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
						<li class="nav-item">
							<button class="nav-link active" type="button" aria-current="page"
								id="Favorites">즐겨찾기</button>
						</li>
						<li class="nav-item"><a class="nav-link active" type="button"
							aria-current="page" id="History">스케줄 History</a></li>
<!-- 						<li class="nav-item"><a class="nav-link active" type="button"
							aria-current="page" id="Journal">여행 일지</a></li> -->

					</ul>
				</div>

				<ul class="navbar-nav mt-auto">
					<li class="nav-item ms-3"><a class="nav-link active"
						type="button" id="logout" href="/logout">로그아웃</a></li>
				</ul>
			</div>
		</div>
	</nav>

	<!-- 즐겨찾기 -->
	<div class="offcanvas offcanvas-end" tabindex="-1"
		id="Offcanvas_Favorites" aria-labelledby="offcanvasNavbarLabel">
		<div class="offcanvas-header">
			<button type="button" class="btn btn-outline-primary"
				data-bs-dismiss="offcanvas" type="button">
				<i class="bi bi-arrow-left"></i>
			</button>
			<!-- 뒤로가기 -->
			<button type="button" class="btn btn-outline-primary" id="deleteAll">
				<i class="bi bi-trash-fill"></i>삭제
			</button>
			<!-- 즐겨찾기 삭제 -->
		</div>
		<div class="offcanvas-body">
			<ul class="navbar-nav justify-content-end flex-grow-1 pe-3">

			</ul>
		</div>
	</div>
  
  	<!-- 전체 삭제 모달 -->
	<div class="modal fade" id="deleteAllModal" tabindex="-1" role="dialog"
		aria-labelledby="deleteAllModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="deleteAllModalLabel">즐겨찾기 삭제</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
						<span aria-hidden="true">&times;</span>
					</button>
				</div>
				<div class="modal-body">저장된 즐겨찾기를 모두 삭제하시겠습니까?</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">취소</button>
					<button type="button" class="btn btn-primary" id="deleteAllBtn">확인</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 삭제 성공 모달 -->
	<div class="modal fade" id="favdeleteSuccessModal" tabindex="-1"
		aria-labelledby="deleteSuccessModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="deleteSuccessModalLabel">삭제 성공</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">즐겨찾기를 성공적으로 삭제하였습니다.</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary"
						data-bs-dismiss="modal">확인</button>
				</div>
			</div>
		</div>
	</div>


	<!-- 스케줄 History -->
	<div class="offcanvas offcanvas-end" tabindex="-1"
		id="Offcanvas_History" aria-labelledby="offcanvasNavbarLabel">
		<div class="offcanvas-header">
			<button type="button" class="btn btn-outline-primary"
				data-bs-dismiss="offcanvas" type="button">
				<i class="bi bi-arrow-left"></i>
			</button>
			<!-- 뒤로가기 -->
			<button type="button" class="btn btn-outline-primary"
				title="스케줄 추가하기">
				<i class="bi bi-plus-lg"></i>
			</button>
			<!-- 스케줄 History 추가 -->
		</div>
		<div class="offcanvas-body">
			<ul class="navbar-nav justify-content-end flex-grow-1 pe-3">

			</ul>
		</div>
	</div>

  <!-- 모달 창 -->
  <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteConfirmationModalLabel"
    aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteConfirmationModalLabel">삭제
            확인</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">정말로 삭제하시겠습니까?</div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">취소</button>
          <button type="button" class="btn btn-danger" id="confirmDelete">삭제</button>
        </div>
      </div>
    </div>
  </div>

  <!-- 삭제 성공 모달 -->
  <div class="modal fade" id="deleteSuccessModal" tabindex="-1" aria-labelledby="deleteSuccessModalLabel"
    aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <h5 class="modal-title" id="deleteSuccessModalLabel">삭제 성공</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          스케줄을 성공적으로 삭제하였습니다.
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-primary" data-bs-dismiss="modal">확인</button>
        </div>
      </div>
    </div>
  </div>


  <!-- 여행 일지 -->
  <div class="offcanvas offcanvas-end" tabindex="-1" id="Offcanvas_Journal" aria-labelledby="offcanvasNavbarLabel">
    <div class="offcanvas-header">
      <button type="button" class="btn btn-outline-primary" data-bs-dismiss="offcanvas" type="button"><i
          class="bi bi-arrow-left"></i></button> <!-- 뒤로가기 -->
      <button type="button" class="btn btn-outline-primary" title="여행 일지 추가하기"><i class="bi bi-plus-lg"></i></button>
      <!-- 여행 일지 추가 -->
    </div>
    <div class="offcanvas-body">
      <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Journal">부산 여행 일지</button>
          <input class="form-check-input" type="checkbox" value="" id="Journal_Check">
        </li>
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Journal">일본 후쿠오카 일지</button>
          <input class="form-check-input" type="checkbox" value="" id="Journal_Check">
        </li>
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Journal">제주도 여행 일지</button>
          <input class="form-check-input" type="checkbox" value="" id="Journal_Check">
        </li>
      </ul>
    </div>

    <button type="button" class="btn btn-outline-primary" id="Journal_btn">확인</button>
  </div>

  <div class="container-fluid-table">


    <!-- 여행 일정 선택 -->

    <div class="row g-2" id="form_floating_div" style="float: left;">
      <div class="col-md">
        <div class="form-floating">
          <input type="text" class="form-control" id="datepicker_start" placeholder="시작 날짜">
          <label for="floatingInput">시작 날짜</label>
        </div>
      </div>
      <div class="col-md">
        <div class="form-floating">
          <input type="text" class="form-control" id="datepicker_end" placeholder="종료 날짜">
          <label for="floatingInput">종료 날짜</label>
        </div>
      </div>
      <div class="col-md">
        <button id="btnShowDates" class="btn btn-outline-primary">확인</button>
      </div>

    </div>

    <div class="modal" tabindex="-1" id="modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">SAVE</h5>
            <button type="button" id="modal_close_btn" class="btn-close" data-bs-dismiss="modal"
              aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>저장하시겠습니까?</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" id="save_btn">Save</button>
          </div>
        </div>
      </div>
    </div>


    <div class="modal" tabindex="-1" id="box_title_modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">SCHEDULE</h5>
            <button type="button" id="box_title_modal_close" class="btn-close" data-bs-dismiss="modal"
              aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>하루 일정은 최대 12개까지 생성 가능합니다.</p>
          </div>
        </div>
      </div>
    </div>


    <div class="modal" tabindex="-1" id="non_save_modal">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">NO SAVE</h5>
            <button type="button" id="box_title_modal_close" class="btn-close" data-bs-dismiss="modal"
              aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>저장하고 싶은 일정을 선택하세요.</p>
          </div>
        </div>
      </div>
    </div>



    <div id="title_container">
      <form method="post" target='blankifr'>
        <!-- 일정표 UUID : 일정표의 범용 고유 식별자가 필요함 -->
        <input class="form-control" id="location_uuid" name="location_uuid" type="hidden"> <!-- type="hidden" -->
        <input type="text" class="form-control" id="travel_title" placeholder="일정표 제목 입력">
        <input type="submit" id="travel_save" class="btn btn-outline-primary" value="저장">
      </form>
    </div>
    <br />

    <div id="travel_table_container">
      <div class="row date_container" id="dateRangeOutput" style="margin-left: 0px;">
        <!-- 날짜 출력 -->
      </div>

      <div class="table-row travel_table" id="travel_table">
        <!-- 일정 출력 -->
      </div>
    </div>

  </div>


  <div id="tableContainer">
    <!-- 데이터를 채워 넣을 요소 -->
  </div>

  <div id="map_div_container">
    <div class="_map_layer_btn_group">
      <div class="_map_layer_btn">
        <button type="button" onclick="map_div_home_show();" class="btn btn-outline-primary btn-sm">지도 홈</button>
        <button type="button" onclick="map_div_pedestrian_show();" class="btn btn-outline-secondary btn-sm">도보</button>
        <button type="button" onclick="map_car_show();" class="btn btn-outline-success btn-sm">자동차</button>
        <button type="button" class="btn btn-outline-dark btn-sm" id="resetButton">지도 초기화</button>
      </div>

      <jsp:include page="/WEB-INF/views/map_search.jsp" />

      <jsp:include page="/WEB-INF/views/map_pedestrian.jsp" />

      <jsp:include page="/WEB-INF/views/map_car.jsp" />

      <div class="button-container">
				<button type="button"
					class="favorite_add btn btn-outline-info btn-sm" id="favorite_add">즐겨찾기</button>
				<button type="button" class="place_add btn btn-outline-info btn-sm" id="place_add">장소 추가</button>
				<button type="button"
					class="place_add_ped btn btn-outline-info btn-sm" id="place_add_ped">장소 추가</button>
				<button type="button"
					class="place_add_car btn btn-outline-info btn-sm" id="place_add_car">장소 추가</button>
			</div>
    </div>
  </div>

  <div class="modal" id="myModal" data-backdrop="static"
		data-keyboard="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">즐겨찾기 추가</h5>
				</div>
				<div class="modal-body">
					<form>
						<div class="form-group">
							<label for="placeName">장소 이름:</label> <input type="text"
								class="form-control" id="placeName" required>
						</div>
						<div class="form-group">
							<label for="placeDescription">장소 설명:</label>
							<textarea class="form-control" id="placeInfo"
								style="resize: none;" rows="4" required></textarea>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" id="cancelBtn">취소</button>
					<button type="button" class="btn btn-primary" id="saveBtn">저장</button>
				</div>

			</div>
		</div>
	</div>
	
	<!-- "시간을 조정하여 일정을 변경해주세요!" -->
	  <div class="modal" id="Time_Modal" data-backdrop="static"
		data-keyboard="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">시간을 조정하여 일정을 변경해주세요!</h5>
				</div>
				<div class="modal-body">
					<form>
						<div class="form-group">
							<label for="placeName" id="pre_name"></label> <input type="time" id="previous_time">
						</div>
						<div class="form-group">
							<label for="placeDescription" id="select_name"></label>
							<input type="time" id="select_time">
						</div>
						<div class="form-group">
							<label for="placeDescription" id="next_name"></label>
							<input type="time" id="next_time">
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary" id="TimecancelBtn">취소</button>
					<button type="button" class="btn btn-primary" id="saveBtn">저장</button>
				</div>

			</div>
		</div>
	</div>

	<div class="modal" id="successModal" data-backdrop="static"
		data-keyboard="false">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">성공</h5>
				</div>
				<div class="modal-body">
					<p>즐겨찾기에 저장되었습니다!</p>
				</div>
				<div class="modal-footer">
					<button type="button" id="closeModal" class="btn btn-primary"
						data-dismiss="modal">확인</button>
				</div>
			</div>
		</div>
	</div>

	<div class="memo_padding">
		<div class="memo_write">
			<div class="card" id="card_size">
				<div class="card-body" style="height: 50px;">
					<p class="card-text" id="memo_title">제목 :</p>
					<input type="text" id="memo_text" placeholder="title"> <input
						type="text" id="memo_text_id" placeholder="title"
						style="display: none;">
					<!-- 장소 아이디 style="display: none;" -->
					<input type="text" id="clickedCardIndex_text"
						style="display: none;">
					<!-- style="display: none;" -->
					<!-- event_id -->
					<input type="text" id="table-box_text" style="display: none;">
					<!-- style="display: none;" -->
					<!-- table-box가 무엇인지 -->
				</div>

				<div class="card-body" style="height: 50px;">
					<p class="card-text" id="memo_date">날짜 : <input type="text" id="datepicker" placeholder="date"></p>
					
				</div>

				<div class="card-body" style="height: 50px;">
					<p class="card-text" id="memo_time_text">시간 :</p>
						<input type="time" id="memo_time">
				</div>

				<div class="card-body" style="height: 50px; width: 700px;">
					<p class="card-text" id="memo_place_text">장소 :</p>
					<input type="text" id="memo_place" placeholder="place"> <input
						type="text" class="form-control" id="memo_place_lat"
						style="display: none;"> <input type="text"
						class="form-control" id="memo_place_lng" style="display: none;">
				</div>

				<div class="card-body" style="height: 230px;">
					<textarea id="memo_content" name="content" rows="8" cols="132"
						placeholder="memo" style="resize: none;"></textarea>
				</div>

				<div class="card-body" style="height: 230px;">
					<textarea id="review_content" name="content" rows="8" cols="132"
						placeholder="review" style="resize: none;"></textarea>
				</div>

			</div>
		</div>
	</div>

	<div class="container_1"></div>

	<div class="advertisement">
		<a target="_blank"
			href="https://www.yanolja.com/?utm_source=google_sa&utm_medium=cpc&utm_campaign=20738115572&utm_content=160897187931&utm_term=kwd-327025203539&gclid=Cj0KCQiA67CrBhC1ARIsACKAa8T-Gf5jEw9sPPmwiBPbyMGLLY4dpTo0SGA2shq0e5DjMhOSRGMsu4gaAnczEALw_wcB">
			<img src="/resources/img/YANOLJA.png" alt="Advertisement Image">
		</a> <a target="_blank" href="https://www.yeogi.com/"> <img
			src="/resources/img/YOGI.jpg" alt="Advertisement Image">
		</a> <a target="_blank"
			href="https://www.agoda.com/ko-kr/?cid=1891442&tag=320d7811-de04-e4ef-a451-826f977f00d7&gclid=Cj0KCQiA67CrBhC1ARIsACKAa8RDt75CJ3iqv2c9vJN8otoUyDnq3hUZyEaoHcjnchR7kqduFLLTgkcaAm0IEALw_wcB&ds=BQF0XMS%2F19wnvT3C">
			<img src="/resources/img/agoda.png" alt="Advertisement Image">
		</a> <a target="_blank" href="https://mtravel.interpark.com/home"> <img
			src="/resources/img/interpark.jpg" alt="Advertisement Image">
		</a> <a target="_blank"
			href="https://www.tripadvisor.co.kr/Restaurants-g294197-Seoul.html">
			<img src="/resources/img/tripadvi.jpg" alt="Advertisement Image">
		</a>

	</div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">
  </script>

  <!--아래 2개의 스크립트는 무엇을 위한것? 이거 없어도 돌아감-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
  <!-- 부트스트랩 3.x를 사용한다. -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

  <script src="resources/js/main.js"></script>
  <script>
  function map_div_pedestrian_show(){	 
		$('#map_div_car').hide();
	  	$('#map_div_home').hide();
	  	$('#map_div_ped').show();
	  	
	  	$('#place_add').hide();
	  	$('#place_add_car').hide();
	  	$('#place_add_ped').show();
	  	};
	  	
	    function map_div_home_show(){	 
			$('#map_div_home').show();
		  	$('#map_div_car').hide();
		  	$('#map_div_ped').hide();
		  	};
		  	
		  	function map_car_show(){	 
		  		$('#map_div_car').show();
		  	  	$('#map_div_home').hide();
		  	  	$('#map_div_ped').hide();
		  	  	
		  	  	$('#place_add').hide();
		  	  	$('#place_add_car').show();
		  	  	$('#place_add_ped').hide();
		  	  	};
		  	  	
		  	
		  	  // 각각의 card-title3 클래스를 가진 요소에 클릭 이벤트를 추가
		  	  $(".card-title3").on("click", function() {
		  	    // 모든 card_package3 클래스를 가진 요소의 배경색 초기화
		  	    $(".card_package3").css("background-color", "#0dcaf0");

		  	    // 클릭된 요소의 아이디를 가져와 해당 아이디를 가진 요소에 대한 배경색 변경
		  	    var clickedId = $(this).attr('id');
		  	    $("#" + clickedId).closest(".card_package3").css("background-color", "#ff0000");
		  	  });
	

  </script>
</body>
<iframe name='blankifr' style='display:none;'></iframe>

</html>