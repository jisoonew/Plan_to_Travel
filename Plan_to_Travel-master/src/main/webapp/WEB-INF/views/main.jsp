<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="ko">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>가보자고</title>
  <!-- Air datepicker css -->
  <script src="./datepicker/js/datepicker.js"></script> <!-- Air datepicker js -->
  <script src="./datepicker/js/datepicker.ko.js"></script> <!-- 달력 한글 추가를 위해 커스텀 -->

  <link href="resources/css/main.css" rel="stylesheet" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
  <!--TMAP 호출-->

  <script src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
  <script src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7">
  </script>
  <script type="text/javascript"
    src="https://apis.openapi.sk.com/tmap/jsv2?version=1&appKey=5A53DsGwddaFFyXqIjgmU8VGi3Vsx3Yb8DYy3kT7 autoload=false">
  </script><!--  autoload=false -->

  <script src="http://code.jquery.com/jquery-latest.min.js"></script>

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


<!--MAIN HOME UI-->

<body>
  <nav class="navbar bg-light fixed-top border-bottom border-dark">
    <div class="container-fluid">
      <img src="resources/img/logo.png" alt="Logo" width="120" height="50">
      <button class="navbar-toggler" type="button" data-bs-toggle="offcanvas" data-bs-target="#offcanvasNavbar"
        aria-controls="offcanvasNavbar" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>
      <div class="offcanvas offcanvas-end" tabindex="-1" id="offcanvasNavbar" aria-labelledby="offcanvasNavbarLabel">
        <div class="offcanvas-header">
          <h5 class="offcanvas-title" id="offcanvasNavbarLabel">${user.u_id}님</h5>
          <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="Close"></button>
        </div>
        <div class="offcanvas-body">
          <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
            <li class="nav-item">
              <button class="nav-link active" type="button" aria-current="page" id="Favorites">즐겨찾기</button>
            </li>
            <li class="nav-item">
              <a class="nav-link active" type="button" aria-current="page" id="History">스케줄 History</a>
            </li>
            <li class="nav-item">
              <a class="nav-link active" type="button" aria-current="page" id="Journal">여행 일지</a>
            </li>
          </ul>
        </div>
      </div>
    </div>
  </nav>

  <!-- 즐겨찾기 -->
  <div class="offcanvas offcanvas-end" tabindex="-1" id="Offcanvas_Favorites" aria-labelledby="offcanvasNavbarLabel">
    <div class="offcanvas-header">
      <button type="button" class="btn btn-outline-primary" data-bs-dismiss="offcanvas" type="button"><i
          class="bi bi-arrow-left"></i></button> <!-- 뒤로가기 -->
      <button type="button" class="btn btn-outline-primary"><i class="bi bi-trash-fill"></i>삭제</button> <!-- 즐겨찾기 삭제 -->
    </div>
    <div class="offcanvas-body">
      <ul class="navbar-nav justify-content-end flex-grow-1 pe-3">
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Favorites">경민대학교</button>
          <button type="button" id="Favorites_cancel"><i class="bi bi-x"></i></button> <!-- 즐겨찾기 삭제 -->
        </li>
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Favorites">어린이대공원 후문</button>
          <button type="button" id="Favorites_cancel"><i class="bi bi-x"></i></button> <!-- 즐겨찾기 삭제 -->
        </li>
        <li class="nav-item">
          <button class="nav-link active" type="button" aria-current="page" id="Favorites">부산역</button>
          <button type="button" id="Favorites_cancel"><i class="bi bi-x"></i></button> <!-- 즐겨찾기 삭제 -->
        </li>
      </ul>
    </div>
  </div>


  <!-- 스케줄 History -->
  <div class="offcanvas offcanvas-end" tabindex="-1" id="Offcanvas_History" aria-labelledby="offcanvasNavbarLabel">
    <div class="offcanvas-header">
      <button type="button" class="btn btn-outline-primary" data-bs-dismiss="offcanvas" type="button"><i
          class="bi bi-arrow-left"></i></button> <!-- 뒤로가기 -->
      <button type="button" class="btn btn-outline-primary" title="스케줄 추가하기"><i class="bi bi-plus-lg"></i></button>
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
        <input class="form-control" id="location_uuid" name="location_uuid"> <!-- type="hidden" -->
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
        <button type="button" class="btn btn-outline-danger btn-sm">대중교통</button>
        <button type="button" class="btn btn-outline-dark btn-sm" id="resetButton">지도 초기화</button>
      </div>

      <jsp:include page="/WEB-INF/views/map_search.jsp" />

      <jsp:include page="/WEB-INF/views/map_pedestrian.jsp" />

      <jsp:include page="/WEB-INF/views/map_car.jsp" />

      <button type="button" class="place_add btn btn-outline-info btn-sm">장소 추가</button>
    </div>
  </div>

  <div class="memo_padding">
    <div class="memo_write">
      <div class="card" style="width: 65.5rem;">
        <div class="card-body" style="height: 50px;">
          <p class="card-text" id="memo_title">제목 : </p>
          <input type="text" id="memo_text" placeholder="title">
          <input type="text" id="memo_text_id" placeholder="title"> <!-- 장소 아이디 style="display: none;" -->
          <input type="text" id="clickedCardIndex_text"><!-- style="display: none;" -->
          <!-- event_id -->
          <input type="text" id="table-box_text"><!-- style="display: none;" -->
          <!-- table-box가 무엇인지 -->
        </div>

        <div class="card-body" style="height: 50px;">
          <p class="card-text" id="memo_date">날짜 : </p>
          <input type="text" id="datepicker" placeholder="date">
        </div>

        <div class="card-body" style="height:50px;">
          <p class="card-text" id="memo_time_text">시간 : </p>
          <p><input type="time" id="memo_time"></p>
        </div>

        <div class="card-body" style="height: 50px; width: 700px;">
          <p class="card-text" id="memo_place_text">장소 : </p>
          <input type="text" id="memo_place" placeholder="place">
          <input type="text" class="form-control" id="memo_place_lat" style="display: none;">
          <input type="text" class="form-control" id="memo_place_lng" style="display: none;">
        </div>

        <div class="card-body" style="height: 230px;">
          <textarea id="memo_content" name="content" rows="8" cols="132" placeholder="memo"></textarea>
        </div>

        <div class="card-body" style="height: 230px;">
          <textarea id="review_content" name="content" rows="8" cols="132" placeholder="review"></textarea>
        </div>

      </div>
    </div>
  </div>

  <div class="container_1"></div>

  <div class="advertisement">광고</div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">
  </script>

  <!--아래 2개의 스크립트는 무엇을 위한것? 이거 없어도 돌아감-->
  <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
  <!-- 부트스트랩 3.x를 사용한다. -->
  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

  <script src="resources/js/main.js"></script>
  <script>


  </script>
</body>
<iframe name='blankifr' style='display:none;'></iframe>

</html>