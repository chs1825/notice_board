<%--
  Created by IntelliJ IDEA.
  User: chs
  Date: 2023/05/19
  Time: 6:19 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

<input type="text" id="titleInput">
<input type="button" value="커스텀필터 테스트하기" id="sendDataBtn">

<div id="diva"></div>

</body>

<script>

    let sendDataBtn = document.querySelector("#sendDataBtn");
    sendDataBtn.addEventListener('click', function () {
        let title = document.querySelector("#titleInput").value;

        let xhr = new XMLHttpRequest();
        xhr.open('POST', 'customFilterTest.do');
        xhr.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xhr.setRequestHeader('Content-Type', 'application/json');
        xhr.onreadystatechange = function (){
            if(xhr.status === 200){
                // let res = JSON.parse(xhr.response);
                console.log(xhr.response);
                // alert("da");
                let div = document.querySelector('#diva')
                let spanTag = document.createElement("SPAN");
                spanTag.innerHTML = xhr.response;
                div.appendChild(spanTag);
            }
        }




        // xhr.send(JSON.stringify(nbVO));
        // xhr.send(JSON.stringify(title));
        xhr.send(title);




    });


</script>
</html>
