<%--
  Created by IntelliJ IDEA.
  User: chs
  Date: 2023/05/15
  Time: 4:34 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>공지사항 등록</title>
</head>
<body>
<h1>공지사항 등록</h1>

<form action="#" method="post" id="noticeForm" enctype="multipart/form-data">
    <input type="text" id="boardId" name="boardId" value="${notice.nbVO.boardId}" style="display:none;">
    <label for="title">제목</label>
    <input type="text" id="title" name="title" value="${notice.nbVO.title}" readonly required><br>
    <label for="noticeStatus">대표 공지글 여부</label>
    <%--    <input type="hidden" id="noticeStatus" name="noticeStatus" value="${notice.nbVO.noticeStatus}">--%>
    <%--    <input type="button" value="${notice.nbVO.noticeStatus == 1 ? '대표공지글' : '일반공지글'}" style="background-color: #00698C;margin-bottom: 20px"><br>--%>
    <input type="checkbox" id="noticeStatus" name="noticeStatus"
           value="1" ${notice.nbVO.noticeStatus == 1 ? 'checked' : ''} disabled><br>
    <label for="content">본문 내용</label>
    <textarea id="content" name="content" readonly required>${notice.nbVO.content}</textarea><br>
    <label for="writer">작성자</label>
    <input type="text" id="writer" name="writer" value="${notice.nbVO.writer}" readonly required><br>
    <label for="password" style="display:none;">비밀번호</label>
    <input type="password" id="password" name="password" value="${notice.nbVO.password}" style="display:none;"><br>
    <div id="fileDiv"></div>
    <p id="">
        <strong>업로드 파일:</strong>
        <c:choose>
            <c:when test="${notice.fileVOList.size() ne 0}">
                <c:forEach var="file" items="${notice.fileVOList}" varStatus="status">
                    <a href="/dowmFile.do?filePath=${file.filePath}&fileName=${file.realFilename}" download="${file.realFilename}" data-id="${file.id}"
                       data-path="${file.filePath}">${file.realFilename}</a>
                    <c:if test="${not status.last}"><span id="forComaSpan">,</span></c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <span>첨부된 파일이 없습니다.</span>
            </c:otherwise>
        </c:choose>
    </p>

    <input type="button" id="updateBtn" value="수정" onclick="showPasswordModal()"
           style="background-color: #00698C;margin-bottom: 20px">
    <input type="button" id="exitBtn" value="목록" onclick="location.href='/'" style="background-color: darkgreen">
</form>


<!-- 비밀번호 입력 모달 -->
<div id="passwordModal" class="modal" style="display: none;">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">비밀번호 확인</h5>
                <button type="button" class="close" onclick="hidePasswordModal()">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <p>비밀번호를 입력하세요:</p>
                <input type="password" id="passwordInput" class="form-control">
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" onclick="hidePasswordModal()">취소</button>
                <button type="button" class="btn btn-primary" onclick="checkPassword()">확인</button>
            </div>
        </div>
    </div>
</div>


</body>

