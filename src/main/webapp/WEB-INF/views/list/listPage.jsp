<%--
  Created by IntelliJ IDEA.
  User: chs
  Date: 2023/05/11
  Time: 2:39 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<header>
    <h1>공지사항</h1>
    <div class="notice">
        <h2>대표 공지글</h2>
        <div class="notice-content">
            <c:choose>
                <c:when test="${mainNotice ne null}">
                    <p><strong>공지번호:</strong> ${mainNotice.nbVO.boardId}</p>
                    <p><strong>제목:</strong> ${mainNotice.nbVO.title}</p>
                    <p><strong>작성자:</strong> ${mainNotice.nbVO.writer}</p>
                    <p><strong>작성일시:</strong> ${mainNotice.nbVO.date}</p>
                    <p><strong>내용:</strong> ${mainNotice.nbVO.content}</p>
                    <p><strong>업로드 파일:</strong>
                        <c:choose>
                            <c:when test="${mainNotice.fileVOList.size() ne 0}">
                                <c:forEach var="file" items="${mainNotice.fileVOList}" varStatus="status">
                                    <a href="/dowmFile.do?filePath=${file.filePath}&fileName=${file.realFilename}"  download="${file.realFilename}" data-path="${file.filePath}" id="#">${file.realFilename}</a>
<%--                                    <a href="file:${file.filePath}"  download="${file.realFilename}" data-path="${file.filePath}" id="#">${file.realFilename}</a>--%>
                                    <c:if test="${not status.last}"><span id="forComaSpan">,</span></c:if>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                첨부된 파일이 없습니다.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:when>
                <c:otherwise>
                    <p>설정된 대표글이 없습니다. 빨랑 설정해주세요</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</header>
<main>
    <div class="buttons registerBtn">
        <a href="/registerPage.do" class="button">공지사항 등록</a>
    </div>
    <table>
        <thead>
        <tr>
            <th>공지번호</th>
            <th>제목</th>
            <th>작성자</th>
            <th>작성일시</th>
            <th>조회수</th>
            <th>업로드 파일 개수</th>
        </tr>
        </thead>
        <tbody id="tbodyId">
        </tbody>
    </table>
    <br>
    <div class="pagination" id="pagination"></div>

</main>
</body>
<script>
    window.onload = function () {
        getTableInfo();

    };


    function getTableInfo(currentPage){
        let xhr = new XMLHttpRequest();
        let url = 'getListPage.do';
        if (currentPage){
            url += '?currentPage=' + currentPage;
        }
        xhr.open('GET', url, true);
        xhr.send();

        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // 응답을 처리하는 코드 작성
                let paging = JSON.parse(xhr.response);
                console.log(paging);
                renderNoticeTable(paging)
            }
        }
    }



    function renderNoticeTable(paging) {
        console.log("작동하니?");
        let tbody = document.getElementById("tbodyId");
        tbody.innerHTML = ""; // tbody 초기화
        console.log(paging);
        console.log(paging.List.content);
        console.log(paging.List.currentPage);

        let startPage = paging.List.startPage;
        let endPage = paging.List.endPage;
        let currentPage = paging.List.currentPage;
        let content = paging.List.content;
        let totalPages = paging.List.totalPages;

        //리스트 페이지 구성하기
        for (let notice of content) {
            let tr = document.createElement("tr");
            tr.classList.add("clickable");

            let tdBoardId = document.createElement("td");
            tdBoardId.textContent = notice.boardId;
            tr.appendChild(tdBoardId);

            let tdTitle = document.createElement("td");
            // tdTitle.textContent = notice.title;
            tdTitle.innerHTML = notice.title;
            tr.appendChild(tdTitle);

            let tdWriter = document.createElement("td");
            tdWriter.textContent = notice.writer;
            tr.appendChild(tdWriter);

            let tdDate = document.createElement("td");
            tdDate.textContent = new Date(notice.date).toLocaleDateString();
            tr.appendChild(tdDate);

            let tdViews = document.createElement("td");
            tdViews.textContent = notice.views;
            tr.appendChild(tdViews);

            let tdFileNum = document.createElement("td");
            tdFileNum.textContent = notice.fileNum;
            tr.appendChild(tdFileNum);

            // 클릭 이벤트 리스너 등록
            tr.addEventListener("click", function () {
                // 새로운 URL 생성
                let url = "detailPage.do?boardId=" + notice.boardId;
                // 새로운 페이지로 이동
                window.location.href = url;
            });

            tbody.appendChild(tr);
        }

        //페이징 처리하기
        let pagination = document.querySelector("#pagination");
        pagination.innerHTML = "";

        //이전버튼 만들기
        let prevPageBtn = document.createElement("a");
        prevPageBtn.textContent = "<< 이전";
        prevPageBtn.classList.add("previous");
        if(startPage - 1 === 0 ){   // 페이지 넘버가 1이면 클릭안되게
            prevPageBtn.classList.add("disabled");
            prevPageBtn.setAttribute("disabled", true);
        }else{
            prevPageBtn.classList.remove("disabled");
            prevPageBtn.addEventListener("click", function() {
                console.log("커렌트페이지 보내는값:", startPage - 1)
                getTableInfo(startPage - 1);
            });
        }
        pagination.appendChild(prevPageBtn);

        //페이징 번호 생성
        for(let num = startPage; num <= endPage; num++){
            let pageBtn = document.createElement("a");
            pageBtn.textContent = num;
            pageBtn.classList.add("page");
            pageBtn.addEventListener("click", function() {
                console.log("커렌트페이지 보내는값:", num)
                getTableInfo(num);
            });

            //현재 페이지 표시해주기
            if(num === currentPage){
                pageBtn.classList.add("active");
            }

            pagination.appendChild(pageBtn);
        }
        //다음버튼 만들
        let nextPageBtn = document.createElement("a");
        nextPageBtn.textContent = "다음 >>"
        nextPageBtn.classList.add("next");

        if(endPage + 1 > totalPages){ //다음페이지가 없을때
            nextPageBtn.classList.add("disabled");
            nextPageBtn.setAttribute("disabled", true);
        }else{
            nextPageBtn.classList.remove("disabled");
            nextPageBtn.addEventListener("click", function() {
                console.log("커렌트페이지 보내는값:", endPage+1)
                getTableInfo(endPage+1);
            });
        }

        pagination.appendChild(nextPageBtn);

    }

