<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>questions</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <style>
        .dropdown {
            position: relative;
            display: inline-block;
        }

        .dropdown-content {
            display: none;
            position: absolute;
            background-color: #f1f1f1;
            min-width: 160px;
            box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
            z-index: 1;
        }

        .dropdown-content a {
            color: black;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        .dropdown:hover .dropdown-content {
            display: block;
        }

        .dropdown:hover .dropbtn {
            background-color: #f1f1f1;
        }
    </style>
</head>
<body>
<div id="mainPanel" class="panel panel-info">
    <div class="panel-heading">
        ${action} Questions Of The Quiz: <b>${quiz.title}</b>
    </div>
    <div class="panel-body" class="row">
        <form id=questions class="col-sm-9 strong"><p style="font-style: oblique"></p><br>
            <table id="questionTable" class="table table-striped ellipsis table-responsive"
                   style="table-layout:fixed;">
                <tr>
                    <td colspan="8" align="center" bgcolor="#d3d3d3">Descriptive Questions</td>
                </tr>
                <tr>
                    <th style="width: 1px"></th>
                    <th style="width: 6px">Title</th>
                    <th colspan="2"  style="width: 12px">Text</th>
                    <th style="width: 5px">DefaultScore</th>
                    <th style="width: 10px">Answer</th>
                    <th style="width: 6px">Options</th>
                    <th style="display: none; width: 6px" class="ifActionIsEdit">Action</th>
                </tr>
                <c:if test="${descriptiveQuestions.size()==0}">No Descriptive Question Is Available</c:if>
                <c:forEach items="${descriptiveQuestions}" var='dQuestion' varStatus="i">
                    <tr>
                        <td>${i.count}</td>
                        <td>${dQuestion.title}</td>
                        <td colspan="2">${dQuestion.text}</td>
                        <td id="dScore${i}">
                            <c:if test="${action=='edit'}">
                                <input type='number' size='4vm' id='${dQuestion.id}' value='${quiz.questionScoreMap.get(dQuestion)}'
                                       onfocusout="editQuestion(${dQuestion.id}, ${quiz.questionScoreMap.get(dQuestion)})">
                            </c:if>
                            <c:if test="${action!='edit'}">
                                ${quiz.questionScoreMap.get(dQuestion)}
                            </c:if>
                        </td>
                        <td>${dQuestion.answer}</td>
                        <td style="display: none" class="ifActionIsEdit">
                            <input type="button" class="btn btn-default btn-xs"
                                   value="delete" onclick="deleteQuestion(${dQuestion.id}, this)">
                        </td>
                    </tr>
                </c:forEach>
                <tr>
                    <td colspan="8" align="center" bgcolor="#d3d3d3">Multiple Choice Questions</td>
                </tr>
                <c:if test="${multipleChoiceQuestions.size()==0}">No Multiple Choice Question Is Available</c:if>
                <c:forEach items="${multipleChoiceQuestions}" var='mQuestion' varStatus="i">
                    <tr>
                        <td>${i.count}</td>
                        <td>${mQuestion.title}</td>
                        <td colspan="2">${mQuestion.text}</td>
                        <td id="mScore${i}">
                            <c:if test="${action=='edit'}">
                                <input type='number' size="small" id='${mQuestion.id}' value='${quiz.questionScoreMap.get(mQuestion)}'
                                       onfocusout="editQuestion(${mQuestion.id},${quiz.questionScoreMap.get(mQuestion)})">
                            </c:if>
                            <c:if test="${action!='edit'}">
                                ${quiz.questionScoreMap.get(mQuestion)}
                            </c:if>
                        </td>
                        <td>${mQuestion.correctAnswer}</td>
                        <td>
                            <div class="dropdown">
                                <button class="dropbtn">options</button>
                                <div class="dropdown-content">
                                    <c:forEach items="${mQuestion.answerOptions}" var="option">
                                        <p>${option}</p>
                                    </c:forEach>
                                </div>
                            </div>
                        </td>
                        <td style="display: none" class="ifActionIsEdit">
                            <input type="button" class="btn btn-default btn-xs"
                                   value="delete" onclick="deleteQuestion(${mQuestion.id}, this)">
                        </td>
                    </tr>
                </c:forEach>
                <tr style="display: none" class="ifActionIsEdit">
                    <td colspan="8" style="align-content: center">
                        <input type="button" onclick="openNewQuestionPage()" value="Insert New Questions">
                    </td>
                </tr>
                <tr>
                    <td colspan="8" style="align-content: center">
                        <input type="button" onclick="window.close()" value="Ok">
                        <input type="button" onclick="cancelAndClose()" value="Cancel">
                    </td>
                </tr>
            </table>
        </form>
        <form id="addQuestionForm" style="display: none" class="col-sm-3">

            <table>
                <tr>
                    <td><input type="radio" id="bank" onclick="showTypeOfBankQuestions()">
                        <label for="bank">Bank</label></td>
                    <td id="bankTd" style="display: none">
                        <input type="radio" id="bankDescriptive"
                               onclick="showDescriptiveQuestionsFromBank()">
                        <label for="bankDescriptive">Descriptive</label><br>
                        <input type="radio" id="bankMultipleChoice"
                               onclick="showMultipleChoiceQuestionsFromBank()">
                        <label for="bankMultipleChoice">Multiple Choice</label></td>
                </tr>
                <tr></tr>
                <tr>
                    <td><input type="radio" id="create" onclick="showTypeOfNewQuestions()">
                        <label for="create">New</label></td>
                    <td id="newTd" style="display: none">
                        <input type="radio" id="newDescriptive"
                               onclick="showDescriptiveQuestionField()">
                        <label for="newDescriptive">Descriptive</label><br>
                        <input type="radio" id="newMultipleChoice"
                               onclick="showMultipleChoiceQuestionField()">
                        <label for="newMultipleChoice">Multiple Choice</label></td>
                </tr>
            </table>
            <br>
            <input type="button" id="addQuestions" value="Add Questions" onclick="addQuestions()" class="btn-info">
            <br>
            <br>
            <table id="bankQuestions">

            </table>
        </form>
    </div>
    <input id="deletedIDs" hidden>
    <input id="editedIDs" hidden>
    <input id="insertedQuestions" hidden>
</div>
<script>

    function openNewQuestionPage() {
        document.getElementById("addQuestionForm").style.display = "block";
    }

    window.onload = function checkAction() {
        if (${action=='edit'} || ${action=='add new'}) {
            let elementsByClassName = document.getElementsByClassName("ifActionIsEdit");
            let i;
            for (i = 0; i < elementsByClassName.length; i++)
                elementsByClassName[i].style.display = "block";
        }
    }

    function deleteQuestion(id, r) {
        let i = r.parentNode.parentNode;
        document.getElementById("questionTable").deleteRow(i.rowIndex);
        let value = document.getElementById("deletedIDs").value;
        value = value + " " + id;
        document.getElementById("deletedIDs").value = value;
    }

    function editQuestion(id, oldValue) {
        let editedScore = document.getElementById(id).value;
        let value = document.getElementById("editedIDs").value;
        if (editedScore !== "" && editedScore !== oldValue) {
            value = value + " " + id;
            document.getElementById("editedIDs").value = value;
        }
    }

    function cancelAndClose() {
        document.getElementById("editedIDs").value = "";
        document.getElementById("deletedIDs").value = "";
        document.getElementById("insertedQuestions").value = "";
        window.close();
    }






















    //TODO bayad bere too ye fale js e joda


    function showTypeOfBankQuestions() {
        let create = document.getElementById("create");
        let bankTd = document.getElementById("bankTd");
        let newTd = document.getElementById("newTd");
        let newDescriptive = document.getElementById("newDescriptive");
        let newMultipleChoice = document.getElementById("newMultipleChoice");
        create.checked = false;
        newDescriptive.checked = false;
        newMultipleChoice.checked = false;
        bankTd.style.display = "block";
        newTd.style.display = "none";
    }

    function showTypeOfNewQuestions() {
        let bank = document.getElementById("bank");
        let bankTd = document.getElementById("bankTd");
        let newTd = document.getElementById("newTd");
        let bankDescriptive = document.getElementById("bankDescriptive");
        let bankMultipleChoice = document.getElementById("bankMultipleChoice");
        bank.checked = false;
        bankDescriptive.checked = false;
        bankMultipleChoice.checked = false;
        newTd.style.display = "block";
        bankTd.style.display = "none";
    }

    function insertMultipleChoiceQuestions(questions) {
        let questionTable = document.getElementById("bankQuestions");
        let j;
        let r = questionTable.rows.length;
        for (j = 0; j < r; j++)
            questionTable.deleteRow(0);
        questionTable.insertRow(0).outerHTML =
            "<tr><td colspan='8' align='center' bgcolor='#d3d3d3'>Multiple Choice Questions</td></tr>" +
            "<tr><th></th><th>Title</th><th colspan='2'>Text</th><th>DefaultScore</th><th>Options</th>" +
            "<th>CorrectAnswer</th></tr>"
        let i;
        for (i = 1; i < Object.keys(questions).length; i++) {
            createNewRow();
        }

        function createNewRow() {
            questionTable.insertRow(0).outerHTML =
                "<tr><td>" + i + "</td><td>" + questions[i]["title"] + "</td>" +
                "<td colspan='2'>" + questions[i]["text"] + "</td>" +
                "<td>" + questions[i]["defaultScore"] + "</td>" +
                "<td>" + questions[i]["correctAnswer"] + "</td></tr>";

            <%--"<td><div class='dropdown'><button class='dropbtn'>options</button>" +--%>
            <%--"<div class='dropdown-content'>"+--%>

            <%--<c:forEach items="${mQuestion.answerOptions}" var="option">--%>
            <%--    <p>${option}</p></c:forEach>     --%>
            <%--"</div></div></td>" +--%>

        }
    }

    function insertDescriptiveQuestions(questions) {
        let questionTable = document.getElementById("bankQuestions");
        let j;
        let r = questionTable.rows.length;
        for (j = 0; j < r; j++)
            questionTable.deleteRow(0);
        questionTable.insertRow(0).outerHTML =
            "<tr><td colspan='8' align='center' bgcolor='#d3d3d3'>Desciptive Questions</td></tr>" +
            "<tr><th></th><th>Title</th><th colspan='2'>Text</th><th>DefaultScore</th>" +
            "<th>Answer</th></tr>"
        let i;
        for (i = 1; i < Object.keys(questions).length; i++) {
            createNewRow();
        }

        function createNewRow() {
            questionTable.insertRow(0).outerHTML =
                "<tr><td>" + i + "</td><td>" + questions[i]["title"] + "</td>" +
                "<td colspan='2'>" + questions[i]["text"] + "</td>" +
                "<td>" + questions[i]["defaultScore"] + "</td>" +
                "<td>" + questions[i]["answer"] + "</td></tr>";

            <%--"<td><div class='dropdown'><button class='dropbtn'>options</button>" +--%>
            <%--"<div class='dropdown-content'>"+--%>

            <%--<c:forEach items="${mQuestion.answerOptions}" var="option">--%>
            <%--    <p>${option}</p></c:forEach>     --%>
            <%--"</div></div></td>" +--%>

        }
    }

    function showMultipleChoiceQuestionsFromBank() {
        document.getElementById("bankDescriptive").checked = false;
        // getQuestionsAjax(insertMultipleChoiceQuestions);
    }

    function showDescriptiveQuestionsFromBank() {
        document.getElementById("bankMultipleChoice").checked = false;
        // getQuestionsAjax(insertDescriptiveQuestions());
    }

    function getQuestionsAjax(cFunction) {
        let httpRequest = new XMLHttpRequest();
        httpRequest.open("get", "getQuestions?category=${quiz.course.category.id}");
        httpRequest.response = "JSON";
        httpRequest.send();
        httpRequest.onreadystatechange = function () {
            if (this.readyState === 4 && this.status !== 200) {
                cFunction(httpRequest.response);
            }
        }
    }


    function showMultipleChoiceQuestionField() {
        document.getElementById("newDescriptive").checked = false;
        let questionTable = document.getElementById("bankQuestions");
        let j;
        let r = questionTable.rows.length;
        for (j = 0; j < r; j++)
            questionTable.deleteRow(0);
        questionTable.insertRow(0).outerHTML =
            "<tr><td colspan='8' align='center' bgcolor='#d3d3d3'>Define A Multiple Choice Question</td></tr>" +
            "<tr><td><input type='text' placeholder='Title'></td></tr>" +
            "<td colspan='2'><input type='text' placeholder='Text'></td></tr>" +
            "<td><input type='number' placeholder='DefaultScore'></td></tr>" +
            "<td>Options</td></tr>" +
            "<tr><td><input type='text' placeholder='CorrectAnswer'></td></tr>"
    }

    function showDescriptiveQuestionField() {
        document.getElementById("newMultipleChoice").checked = false;
        let questionTable = document.getElementById("bankQuestions");
        let j;
        let r = questionTable.rows.length;
        for (j = 0; j < r; j++)
            questionTable.deleteRow(0);
        questionTable.insertRow(0).outerHTML =
            "<tr><td colspan='8' align='center' bgcolor='#d3d3d3'>Define A Descriptive Question</td></tr>" +
            "<tr><td><input type='text' placeholder='Title'></td></tr>" +
            "<td colspan='2'><input type='text' placeholder='Text'></td></tr>" +
            "<td><input type='number' placeholder='DefaultScore'></td></tr>" +
            "<tr><td><input type='text' placeholder='Answer'></td></tr>"
    }

    function addQuestions() {

    }


</script>
</body>
</html>
