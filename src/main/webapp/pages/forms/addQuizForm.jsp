<%--
  Created by IntelliJ IDEA.
  User: Marzieh
  Date: 9/11/2020
  Time: 3:36 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>add quiz</title>
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
    </div>
    <div class="panel-body" class="row">
        <form id="addQuizForm" class="col-sm-5">
            <div class="container h-100">
                <div class="row h-100 justify-content-center align-items-center">
                    <div class="col-10 col-md-8 col-lg-4">
                        <div class="form-group">
                            <label for="quizTitle">Title:</label>
                            <input type="text" class="form-control" id="quizTitle" placeholder="title" required>
                        </div>
                        <div class="form-group">
                            <label for="description">Description:</label>
                            <input type="text" class="form-control" id="description" placeholder="description" required>
                        </div>
                        <div class="form-group">
                            <label for="duration">Duration:</label>
                            <input type="number" class="form-control" id="duration" placeholder="duration" required>
                        </div>
                        <div class="form-group">
                            <label for="startDate">Start Date:</label>
                            <input type="Date" class="form-control" id="startDate" required>
                        </div>
                        <div class="form-group">
                            <label for="endDate">End Date:</label>
                            <input type="Date" class="form-control" id="endDate" aria-errormessage="dateError" required>
                            <small id="dateError" style="display: none; color: red">end date is not correct</small>
                        </div>
                        <div class="form-group">
                            <label for="questionSet">Question Set:</label>
                            <input type="button" value="Create" onclick="showCreateNewQuestionForm()"
                                   class="form-control"
                                   id="questionSet" aria-errormessage="questionSetError" required>
                            <small id="questionSetError" style="display: none; color: red">create at least one question
                                for this quiz</small>
                        </div>
                        <input type="submit" value="Submit" onclick="addQuiz()" class="btn btn-info">
                    </div>
                </div>
            </div>
        </form>
        <form id="addQuestionForm" style="display: none" class="col-sm-7">
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
            <div id="newDescriptiveQuestion" style="display: none" class="container h-100">
                <div class="row h-100 justify-content-center align-items-center">
                    <div class="col-10 col-md-8 col-lg-4">
                        <div class="form-group">
                            <label for="questionTitle">Title:</label>
                            <input type="text" class="form-control" id="questionTitle" placeholder="title" required>
                        </div>
                        <div class="form-group">
                            <label for="text">Text:</label>
                            <input type="text" class="form-control" id="text" placeholder="text" required>
                        </div>
                        <div class="form-group">
                            <label for="answer">Answer:</label>
                            <input type="text" class="form-control" id="answer" placeholder="duration" required>
                        </div>
                        <input type="checkbox" id="checkForQuestionBank">
                        <label for="checkForQuestionBank">save to question bank</label>
                        <input type="submit" value="add this to the quiz" onclick="addQuestion(${typesOfQuestion[0].toString()})" class="btn btn-info">
                    </div>
                </div>
            </div>


        </form>

    </div>
</div>

<script>

    let questionSet = [];

    function checkConditions() {
        let startDate = new Date(document.getElementById("startDate").value);
        let endDate = new Date(document.getElementById("endDate").value);
        let today = new Date();
        let condition = true;
        if (startDate.getTime() > endDate.getTime()) {
            document.getElementById("dateError").style.display = "block";
            condition = false;
        }
        if (today.getTime() < endDate.getTime()) {
            document.getElementById("dateError").style.display = "block";
            condition = false;
        }
        if (questionSet.length == 0) {
            document.getElementById("questionSetError").style.display = "block";
            condition = false;
        }
        return condition;
    }

    function addQuiz() {
        document.getElementById("dateError").style.display = "none";
        document.getElementById("questionSetError").style.display = "none";
        if (checkConditions())
            sendNewQuizToServer();
    }

    function sendNewQuizToServer() {
        let newQuiz = createNewQuiz();
        ajaxSend("saveNewQuiz", newQuiz);
    }

    function createNewQuiz() {
        return {
            title: document.getElementById("title").value,
            description: document.getElementById("description").value,
            time: document.getElementById("duration").value,
            startDate: document.getElementById("startDate").value,
            endDate: document.getElementById("endDate").value,
            teacher: {
                id: ${teacherId}
            },
            course: {
                id: ${courseId}
            },
            questionSet: questionSet,
            state: ${availableState}
        }
    }

    function ajaxSend(url, forSend) {
        let httpRequest = new XMLHttpRequest();
        httpRequest.open("Post", url, true);
        httpRequest.setRequestHeader("Content-type", "application/json");
        httpRequest.dataType = "json";
        let forSendString = JSON.stringify(forSend);
        httpRequest.send(forSendString);
        httpRequest.onreadystatechange = function () {
            if (this.readyState === 4)
                window.alert(this.response.body)
        }
    }

    function showCreateNewQuestionForm() {
        document.getElementById("addQuestionForm").style.display = "block";
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


        heree


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

    function addQuestion(type) {
        let title = document.getElementById("questionTitle");
        let text = document.getElementById("text");
        let answer = document.getElementById("answer");
        let newQuestion = {
            title: title.value,
            text: text.value,
            answer: answer.value,
            type: type,
            category: {
                id : ${categoryId}
            }
        }
        questionSet.push(newQuestion);
        ajaxSend("saveNewQuestion", newQuestion)
    }


</script>
</body>
</html>
