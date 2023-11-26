<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>��й�ȣ ã��<</title>
  <link rel="stylesheet" href="/resources/css/findPW.css" />
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet"
    integrity="sha384-rbsA2VBKQhggwzxH7pPCaAqO46MgnOM80zW1RWuH61DGLwZJEdK2Kadq2F9CUG65" crossorigin="anonymous">
</head>

<body>

  <div class="container">
    <div class="row justify-content-center">
      <div class="col-md-5 mt-5">
        <h1 class="text-center">��й�ȣ ã��<</h1>
        <form>
          <div class="mb-2 mt-5">
            <label for="id" class="form-label">���̵�<</label>
            <input type="text" class="form-control" id="id" placeholder="���̵� �Է��ϼ���">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="findIdBtn">���̵� Ȯ��</button>
          </div>
          <div class="mb-2">
            <label for="email" class="form-label">�̸���</label>
            <input type="email" class="form-control" id="email" placeholder="�̸����� �Է��ϼ���">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="sendEmailBtn">�̸��� ������</button>
          </div>
          <div class="mb-2">
            <label for="verificationCode" class="form-label">���� �ڵ�</label>
            <input type="text" class="form-control" id="verificationCode" placeholder="���� �ڵ带 �Է��ϼ���">
          </div>
          <div class="mb-3">
            <button type="button" class="btn btn-primary" id="verifyBtn">���� Ȯ��</button>
          </div>
          <div class="mb-3 mt-5 text-center">
            <label for="foundId" class="form-label">ã�� ��й�ȣ</label>
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
    // �̸��� ������ ��ư Ŭ�� �� ����
    document.getElementById('sendEmailBtn').addEventListener('click', function () {
      // ���⿡ �̸��� ������ ���� �ۼ�
      // �̸��� ���� �� ���� �ڵ带 �̸��Ϸ� ������ ���� ����
    });

    // ���� Ȯ�� ��ư Ŭ�� �� ����
    document.getElementById('verifyBtn').addEventListener('click', function () {
      // ���⿡ ���� Ȯ�� ���� �ۼ�
      // ����ڰ� �Է��� ���� �ڵ带 Ȯ���Ͽ� ���̵� ã�� ���� ����
      var verificationCode = document.getElementById('verificationCode').value;
      if (verificationCode == '123456') {
        var foundId = 'testuser'; // ���̵� ã�Ҵٰ� ����
        document.getElementById('foundId').value = foundId;
      } else {
        document.getElementById('foundId').value = '';
        alert('���� �ڵ尡 ��ġ���� �ʽ��ϴ�.');
      }
    });
  </script>
  
</body>

</html>