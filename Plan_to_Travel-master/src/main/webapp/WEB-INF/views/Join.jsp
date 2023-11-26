<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!doctype html>
<html>

<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="" />
    <meta name="author" content="" />
    <title>회원가입</title>
    <link rel="stylesheet" href="/resources/css/Join.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
        integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.4.1.js"
        integrity="sha256-WpOohJOqMqqyKL9FccASB9O0KwACQJpFTUBLTYOVvVU=" crossorigin="anonymous"></script>
</head>

<body>

    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-4 mt-4 mb-4 signup-container">
                <h1 class="signup-title text-center">회원가입</h1>
                <form id="join_form" method="post">
                    <div class="form-group mt-3 mail_check_wrap">
                        <label for="username">아이디</label> <input type="text" class="form-control mt-2 id_input"
                            name="u_id" id="username" placeholder="아이디를 입력하세요">
                    </div>
                    <span class="id_input_re_1">사용 가능한 아이디입니다.</span>
                    <span class="id_input_re_2">아이디가 이미 존재합니다.</span>
                    <span class="final_id_ck">아이디를 입력해주세요.</span>

                    <div class="form-group mt-3">
                        <label for="useremail">이메일</label> <input type="text" class="form-control mt-2 email_input"
                            name="u_email" id="useremail" placeholder="이메일을 입력하세요">
                    </div>
                    <span class="final_mail_ck">이메일을 입력해주세요.</span>

                    <div class="mt-2">
                        <button type="button" class="btn btn-primary mail_check_button sendCode" id="sendCodeBtn">인증번호
                            발급</button>
                    </div>

                    <div class="form-group mt-3">
                        <label for="email_verification">이메일 인증</label>
                        <div class="input-group mt-2">
                            <input type="text" class="form-control mail_check_input" placeholder="인증 번호를 입력하세요">
                            <button class="btn btn-primary checkCodeBtn" type="button">인증</button>
                        </div>
                    </div>
                    <span class="emailcheckCode">인증번호를 입력해주세요.</span> <span id="mail_check_input_box_warn"></span>


                    <div class="form-group mt-3">
                        <label for="password">비밀번호</label> <input type="text" class="form-control mt-2 pw_input"
                            name="u_pw" id="password" placeholder="비밀번호를 입력하세요">
                    </div>
                    <span class="final_pw_ck">비밀번호를 입력해주세요.</span>

                    <div class="form-group mt-3">
                        <label for="password">재확인 비밀번호</label>
                        <div class="input-group mt-2">
                            <input type="text" class="form-control pwck_input" placeholder="비밀번호 확인"
                                aria-label="비밀번호 확인">
                            <button class="btn btn-primary pwcheck_button" type="button">확인</button>
                        </div>
                    </div>
                    <span class="final_pwck_ck">재확인 비밀번호를 입력해주세요.</span>
                    <span class="pwck_input_re_1">비밀번호가 일치합니다.</span>
                    <span class="pwck_input_re_2">비밀번호가 일치하지 않습니다.</span>

                    <button type="button" class="btn btn-primary mt-4 btn-block join_button"
                        style="width: 100%;">회원가입</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        //이메일전송 인증번호 저장위한 코드
        var code = "";

        /* 유효성 검사 통과유무 변수 */
        var idCheck = false; // 아이디
        var idckCheck = false; // 아이디 중복 검사
        var emailCheck = false; // 이메일
        var emailnumCheck = false; // 이메일 인증번호 확인
        var pwCheck = false; // 비번
        var pwckCheck = false; // 비번 확인
        var pwckcorCheck = false; // 비번 확인 일치 확인

        //아이디 중복검사
        $('.id_input').on("propertychange change keyup paste input", function () {

            console.log("keyup 테스트");

            // .id_input에 입력되는 값
            var u_id = $('.id_input').val();

            if (u_id != "") {

                $('.final_id_ck').css('display', 'none');

                // '컨트롤에 넘길 데이터 이름' : '데이터(.id_input에 입력되는 값)'
                console.log(u_id);

                var data = {
                    u_id: u_id
                }

                $.ajax({
                    type: "post",
                    //url : "/member/memberIdChk", 이건 경로를 설정하는 거니까 뒤에있는 IdChk 메소드가 어느 위치에 있는 어떤 파일인지를 보고 작성할 것
                    url: "/userIdChk",
                    data: data,
                    success: function (result) {
                        //console.log("성공 여부" + result);

                        if (u_id = !"") {
                            //result = 0이면 , success, 아이디 사용 가능
                            if (result != 'fail') {
                                $('.id_input_re_1').css("display", "inline-block");
                                $('.id_input_re_2').css("display", "none");
                                $('.final_id_ck').css("display", "none");
                                // 아이디 중복이 없는 경우
                                idckCheck = true;
                            }
                            //result = 0이 아니면 , fail, 중복 아이디 존재
                            else {
                                $('.id_input_re_2').css("display", "inline-block");
                                $('.id_input_re_1').css("display", "none");
                                $('.final_id_ck').css("display", "none");
                                // 아이디 중복이 없는 경우
                                idckCheck = true;
                            }
                        }

                    } // success 종료

                }); // ajax 종료

            } else {
                $('.final_id_ck').css('display', "inline-block");
                $('.id_input_re_1').css("display", "none");
                $('.id_input_re_2').css("display", "none");
            }

        }); // function 종료


        // 인증번호 이메일 전송 
        $(".mail_check_button").click(function () {

            //입력한 이메일
            var email = $(".email_input").val();

            $.ajax({

                type: "GET",
                url: "emailCheck?email=" + email,
                success: function (data) {

                    alert("입력하신 이메일로 인증 번호가 전송되었습니다.");
                    console.log("data : " + data);
                    code = data;
                }

            });
        });

        // 인증번호 비교
        $(".checkCodeBtn").click(function () {

            var inputCode = $(".mail_check_input").val(); // 입력코드    
            var checkResult = $("#mail_check_input_box_warn"); // 비교 결과  

            if (inputCode != "") {

                if (inputCode == code) { // 일치할 경우
                    checkResult.html("인증번호가 일치합니다.");
                    checkResult.attr("class", "correct");
                    emailnumCheck = true; // 일치할 경우
                } else { // 일치하지 않을 경우
                    checkResult.html("인증번호를 다시 확인해주세요.");
                    checkResult.attr("class", "incorrect");
                    emailnumCheck = false; // 일치하지 않을 경우
                }
            } else {
                $('.emailcheckCode').css('display', 'block');
                emailnumCheck = false;
            }

        });

        //비밀번호 확인 일치 유효성 검사
        //비밀번호 확인 버튼
        $(".pwcheck_button").click(function () {

            var pw = $('.pw_input').val(); // 비밀번호 입력란
            var pwck = $('.pwck_input').val(); // 비밀번호 확인 입력란

            $('.final_pwck_ck').css('display', 'none');

            if (pw == pwck) {

                if (pwck == "") {
                    $('.final_pwck_ck').css('display', 'block');
                    $('.pwck_input_re_1').css('display', 'none');
                    $('.pwck_input_re_2').css('display', 'none');
                    pwckCheck = false;
                    pwckcorCheck = false;
                } else {
                    $('.pwck_input_re_1').css('display', 'block');
                    $('.pwck_input_re_2').css('display', 'none');
                    pwckcorCheck = true;
                }
            } else {
                $('.pwck_input_re_1').css('display', 'none');
                $('.pwck_input_re_2').css('display', 'block');
                pwckcorCheck = false;
            }
        });



        $(document).ready(function () {

            //회원가입 버튼(회원가입 기능 작동)
            $(".join_button").click(function () {

                /* 입력값 변수 */
                var id = $('.id_input').val(); // id 입력란
                var pw = $('.pw_input').val(); // 비밀번호 입력란
                var pwck = $('.pwck_input').val(); // 비밀번호 확인 입력란
                var email = $('.email_input').val(); // 이메일 입력란

                /* 아이디 유효성검사 */
                if (id == "") {
                    $('.final_id_ck').css('display', 'block');
                    idCheck = false;
                } else {
                    $('.final_id_ck').css('display', 'none');
                    idCheck = true;
                }

                /* 이메일 유효성 검사 */
                if (email == "") {
                    $('.final_mail_ck').css('display', 'block');
                    emailCheck = false;
                } else {
                    $('.final_mail_ck').css('display', 'none');
                    emailCheck = true;
                }

                /* 비밀번호 유효성 검사 */
                if (pw == "") {
                    $('.final_pw_ck').css('display', 'block');
                    pwCheck = false;
                } else {
                    $('.final_pw_ck').css('display', 'none');
                    pwCheck = true;
                }

                /* 비밀번호 확인 유효성 검사 */
                if (pwck == "") {
                    $('.final_pwck_ck').css('display', 'block');
                    pwckCheck = false;
                } else {
                    $('.final_pwck_ck').css('display', 'none');
                    pwckCheck = true;
                }

                /* 비밀번호 확인 일치 유효성 검사 */
                var pw = $('.pw_input').val();
                var pwck = $('.pwck_input').val();
                $('.final_pwck_ck').css('display', 'none');

                if (pw == pwck) {

                    if (pwck == "") {
                        $('.final_pwck_ck').css('display', 'block');
                        $('.pwck_input_re_1').css('display', 'none');
                        $('.pwck_input_re_2').css('display', 'none');
                        pwckCheck = false;
                        pwckcorCheck = false;
                    } else {
                        $('.pwck_input_re_1').css('display', 'block');
                        $('.pwck_input_re_2').css('display', 'none');
                        pwckcorCheck = true;
                    }
                } else {
                    $('.pwck_input_re_1').css('display', 'none');
                    $('.pwck_input_re_2').css('display', 'block');
                    pwckcorCheck = false;
                }

                /* 최종 유효성 검사 */
                //유효성 검사 변수들이 true가 되었는지 모두 확인합니다. 모두 true일 경우 회원가입 form을 서버에 전송
                if (idCheck && idckCheck && pwCheck && pwckCheck && pwckcorCheck && emailCheck &&
                    emailnumCheck) {

                    $("#join_form").attr("action", "/Join");
                    $("#join_form").submit();

                }

                return false;

            });

        });
    </script>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">
    </script>
</body>

</html>