<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: chs
  Date: 2023/05/18
  Time: 2:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form method="get" action="/testXss1.do">
    <input type="text" id="dd" name="test" value="<script>alert('r이번엔?')</script>">
    <input type="submit">
</form><br><br><br>



<form action="/testXss2.do" method="post" id="noticeForm" >
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


<br>
<input type="text" id="xssinput" value="">
<button type="button" id="ajaxBtnReturnJson" name="ajaxBtnName">ajax 반환을 json에 model 담아서 반환 테스트</button>
<br>



<c:if test="${changeText ne null}">
    <h5>${changeText}</h5>
</c:if>

</body>
<script>
    let mBtn = document.querySelector('#ajaxBtnReturnJson');
    mBtn.addEventListener('click', function () {
        let xhr = new XMLHttpRequest();
        let xssinput = document.querySelector("#xssinput").value;

        let data = {
            boardId: 3,
            title: xssinput,
            writer: 'cho',
            password:'1111',
            content: 'hi',
            noticeStatus : '1'

        }

        let encodedData = "";
        for (let key in data) {
            encodedData += encodeURIComponent(key) + "=" + encodeURIComponent(data[key]) + "&";
        }
        encodedData = encodedData.substring(0, encodedData.length - 1);


        console.log("인코딩 데이터:");
        console.log(encodedData);

        xhr.open('POST', 'ajaxModel.do');
        xhr.setRequestHeader("Content-Type", 'application/x-www-form-urlencoded');

        xhr.onload = function () {
            if (xhr.status === 200) {
                console.log("성공");
                console.log(xhr.responseText);
                console.log(xhr.responseText.test);
            } else {
                console.log("error");
            }
        }

        xhr.send(encodedData);

    });

</script>


</html>
