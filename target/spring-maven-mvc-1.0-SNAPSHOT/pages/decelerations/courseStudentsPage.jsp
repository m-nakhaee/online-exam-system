<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>students of the course</title>
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
        Students Of The Course: <b>${courseTitle}</b>
    </div>
    <div class="panel-body" class="row">
        <form id=courses class="col-sm-10 strong"><p style="font-style: oblique"></p><br>
            <table id="courseTable" class="table table-striped ellipsis table-responsive" style="table-layout: fixed;">
                <tr>
                    <th style="width: 3vw"></th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>List Of Courses</th>
                </tr>
                <c:if test="${courseStudents.size() > 0}">
                    <c:forEach var='i' begin="0" end="${courseStudents.size()-1}">
                        <tr>
                            <td>${i+1}</td>
                            <td>${courseStudents.get(i).firstName}</td>
                            <td>${courseStudents.get(i).lastName}</td>
                            <td>${courseStudents.get(i).email}</td>
                            <td>
                                <ul><c:forEach items="${courseStudents.get(i).courseSet}" var="course">
                                    <li>${course.title}</li>
                                </c:forEach></ul>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
            </table>
            <input type="button" value="ok" onclick="javascript:window.close()">
        </form>
    </div>
</div>
</body>
</html>
