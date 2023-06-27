<%--
  Created by IntelliJ IDEA.
  User: chs
  Date: 2023/05/10
  Time: 4:55 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>공지사항 등록</title>
</head>
<body>
<h1>공지사항 등록</h1>
<form action="/register/register.do" method="post" id="noticeForm" enctype="multipart/form-data">
    <label for="title">제목</label>
    <input type="text" id="title" name="title" required><br>
    <label for="noticeStatus">대표 공지글 여부</label>
    <input type="checkbox" id="noticeStatus" name="noticeStatus" value="1"><br>
    <label for="content">본문 내용</label>
    <textarea id="content" name="content" required></textarea><br>
    <label for="writer">작성자</label>
    <input type="text" id="writer" name="writer" value="admin" required><br>
    <label for="password">비밀번호</label>
    <input type="password" id="password" name="password"><br>
    <label for="files">파일 업로드</label>
    <input type="file" id="files" name="files" multiple><br>
    <input type="button" value="등록" onclick="submitForm()" style="background-color: #00698C;margin-bottom: 20px">
    <input type="button" value="취소" onclick="location.href='/'" style="background-color: darkgreen">
</form>
</body>

<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>
<script>
    function submitForm(){

        if(validation()){

            let formData = new FormData(document.querySelector("#noticeForm"));
            // let formData = document.querySelector("#noticeForm");
            let notice = document.querySelector("#noticeStatus");

            console.log(notice.checked);
            if(!notice.checked){
                formData.append('noticeStatus', "0");
            }

            let files = document.querySelector('#files').files;
            for (let i = 0; i < files.length; i++) {
                formData.append('files[]', files[i]);
            }

            formData.forEach((value, key) => {
                console.log(key + ": " + value);
            });

            // formData.submit();
            let xhr = new XMLHttpRequest();
            xhr.open('POST', 'register/register.do');
            xhr.setRequestHeader('enctype', 'multipart/form-data');
            xhr.setRequestHeader('X-Requested-With','XMLHttpRequest');

            xhr.onreadystatechange = function (){
                if(xhr.status === 200){
                    Swal.fire({
                        icon: 'success',
                        title: '등록이 완료되었습니다!',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(function(){
                        location.href = '/';
                    });
                }
            }
            xhr.send(formData);
        }
    }

    function validation(){
        let title = document.querySelector("#title").value;
        let content = document.querySelector("#content").value;
        let password = document.querySelector("#password").value;

        if (title.trim() === "") {
            Swal.fire({
                icon: 'error',
                title: '제목을 입력해주세요!',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }

        if (content.trim() === "") {
            Swal.fire({
                icon: 'error',
                title: '본문 내용을 입력해주세요!',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }

        if (password.trim() === "") {
            Swal.fire({
                icon: 'error',
                title: '비밀번호를 입력해주세요!',
                showConfirmButton: false,
                timer: 1500
            });
            return false;
        }

        return true;
    }



</script>

<style>
    /* 전체 폼 스타일 */
    form {
        margin: 50px auto;
        max-width: 600px;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
        box-shadow: 0 0 10px #ddd;
    }

    /* 제목 입력란 스타일 */
    label[for="title"] {
        display: block;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 10px;
    }

    #title {
        display: block;
        width: 100%;
        height: 40px;
        font-size: 1.2em;
        padding: 5px 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* 본문 내용 입력란 스타일 */
    label[for="content"] {
        display: block;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 10px;
    }

    #content {
        display: block;
        width: 100%;
        height: 300px;
        font-size: 1.2em;
        padding: 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* 작성자 입력란 스타일 */
    label[for="writer"] {
        display: block;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 10px;
    }

    #writer {
        display: block;
        width: 100%;
        height: 40px;
        font-size: 1.2em;
        padding: 5px 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* 비밀번호 입력란 스타일 */
    label[for="password"] {
        display: block;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 10px;
    }

    #password {
        display: block;
        width: 100%;
        height: 40px;
        font-size: 1.2em;
        padding: 5px 10px;
        margin-bottom: 20px;
        border: 1px solid #ddd;
        border-radius: 5px;
    }

    /* 파일 업로드 입력란 스타일 */
    label[for="files"] {
        display: block;
        font-size: 1.2em;
        font-weight: bold;
        margin-bottom: 10px;
    }

    #files {
        display: block;
        width: 100%;
        margin-bottom: 20px;
    }

    /* 대표 공지글 여부 체크박스 스타일 */
    label[for="notice"] {
        display: block;
        font-size: 1.2em;
        margin-bottom: 10px;
    }

    #notice {
        margin-bottom: 20px;
    }

    /* 등록 버튼 스타일 */
    input[type="submit"] {
        display: block;
        width: 100%;
        height: 40px;
        font-size: 1.2em;
        margin-bottom: 20px;
    }

    body {
        font-family: Arial, sans-serif;
    }

    h1 {
        text-align: center;
        margin-bottom: 20px;
    }

    form {
        width: 600px;
        margin: 0 auto;
        border: 1px solid #ccc;
        padding: 20px;
        border-radius: 5px;
    }

    label {
        display: block;
        margin-bottom: 10px;
        font-weight: bold;
    }

    input[type="text"],
    input[type="password"],
    textarea,
    select {
        width: 100%;
        padding: 10px;
        margin-bottom: 20px;
        border-radius: 5px;
        border: 1px solid #ccc;
    }

    input[type="checkbox"] {
        margin-right: 10px;
    }

    input[type="submit"],
    input[type="button"] {
        display: block;
        width: 100%;
        padding: 10px;
        border-radius: 5px;
        border: none;
        /*background-color: #008CBA;*/
        color: #fff;
        cursor: pointer;
    }

    input[type="submit"]:hover,
    input[type="button"]:hover {
        background-color: #00698C;
    }






</style>

</html>
