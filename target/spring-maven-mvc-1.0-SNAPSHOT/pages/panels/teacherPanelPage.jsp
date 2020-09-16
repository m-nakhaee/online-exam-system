<%--
  Created by IntelliJ IDEA.
  User: marzieh
  Date: 8/19/2020
  Time: 4:04 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>teacher panel</title>
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
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span> Logout</a></li>
        </ul>
    </div>
</nav>
<div id="mainPanel" class="panel panel-info">
    <div class="panel-heading">
        <img src="file:\C:\Users\Marzieh\IdeaProjects\finalProject\src\main\webapp\pages\panels\me.JPG" style="width:100px;height:100px">
        ${user.firstName} ${user.lastName}
    </div>
    <div class="panel-body" class="row">
        <form id=courses class="col-sm-10 strong"><p style="font-style: oblique"></p><br>
            <table id="courseTable" class="table table-striped ellipsis table-responsive" style="table-layout: fixed;">
                <tr>
                    <th style="width: 3vw"></th>
                    <th>Course Title</th>
                    <th>Course Category</th>
                    <th>Student List</th>
                    <th>Quiz List</th>
                </tr>
                <c:forEach items='${user.courseSet}' var='course' varStatus="i">
                    <tr>
                        <td>${i.count}</td>
                        <td>${course.title}</td>
                        <td>${course.category.name}</td>
                        <td><a href="courseStudents?courseTitle=${course.title}&courseId=${course.id}">Show
                        </a></td>
                        <td><a href="courseQuizzes?courseId=${course.id}&teacherId=${user.id}">Show</a>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </form>
    </div>
</div>
</body>
</html>
