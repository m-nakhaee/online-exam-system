<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<html lang="en" class="h-100">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Login</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
</head>
<body class="h-100">
<nav class="navbar navbar-expand-sm bg-info navbar-dark">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Online School</a>
        </div>
        <ul class="nav navbar-nav">
            <li class="active"><a href="/">Home</a></li>
        </ul>
        <ul class="nav navbar-nav navbar-right">
            <c:if test="${user.id != null}">
                <li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span>Logout</a></li>
            </c:if></ul>
    </div>
</nav>
<div class="container h-100">
    <div class="row h-100 justify-content-center align-items-center">
        <div class="col-10 col-md-8 col-lg-6">
            <form id="loginForm" onsubmit="return false">
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" placeholder="email" required/>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control" id="password" placeholder="Password" required/>
                </div>

                <input type="submit" value="Login" onclick="loginIfUserAvailable()" class="btn btn-info">
            </form>
        </div>
    </div>
</div>

<script>

    function loginIfUserAvailable() {
        let request = new XMLHttpRequest;
        request.open("Post", "login", true);
        request.setRequestHeader("Content-type", "application/json");
        request.dataType = "json";
        let user;
        user = {
            "email": document.getElementById("email").value,
            "password": document.getElementById("password").value,
        };
        let userString = JSON.stringify(user);
        request.send(userString);
        getResponse(request);
    }

    function getResponse(request) {
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200)
                window.location.replace("userPanel");
            if (this.readyState === 4 && this.status !== 200)
                window.alert(this.response);
        }
    }

</script>
</body>
</html>