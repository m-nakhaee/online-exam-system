<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Welcome</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <style>
        body {
            background-image: url('/images/bg.jpg');
            background-repeat: no-repeat;
            background-attachment: fixed;
            background-size: cover;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-sm bg-info navbar-dark">
    <div class="container-fluid">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">Online School</a>
        </div>
        <ul class="nav navbar-nav navbar-right">
            <c:if test="${user != null}">
                <li class="active"><a href="/userPanel">your panel</a></li>
                <li><a href="/logout"><span class="glyphicon glyphicon-log-out"></span>Logout</a></li>
            </c:if>
            <c:if test="${user == null}">
                <li><a href="/loginForm"><span class="glyphicon glyphicon-log-in"></span>Login</a></li>
            </c:if>
            <li><a href="/registerForm"><span class="glyphicon glyphicon-user"></span>signUp</a></li>
        </ul>
    </div>
</nav>
<script>
    let f = {
        s: "s",
        id: 1
    }

    let g = {
        s: "s",
        d: [{id: 1}, {name: "ali"}]
    }
    console.log(f);
    console.log(JSON.stringify(f));
    console.log(g);
    console.log(JSON.stringify(g));

</script>
</body>
</html>