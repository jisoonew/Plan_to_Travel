<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>비밀번호 찾기<</title>
  <link rel="stylesheet" href="/resources/css/findPW.css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body>

  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5 mt-5">
        <h1 class="text-center">비밀번호 찾기<</h1>
        <form>
          <div class="mb-2 mt-5">
            <label for="id" class="form-label">아이디<</label>
            <input type="text" class="form-control" id="id" placeholder="占쏙옙占싱듸옙 占쌉뤄옙占싹쇽옙占쏙옙">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="findIdBtn">아이디 확인</button>
          </div>
          <div class="mb-2">
            <label for="email" class="form-label">이메일</label>
            <input type="email" class="form-control" id="email" placeholder="이메일을 입력하세요">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="sendEmailBtn">이메일 보내기</button>
          </div>
          <div class="mb-2">
            <label for="verificationCode" class="form-label">인증 코드</label>
            <input type="text" class="form-control" id="verificationCode" placeholder="인증 코드를 입력하세요">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="verifyBtn">인증 확인</button>
          </div>
          <div class="mb-3 mt-5 text-center">
            <label for="foundId" class="form-label">찾은 비밀번호</label>
            <input type="text" class="form-control" id="foundId" readonly>
          </div>
        </form>
      </div>
    </div>
  </div>


  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"
    integrity="sha384-kenU1KFdBIe4zVF0s0G1M5b4hcpxyD9F7jL+jjXkk+Q2h455rYXK/7HAuoJl+0I4" crossorigin="anonymous">
  </script>

  <script>
    // 이메일 보내기 버튼 클릭 시 동작
    document.getElementById('sendEmailBtn').addEventListener('click', function () {
      // 여기에 이메일 보내는 로직 작성
      // 이메일 전송 후 인증 코드를 이메일로 보내는 것을 가정
    });

    // 인증 확인 버튼 클릭 시 동작
    document.getElementById('verifyBtn').addEventListener('click', function () {
      // 여기에 인증 확인 로직 작성
      // 사용자가 입력한 인증 코드를 확인하여 아이디를 찾는 것을 가정
      var verificationCode = document.getElementById('verificationCode').value;
      if (verificationCode == '123456') {
        var foundId = 'testuser'; // 아이디를 찾았다고 가정
        document.getElementById('foundId').value = foundId;
      } else {
        document.getElementById('foundId').value = '';
        alert('인증 코드가 일치하지 않습니다.');
      }
    });
  </script>
  
</body>

</html>