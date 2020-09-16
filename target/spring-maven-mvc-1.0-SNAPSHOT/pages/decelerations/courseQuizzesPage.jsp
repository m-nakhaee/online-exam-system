<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>quizzes of the course</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body>
<nav class="navbar navbar-expand-sm bg-info navbar-dark">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Online School</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="/">Home</a></li>
            <li class="active"><a href="javascript:history.go(-1)">your panel</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
        </ul>
    </div>
</nav>
<div id="mainPanel" class="panel panel-info">
    <div class="panel-heading">
        Quizzes Of The Course: <b>${course.title}</b>
    </div>
    <div class="panel-body" class="row">
        <form id=quizzes class="col-sm-10 strong"><p style="font-style: oblique"></p><br>
            <table id="quizTable" class="table table-striped ellipsis" style="table-layout: fixed; lay">
                <tr>
                    <input type="button" onclick="goToAddQuizPage()" value="Add New Quiz">
                </tr>
                <tr>
                    <th style="width: 1px"></th>
                    <th style="width: 6px">Title</th>
                    <th style="width: 12px">Description</th>
                    <th style="width: 10px">Time(min)</th>
                    <th style="width: 12px"> Start Date</th>
                    <th style="width: 12px"> End Date</th>
                    <th style="width: 12px">Created By</th>
                    <th style="width: 7px">State</th>
                    <th style="width: 12px">Questions</th>
                    <th style="width: 5px">Action</th>
                </tr>
                <c:forEach items="${course.quizSet}" var='quiz' varStatus="i">
                    <tr>
                        <td>${i.count}</td>
                        <td id="title${i.index}">${quiz.title}</td>
                        <td id="description${i.index}">${quiz.description}</td>
                        <td id="time${i.index}">${quiz.duration}</td>
                        <td id="startDate${i.index}">${quiz.startDate}</td>
                        <td id="endDate${i.index}">${quiz.endDate}</td>
                        <td id="teacher${i.index}">
                            <c:if test="${quiz.teacher.id == teacherId}">YOU</c:if>
                            <c:if test="${quiz.teacher.id != teacherId}">
                                ${quiz.teacher.firstName} ${quiz.teacher.lastName}</c:if>
                        </td>
                        <td id="state${i.index}">${quiz.state.toString()}</td>
                        <td id="questionSet${i.index}">
                            <a href="#" onclick="goToQuestionPage(${i.index}, '')">Show</a>
                        </td>
                        <td>
                            <c:if test="${quiz.teacher.id == teacherId}">
                                <input type="button" class="btn btn-default btn-xs" id="edit_button${i.index}"
                                       value="edit" onclick="makeRowEditable(${i.index})">
                                <input type="button" class="btn btn-default btn-xs" id="save_button${i.index}"
                                       style="display: none" value="save" onclick="editQuiz(${i.index})">
                                <input type="button" class="btn btn-default btn-xs" id="cancel_button${i.index}"
                                       style="display: none" value="cancel" onclick="cancelEdit(${i.index})">
                                <input type="button" class="btn btn-default btn-xs" id="stop_button${i.index}"
                                       value="stop" onclick="stopQuiz(${i.index})">
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </form>
    </div>