<script>


    function showPasswordModal() {
        const modal = document.getElementById("passwordModal");
        modal.style.display = "block";
    }

    function hidePasswordModal() {
        const modal = document.getElementById("passwordModal");
        modal.style.display = "none";
    }

    function checkPassword() {
        const password = document.querySelector("#password").value; // 비밀번호 필드 값
        const input = document.querySelector("#passwordInput").value; // 입력값

        // 비밀번호 검증
        if (password === input) {
            makeUpdateForm();
        } else {
            Swal.fire({
                icon: 'fail',
                title: '비밀번호가 일치하지 않습니다.',
                showConfirmButton: false,
                timer: 1500
            }).then(function () {
                location.reload();
            });
        }

        // 모달 닫기
        const modal = document.getElementById("passwordModal");
        modal.style.display = "none";
    }

    // 모달 닫기 버튼
    const closeButtons = document.getElementsByClassName("close");
    for (let i = 0; i < closeButtons.length; i++) {
        closeButtons[i].onclick = function () {
            const modal = document.getElementById("passwordModal");
            modal.style.display = "none";
        };
    }

    //수정폼
    function makeUpdateForm() {
        console.log("이게 되네~")
        const inputs = document.querySelectorAll("input[type=text], textarea");
        const checkbox = document.querySelector("#noticeStatus");
        inputs.forEach(input => input.readOnly = false);
        checkbox.disabled = false;

        let updateBtn = document.querySelector("#updateBtn");
        let exitBtn = document.querySelector("#exitBtn");
        updateBtn.value = "저장하기";
        updateBtn.onclick = saveChange;
        exitBtn.value = "취소";
        exitBtn.onclick = resetChange;

        //파일선택 요소 생성
        let fileDiv = document.querySelector("#fileDiv")
        let plusFile = document.createElement("input");
        plusFile.value = "파일추가하기";
        plusFile.type = "file";
        plusFile.id = "files";
        plusFile.name = "files";
        plusFile.multiple = "multiple";

        //파일선택 라벨
        let fileLabel = document.createElement("label");
        fileLabel.htmlFor = "files";
        fileLabel.innerText = "파일 더 추가하실라우?";

        fileDiv.appendChild(fileLabel);
        fileDiv.appendChild(plusFile);


        let files = document.querySelectorAll("a[download]");
        if (files.length > 0) {
            files.forEach(file => {
                let xElement = document.createElement("span");
                xElement.innerHTML = " &#10006;";
                xElement.style.cursor = "pointer";
                xElement.style.color = "red";
                xElement.addEventListener("click", function () {
                    deleteFile(file, xElement);
                });

                file.parentNode.insertBefore(xElement, file.nextSibling);
            });
        }

    }

    //삭제할 리스트 배열
    let delFileList = [];

    function deleteFile(fileElement, xElement) {
        var commaSpan = xElement.nextElementSibling;
        console.log("nextSibling")
        console.log(commaSpan)
        if (commaSpan && commaSpan.tagName === 'SPAN') {
            commaSpan.remove();
        }
        let id = fileElement.dataset.id;
        let filePath = fileElement.dataset.path;

        let fileVO = {
            id: parseInt(id),
            filePath: filePath
        };
        delFileList.push(fileVO);
        console.log("delFileList:")
        console.log(delFileList);
        fileElement.remove();
        xElement.remove();
    }

    //취소버튼 함수
    function resetChange() {
        const inputs = document.querySelectorAll("input[type=text], textarea");
        const checkbox = document.querySelector("#noticeStatus");
        inputs.forEach(input => input.readOnly = true);
        checkbox.disabled = true;
        window.history.back();
    }

    //수정 내용 저장하기
    function saveChange() {

        console.log("메롱 저장 작동되지롱");
        let formData = new FormData(document.querySelector("#noticeForm"));
        let notice = document.querySelector("#noticeStatus");

        console.log(notice.checked);
        if (!notice.checked) {
            formData.append('noticeStatus', "0");
        }

        let files = document.querySelector('#files').files;
        for (let i = 0; i < files.length; i++) {
            formData.append('files[]', files[i]);
        }

        formData.append('delFileList', JSON.stringify(delFileList));


        // formData.append('delFileList',JSON.stringify(delFileList));


        formData.forEach((value, key) => {
            console.log(key + ": " + value);
        });

        if(validation()){
            let xhr = new XMLHttpRequest();

            xhr.open('POST', 'update.do');
            xhr.setRequestHeader('enctype', 'multipart/form-data');
            xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
            xhr.onreadystatechange = function () {

                if (xhr.status === 200) {
                    Swal.fire({
                        icon: 'success',
                        title: '수정이 완료되었습니다!',
                        showConfirmButton: false,
                        timer: 1500
                    }).then(function () {
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
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@10"></script>

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


    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0, 0, 0, 0.4);
    }

    .modal-dialog {
        position: relative;
        margin: auto;
        max-width: 600px;
    }

    .modal-content {
        background-color: #fefefe;
        margin: auto;
        padding: 20px;
        border: 1px solid #888;
        width: 100%;
    }

    .modal-header, .modal-footer {
        padding: 10px 20px;
        background-color: #f7f7f7;
        border-top: 1px solid #e5e5e5;
    }

    .modal-header h5 {
        margin: 0;
    }

    .modal-body {
        padding: 20px;
    }

    .form-control {
        display: block;
        width: 100%;
        padding: .375rem .75rem;
        font-size: 1rem;
        line-height: 1.5;
        color: #495057;
        background-color: #fff;
        background-clip: padding-box;
        border: 1px solid #ced4da;
        border-radius: .25rem;
        transition: border-color .15s ease-in-out, box-shadow .15s ease-in-out;
    }

    /* 닫기 버튼 */
    .close {
        color: #aaaaaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
    }

    .close:hover,
    .close:focus {
        color: #000;
        text-decoration: none;
        cursor: pointer;
    }

</style>

</html>
