<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>

<html lang="en" class="h-100">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Registration</title>
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
            <form id="registerForm" onsubmit="return false">
                <div class="form-group">
                    <label for="firstName">First Name:</label>
                    <input type="text" class="form-control" id="firstName" aria-errormessage="firstNameError"
                           placeholder="first name" required>
                    <small id="firstNameError" style="display: none; color: red">first name is not correct</small>
                </div>
                <div class="form-group">
                    <label for="lastName">Last Name:</label>
                    <input type="text" class="form-control" id="lastName" aria-errormessage="lastNameError"
                           placeholder="last name" required>
                    <small id="lastNameError" style="display: none; color: red">last name is not correct</small>
                </div>
                <div class="form-group">
                    <label for="email">Email:</label>
                    <input type="email" class="form-control" id="email" aria-errormessage="emailError"
                           placeholder="email" required>
                    <small id="emailError" style="display: none; color: red">wrong email</small>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" class="form-control"
                           id="password" aria-describedby="passwordHelp" aria-errormessage="passwordError"
                           placeholder="Password" required>
                    <small id="passwordHelp" class="form-text text-muted">at least 8 characters contained digit and
                        char</small>
                    <small id="passwordError" style="display: none; color: red">this password is not secure</small>
                </div>

                <div class="form-group">
                    <label for="role">role:</label>
                    <select id="role">
                        <c:forEach items="${roles}" var="role">
                            <option value="${role.name}">${role.name}</option>
                        </c:forEach>
                    </select>
                </div>

                <input type="submit" value="Submit" onclick="registerIfInputsAreCorrect()" class="btn btn-info">
            </form>
        </div>
    </div>
</div>


<script>

    function registerIfInputsAreCorrect() {
        let returnVar = false;
        const firstName = document.getElementById("firstName").value;
        const lastName = document.getElementById("lastName").value;
        const email = document.getElementById("email").value;
        const password = document.getElementById("password").value;
        if (isFirstNameOk(firstName) && isLastNameOk(lastName))
            if (isEmailOk(email)) {
                if (isPasswordOk(password))
                    returnVar = sendUserForRegister();
            } else document.getElementById("emailError").style.display = "block";
        return returnVar;
    }

    function sendUserForRegister() {
        let request = new XMLHttpRequest;
        request.open("Post", "register", true);
        request.setRequestHeader("Content-type", "application/json");
        request.dataType = "json";
        let user;
        user = createUserFromInputs();
        let userString = JSON.stringify(user);
        request.send(userString);
        return getResponseOfRegister(request);
    }

    function getResponseOfRegister(request) {
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200)
                window.location.replace("userPanel");
            if (this.readyState === 4 && this.status !== 200)
                window.alert(this.response);
        }
    }

    function createUserFromInputs() {
        let role = document.getElementById("role").value;
        if (role === "teacher") role = 1;
        else role = 2;
        return {
            "firstName": document.getElementById("firstName").value,
            "lastName": document.getElementById("lastName").value,
            "email": document.getElementById("email").value,
            "password": document.getElementById("password").value,
            "role": {
                "id": role,
                "name": document.getElementById("role").value
            }
        }
    }

    function isFirstNameOk(firstName) {
        if (!isNameOk(firstName)) {
            document.getElementById("firstNameError").style.display = "block";
            return false;
        } else {
            document.getElementById("firstNameError").style.display = "none";
            return true;
        }
    }

    function isLastNameOk(lastName) {
        if (!isNameOk(lastName)) {
            document.getElementById("lastNameError").style.display = "block";
            return false;
        } else {
            document.getElementById("lastNameError").style.display = "none";
            return true;
        }
    }

    function isNameOk(name) {
        let retValue = true;
        let i;
        for (i = 0; i < name.length; i++) {
            let c = name.charCodeAt(i);
            if (!(c >= 65 && c <= 90) &&
                !(c >= 97 && c <= 122)) {
                retValue = false;
            }
        }
        return retValue;
    }

    function isEmailOk(email) {
        let emailPart = email.split("@");
        if (emailPart.length != 2) return false;
        if (emailPart[0].length == 0) return false;
        let domain = emailPart[1].split(".");
        if (domain.length != 2) return false;
        if (domain[0].length == 0) return false;
        if (domain[1].length != 3) return false;
        document.getElementById("emailError").style.display = "none";
        return true;
    }

    function isPasswordOk(password) {
        let retValue = true;
        if (password.length < 8) retValue = false;
        if (!containsCharacter(password)) retValue = false;
        if (!containsNumbers(password)) retValue = false;
        if (!retValue) document.getElementById("passwordError").style.display = "block";
        else document.getElementById("passwordError").style.display = "none";
        return retValue;
    }

    function containsCharacter(password) {
        let retValue = false;
        let i;
        for (i = 0; i < password.length; i++) {
            let c = password.charCodeAt(i);
            if ((c >= 65 && c <= 90) || (c >= 97 && c <= 122)) retValue = true;
        }
        return retValue;
    }

    function containsNumbers(password) {
        let retValue = false;
        let i;
        for (i = 0; i < password.length; i++) {
            let c = password.charAt(i);
            if (isNaN(c)) retValue = true;
        }
        return retValue;
    }

</script>
</body>
</html>