</div>
<script>
    function goToAddQuizPage() {
        window.location.replace("addQuizForm?courseId=${course.id}&teacherId=${teacherId}");
    }

    let idOfQuizzes = [
        <c:forEach items="${course.quizSet}" var="quiz">
        '<c:out value="${quiz.id}" />',
        </c:forEach>
    ];
    let titleOfQuizzes = [
        <c:forEach items="${course.quizSet}" var="quiz">
        '<c:out value="${quiz.title}" />',
        </c:forEach>
    ];

    let editedQuestions = [];

    function goToQuestionPage(i, action) {
        let id = idOfQuizzes[i];
        let title = titleOfQuizzes[i];
        let url = "/quizQuestions?quizId=" + id + "&action=" + action;
        let newWindow = window.open(url, 'popUpWindow', 'height=600,width=1200,left=50,resizable=no,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no, status=yes');
        newWindow.onbeforeunload = function () {
            let editElement = newWindow.document.getElementById("editedIDs").value;
            let editedIds = editElement.split(" ");
            let deleteElement = newWindow.document.getElementById("deletedIDs").value;
            let deleteIds = deleteElement.split(" ");
            let insertedElement = newWindow.document.getElementById("insertedQuestions").value;
            /*this takes arrays of jsons in string*/
            let insertedQuestions = insertedElement.split("&");

            setEditedQuestions();

            function setEditedQuestions() {
                let i;
                for (i = 1; i < editedIds.length; i++) {
                    let score = newWindow.document.getElementById(editedIds[i]).value;
                    editedQuestions.push({id: editedIds[i], defaultScore: score});
                }
                let j;
                for (j = 1; j < deleteIds.length; j++) {
                    editedQuestions.push({id: deleteIds[j]});
                }
                let x;
                for (x = 1; x < insertedQuestions.length; x++) {
                    let jsonQuestion = JSON.parse(insertedQuestions[x]);
                    editedQuestions.push(jsonQuestion);
                }
            }
        }
    }

    let quizForSend;

    function createNullQuiz() {
        return {
            id: null,
            title: null,
            description: null,
            time: null,
            startDate: null,
            endDate: null,
            questionSet: null,
            state: null
        }
    }

    function createStoppedQuiz(i) {
        quizForSend = createNullQuiz();
        quizForSend.id = idOfQuizzes[i];
        quizForSend.state = "stopped";
    }

    function createUpdatedQuiz(i) {
        quizForSend = createNullQuiz();
        let editedQuiz = getEditedQuiz();
        setQuizForSend();

        function getEditedQuiz() {
            return {
                title: document.getElementById("editedTitle" + i).value,
                description: document.getElementById("editedDescription" + i).value,
                time: document.getElementById("editedTime" + i).value,
                startDate: document.getElementById("editedStartDate" + i).value,
                endDate: document.getElementById("editedEndDate" + i).value,
                state: document.getElementById("editedState" + i).value,
                questionSet: editedQuestions
            };
        }

        function setQuizForSend() {
            quizForSend.id = idOfQuizzes[i];
            //TODO getUpdated questionSet
            if (!(editedQuiz.title === "" || (editedQuiz.title === oldValues.title)))
                quizForSend.title = editedQuiz.title;
            if (!(editedQuiz.description === "" || (editedQuiz.description === oldValues.description)))
                quizForSend.description = editedQuiz.description;
            if (!(editedQuiz.time === "" || (editedQuiz.time === oldValues.time)))
                quizForSend.time = editedQuiz.time;
            if (!(editedQuiz.startDate === "" || (editedQuiz.startDate === oldValues.startDate)))
                quizForSend.startDate = editedQuiz.startDate;
            if (!(editedQuiz.endDate === "" || (editedQuiz.endDate === oldValues.endDate)))
                quizForSend.endDate = editedQuiz.endDate;
            if (!(editedQuiz.state === "" || (editedQuiz.state === oldValues.state)))
                quizForSend.state = editedQuiz.state;
            quizForSend.questionSet = editedQuiz.questionSet;
            console.log(quizForSend.questionSet);
        }
    }

    function stopQuiz(id) {
        let state = document.getElementById("state" + id).innerText;
        if (state === "available") {
            createStoppedQuiz(id);
            let httpRequest = ajaxSendQuiz("updateQuiz");
            getResponse(httpRequest, completeStopFunction, id);
        }
    }

    let oldElements;
    let oldValues

    function makeRowEditable(i) {
        makeEditButtonsDisable()
        oldElements = keepElements();
        oldValues = getValueFromElements();
        makeElementsEditable();
        setDisplayOfButtons();

        function keepElements() {
            return {
                title: document.getElementById("title" + i),
                description: document.getElementById("description" + i),
                time: document.getElementById("time" + i),
                startDate: document.getElementById("startDate" + i),
                endDate: document.getElementById("endDate" + i),
                state: document.getElementById("state" + i),
                questionSet: document.getElementById("questionSet" + i),
            }
        }

        function getValueFromElements() {
            return {
                title: oldElements.title.innerHTML,
                description: oldElements.description.innerHTML,
                time: oldElements.time.innerHTML,
                startDate: oldElements.startDate.innerHTML,
                endDate: oldElements.endDate.innerHTML,
                state: oldElements.state.innerHTML,
                questionSet: oldElements.questionSet.innerHTML
            }
        }

        function makeElementsEditable() {
            oldElements.title.innerHTML = "<input type='text' size='4' id='editedTitle" + i + "' value='" + oldValues.title + "'>";
            oldElements.description.innerHTML = "<input type='text' size='10' id='editedDescription" + i + "' value='" + oldValues.description + "'>";
            oldElements.time.innerHTML = "<input type='number' size='8' id='editedTime" + i + "' value='" + oldValues.time + "'>";
            oldElements.startDate.innerHTML = "<input type='date' size='10' id='editedStartDate" + i + "' value='" + oldValues.startDate + "'>";
            oldElements.endDate.innerHTML = "<input type='date' size='10' id='editedEndDate" + i + "' value='" + oldValues.endDate + "'>";
            oldElements.state.innerHTML = "<select id='editedState" + i + "'>" +
                "<c:forEach items="${quizStates}" var="state">" +
                "<option>${state.toString()}</option>" +
                "</c:forEach>" +
                "</select>";
            oldElements.questionSet.innerHTML = "<a href='#' onclick='goToQuestionPage(" + i + ", \"edit\")'>Edit</a>"
        }

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "none";
            document.getElementById("save_button" + i).style.display = "block";
            document.getElementById("cancel_button" + i).style.display = "block";
        }
    }

    function editQuiz(i) {
        createUpdatedQuiz(i);
        let httpRequest = ajaxSendQuiz("updateQuiz");
        getResponse(httpRequest, completeEditFunction, i);
        setDisplayOfButtons(i);

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "block";
            document.getElementById("save_button" + i).style.display = "none";
            document.getElementById("cancel_button" + i).style.display = "none";
        }
    }

    function cancelEdit(i) {
        let id = idOfQuizzes[i];
        oldElements.title.innerHTML = oldValues.title;
        oldElements.description.innerHTML = oldValues.description;
        oldElements.time.innerHTML = oldValues.time;
        oldElements.startDate.innerHTML = oldValues.startDate;
        oldElements.endDate.innerHTML = oldValues.endDate;
        oldElements.state.innerHTML = oldValues.state;
        oldElements.questionSet.innerHTML = "<a href=\"#\" onclick=\"goToQuestionPage(" + id + ", '')\">Show</a>";
        ;
        setDisplayOfButtons();
        makeEditButtonsEnable();

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "block";
            document.getElementById("save_button" + i).style.display = "none";
            document.getElementById("cancel_button" + i).style.display = "none";
        }
    }

    function makeEditButtonsDisable() {
        let i;
        for (i = 0; i < ${course.quizSet.size()}; i++) {
            let editButton = document.getElementById("edit_button" + i);
            let stopButton = document.getElementById("stop_button" + i);
            if (editButton != null)
                editButton.disabled = true;
            if (stopButton != null)
                stopButton.disabled = true;
        }
    }

    function makeEditButtonsEnable() {
        let i;
        for (i = 0; i < ${course.quizSet.size()}; i++) {
            let stopButton = document.getElementById("stop_button" + i);
            let element = document.getElementById("edit_button" + i);
            if (element != null)
                element.disabled = false;
            if (stopButton != null)
                stopButton.disabled = false;
        }
    }

    function ajaxSendQuiz(url) {
        let httpRequest = new XMLHttpRequest();
        httpRequest.open("Post", url, true);
        httpRequest.setRequestHeader("Content-type", "application/json");
        httpRequest.dataType = "json";
        let quiz = quizForSend;
        let quizString = JSON.stringify(quiz);
        httpRequest.send(quizString);
        return httpRequest;
    }

    function getResponse(request, resultFunction, id) {
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                resultFunction(id, this.response);
            }
            if (this.readyState === 4 && this.status !== 200) {
                window.alert("a problem has occurred. try again later")
            }
        }
    }

    function completeStopFunction(id) {
        document.getElementById("state" + id).innerText = "stopped";
        window.alert("quiz stopped successfully!")
    }

    function completeEditFunction(id) {
        let i = idOfQuizzes[id];

        if (quizForSend.title == null)
            oldElements.title.innerHTML = oldValues.title;
        else
            oldElements.title.innerHTML = quizForSend.time;
        if (quizForSend.description == null)
            oldElements.description.innerHTML = oldValues.description;
        else
            oldElements.description.innerHTML = quizForSend.description;
        if (quizForSend.time == null)
            oldElements.time.innerHTML = oldValues.time;
        else
            oldElements.time.innerHTML = quizForSend.time;
        if (quizForSend.startDate == null)
            oldElements.startDate.innerHTML = oldValues.startDate;
        else
            oldElements.startDate.innerHTML = quizForSend.startDate;
        if (quizForSend.endDate == null)
            oldElements.endDate.innerHTML = oldValues.endDate;
        else
            oldElements.endDate.innerHTML = quizForSend.endDate;
        if (quizForSend.state == null)
            oldElements.state.innerHTML = oldValues.state;
        else
            oldElements.state.innerHTML = quizForSend.state;
        oldElements.questionSet.innerHTML = "<a href=\"#\" onclick=\"goToQuestionPage(" + i + ", '')\">Show</a>";
        window.alert("updated successfully!")
        makeEditButtonsEnable();
    }

</script>
</body>
</html>