</script>


<style>
    /* 전체 페이지 스타일 */
    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        font-size: 16px;
        line-height: 1.5;
        color: #333;
    }

    /* 헤더 스타일 */
    header {
        background-color: #f8f8f8;
        border-bottom: 1px solid #ddd;
        padding: 20px 40px;
    }

    h1 {
        margin: 0;
        font-size: 2.5rem;
        font-weight: bold;
    }

    .notice {
        margin-top: 30px;
    }

    .notice h2 {
        margin: 0;
        font-size: 1.5rem;
        font-weight: bold;
        color: #555;
    }

    .notice-content {
        margin-top: 20px;
        padding: 20px;
        border: 1px solid #ddd;
        background-color: #fff;
        box-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    }

    .notice-content p {
        margin: 0;
        padding: 5px 0;
        line-height: 1.5;
    }

    .notice-content p strong {
        display: inline-block;
        width: 120px;
        font-weight: bold;
    }

    /* 메인 스타일 */
    main {
        max-width: 960px;
        margin: 0 auto;
        padding: 40px;
    }

    /* 목록 테이블 스타일 */
    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0 10px;
        margin-top: 30px;
        border: 1px solid #ddd;
        background-color: #fff;
        box-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
    }

    table th {
        padding: 10px;
        text-align: center;
        background-color: #eee;
        border-right: 1px solid #ddd;
        font-weight: bold;
        color: #333;
    }

    table th:last-child {
        border-right: none;
    }

    table td {
        padding: 10px;
        text-align: center;
        border-right: 1px solid #ddd;
        border-bottom: 1px solid #ddd;
    }

    table td:last-child {
        border-right: none;
    }

    table td  {
        color: #333;
        text-decoration: none;
    }

    table tr :hover {
        color: #ddd;
        text-decoration: underline;
        cursor: pointer;
    }

    .buttons {
        text-align: center;
        margin-top: 30px;
    }

    .button {
        display: inline-block;
        padding: 10px 20px;
        background-color: #00bfff;
        color: #fff;
        text-align: center;
        text-decoration: none;
        border-radius: 4px;
        transition: all 0.2s ease-in-out;
    }

    .button:hover {
        background-color: #fff;
        color: #00bfff;
        border: 2px solid #00bfff;
    }


    .pagination {
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .pagination a {
        color: #333;
        padding: 8px 16px;
        text-decoration: none;
    }

    .pagination a:hover:not(.active) {
        background-color: #ddd;
    }

    .pagination .active {
        background-color: #4CAF50;
        color: white;
    }

    .pagination .previous, .pagination .next {
        font-weight: bold;
    }

    .pagination .disabled {
        pointer-events: none;
        opacity: 0.6;
        cursor: not-allowed;
    }
    .registerBtn {
        float: right;
        margin-bottom: 10px;
        background-color: #555555;
    }

</style>


</html>