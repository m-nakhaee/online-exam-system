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
    <title>panelPage</title>
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
    <div class="panel-heading">User Management Panel</div>

    <div class="panel-body" class="row">
        <form id=users class="col-sm-10 strong"><p style="font-style: oblique">User Table:</p><br>
            <table id="userTable" class="table table-striped ellipsis table-responsive" style="table-layout: fixed;">
                <tr>
                    <th style="width: 3vw">id</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th style="width: 20vw">Email</th>
                    <th>Password</th>
                    <th>Role</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </table>
        </form>

        <form id="optionForm" class="col-sm-2">

            <input type="radio" id="showAllCheck" checked onclick="disableFilterCheckBoxes()">
            <label for="showAllCheck">All Users</label><br>

            <input type="radio" id="showByFilterCheck" onclick="enableFilterCheckBoxes()">
            <label for="showByFilterCheck">Filter:</label><br>

            <div id="filters" style="padding: 10px; border: dashed" class="form-horizontal" class="">

                <input type="checkbox" id="firstNameFilter" disabled onclick="showTextField(this, 'firstNameField')">
                <label for="firstNameFilter">by first name</label>
                <input type="text" id="firstNameField" style="display:none"><br>


                <input type="checkbox" id="lastNamFilter" disabled onclick="showTextField(this, 'lastNameField')">
                <label for="lastNamFilter">by last name</label>
                <input type="text" id="lastNameField" style="display:none"><br>

                <input type="checkbox" id="emailFilter" disabled onclick="showTextField(this, 'emailField')">
                <label for="emailFilter">by email</label>
                <input type="text" id="emailField" style="display:none"><br>

                <input type="checkbox" id="roleFilter" disabled onclick="showRoles(this)">
                <label for="roleFilter">by role</label>
                <select id="roleSelect" style="display:none">
                </select><br>

                <input type="checkbox" id="statusFilter" disabled onclick="showAllStatus(this)">
                <label for="statusFilter">by status</label>
                <select id="statusSelect" style="display:none">
                </select><br>
            </div>
            <br>
            <input type="button" id="showUsersButton" value="Show Users" onclick="doFilters()" class="btn-info">
        </form>
    </div>
</div>

<script>
    function disableFilterCheckBoxes() {
        document.getElementById("showByFilterCheck").checked = false;
        let c = document.getElementById("filters").children;
        let i;
        for (i = 0; i < c.length; i++) {
            c[i].setAttribute("disabled", "disabled");
        }
    }

    function enableFilterCheckBoxes() {
        document.getElementById("showAllCheck").checked = false;
        let c = document.getElementById("filters").children;
        let i;
        for (i = 0; i < c.length; i++) {
            c[i].removeAttribute("disabled");
        }
    }

    function showTextField(filterElement, fieldId) {
        let field = document.getElementById(fieldId);
        if (filterElement.checked === true)
            field.style.display = "block";
        else {
            field.value = "";
            field.style.display = "none";
        }
        console.log(field.value);
    }

    function showRoles(filterElement) {
        let roleSelect = document.getElementById("roleSelect");
        if (filterElement.checked === true) {
            roleSelect.style.display = "block";
            getAndCreateOptionsByAjax("getRoles", roleSelect)
        } else {
            let i;
            for (i = roleSelect.length - 1; i >= 0; i--)
                roleSelect.remove(i);
            roleSelect.style.display = "none";
        }
    }

    function showAllStatus(filterElement) {
        let statusSelect = document.getElementById("statusSelect");
        if (filterElement.checked === true) {
            statusSelect.style.display = "block";
            getAndCreateOptionsByAjax("getAllStatus", statusSelect)
        } else {
            let i;
            for (i = statusSelect.length - 1; i >= 0; i--)
                statusSelect.remove(i);
            statusSelect.style.display = "none";
        }
    }

    function getAndCreateOptionsByAjax(url, selector) {
        let xHttp = new XMLHttpRequest();
        xHttp.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200) {
                createOptions(this.response, selector);
            }
        };
        xHttp.open("GET", url, true);
        xHttp.send();
    }

    function createOptions(ajaxResponse, selector) {
        let response = JSON.parse(ajaxResponse);
        let i;
        for (i = 0; i < Object.keys(response).length; i++) {
            let option = document.createElement("option");
            option.text = response[i]["name"];
            selector.add(option);
        }
    }

    function createJson() {
        return {
            "role": {
                "name": document.getElementById("roleSelect").value,
            },
            "firstName": document.getElementById("firstNameField").value,
            "lastName": document.getElementById("lastNameField").value,
            "email": document.getElementById("emailField").value,
            "status":
                {
                    "name": document.getElementById("statusSelect").value

                },
        };
    }

    function doFilters() {
        const request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status === 200)
                insertContentOfTable(this.response);
        }
        if (document.getElementById("showAllCheck").checked)
            getAllUsers();
        if (document.getElementById("showByFilterCheck").checked)
            getFilteredUsers();

        function checkNoFilter() {
            let c = document.getElementById("filters").children;
            let i;
            for (i = 0; i < c.length; i++) {
                if (c[i].checked) return false;
            }
            return true;
        }

        function getFilteredUsers() {
            request.open("Post", "getFilteredUsers", true);
            request.setRequestHeader("Content-type", "application/json");
            request.dataType = "json";
            request.responseType = "json";
            let json;
            json = createJson();
            let jsonString = JSON.stringify(json);
            request.send(jsonString);
        }

        function getAllUsers() {
            request.open("GET", "getAllUsers", true);
            request.responseType = "json";
            request.send();
        }
    }

    function insertContentOfTable(ajaxResponse) {
        let userTable = document.getElementById("userTable");
        let j;
        let r = userTable.rows.length;
        for (j = 1; j < r; j++)
            userTable.deleteRow(1);
        r = userTable.rows.length;
        let i;
        for (i = 0; i < Object.keys(ajaxResponse).length; i++) {
            createNewRow();
        }

        function createNewRow() {
            userTable.insertRow(i + r).outerHTML = '<tr id="row' + i + '"><td>' + i +
                '</td><td id="firstName' + i + '">' + ajaxResponse[i]["firstName"] +
                '</td><td id="lastName' + i + '">' + ajaxResponse[i]["lastName"] +
                '</td><td id="email' + i + '">' + ajaxResponse[i]["email"] +
                '</td><td id="password' + i + '">' + ajaxResponse[i]["password"] +
                '</td><td id="role' + i + '">' + ajaxResponse[i]["role"]["name"] +
                '</td><td id="status' + i + '">' + ajaxResponse[i]["status"]["name"] +
                '</td>' +
                '<td >' +
                '<input type="button" class="btn btn-default btn-xs" id="edit_button' + i + '" value="edit this user" onclick="makeRowEditable(' + i + ')">' +
                '<input type="button" class="btn btn-default btn-xs" id="save_button' + i + '" style="display: none" value="save" onclick="save_edit(' + i + ')">' +
                '<input type="button" class="btn btn-default btn-xs" id="cancel_button' + i + '" style="display: none" value="cancel" onclick="cancel_edit(' + i + ')">' +
                '<input type="button" class="btn btn-default btn-xs" id="delete_button' + i + '" value="delete this user" onclick="delete_row(this)">' +
                '</td>' +
                '</tr>'
        }


    let oldUserValue;

    function makeRowEditable(i) {   //TODO mohem!!! status ro faghat vaghto editable kon le registered boode
        setDisplayOfButtons();
        let {firstName, lastName, email, password, role, status} = getUserFields();
        keepLastValues();
        showTextFieldsForEditing();

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "none";
            document.getElementById("save_button" + i).style.display = "block";
            document.getElementById("cancel_button" + i).style.display = "block";
        }

        function keepLastValues() {
            oldUserValue = {
                "firstName": firstName.innerHTML,
                "lastName": lastName.innerHTML,
                "email": email.innerHTML,
                "password": password.innerHTML,
                "role": role.innerHTML,
                "status": status.innerHTML
            }
        }

        function getUserFields() {
            let firstName = document.getElementById("firstName" + i);
            let lastName = document.getElementById("lastName" + i);
            let email = document.getElementById("email" + i);
            let password = document.getElementById("password" + i);
            let role = document.getElementById("role" + i);
            let status = document.getElementById("status" + i);
            return {firstName, lastName, email, password, role, status};
        }

        function showTextFieldsForEditing() {
            firstName.innerHTML = "<input type='text' id='editedFirstName" + i + "' value='" + oldUserValue["firstName"] + "'>";
            lastName.innerHTML = "<input type='text' id='editedLastName" + i + "' value='" + oldUserValue["lastName"] + "'>";
            password.innerHTML = "<input type='text' id='editedPassword" + i + "' value='" + oldUserValue["password"] + "'>";
            role.innerHTML = "<select id = 'editedRole" + i + "' >" +
                "<option>" + oldUserValue["role"] + "</option>" +
                "<c:forEach items='${roles}' var='role'>" +
                "   <option value=\"${role.name}\">${role.name}</option>" +
                "</c:forEach>" +
                "</select>";
            if (oldUserValue.status === "registered")
                status.innerHTML = "<select id = 'editedStatus" + i + "' >" +
                    "<option>" + oldUserValue["status"] + "</option>" +
                    "<c:forEach items='${allStatus}' var='status'>" +
                    "   <option value=\"${status.name}\">${status.name}</option>" +
                    "</c:forEach>" +
                    "</select>";
        }
    }

    function cancel_edit(i) {
        setUserFieldsToLastValues();
        setDisplayOfButtons();

        function setUserFieldsToLastValues() {
            document.getElementById("firstName" + i).innerHTML = oldUserValue["firstName"];
            document.getElementById("lastName" + i).innerHTML = oldUserValue["lastName"];
            document.getElementById("password" + i).innerHTML = oldUserValue["password"];
            document.getElementById("role" + i).innerHTML = oldUserValue["role"];
            if (oldUserValue.status === "registered")
                document.getElementById("status" + i).innerHTML = oldUserValue["status"];
        }

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "block";
            document.getElementById("save_button" + i).style.display = "none";
            document.getElementById("cancel_button" + i).style.display = "none";

        }
    }

    function save_edit(i) {
        let updatedUser = createNewUserObject();
        setNewUserFieldsToTheRowOfTable();
        setDisplayOfButtons();
        sendActionToServer("updateUser", updatedUser);

        function createNewUserObject() {
            let newStatus;
            if (oldUserValue.status === "registered") {
                newStatus = document.getElementById("editedStatus" + i).value;
                if (newStatus === "registered")
                    newStatus = "";
            } else newStatus = "";
            return {
                "firstName": document.getElementById("editedFirstName" + i).value,
                "lastName": document.getElementById("editedLastName" + i).value,
                "email": oldUserValue.email,
                "password": document.getElementById("editedPassword" + i).value,
                "role": {
                    "name": document.getElementById("editedRole" + i).value,
                },
                "status": {
                    "name": newStatus
                }
            }
        }

        function setNewUserFieldsToTheRowOfTable() {
            if (updatedUser.firstName !== "")
                document.getElementById("firstName" + i).innerHTML = updatedUser.firstName;
            else
                document.getElementById("firstName" + i).innerHTML = oldUserValue.firstName;
            if (updatedUser.lastName !== "")
                document.getElementById("lastName" + i).innerHTML = updatedUser.lastName;
            else
                document.getElementById("lastName" + i).innerHTML = oldUserValue.lastName;
            if (updatedUser.password !== "")
                document.getElementById("password" + i).innerHTML = updatedUser.password;
            else
                document.getElementById("password" + i).innerHTML = oldUserValue.password;
            if (updatedUser.role !== "")
                document.getElementById("role" + i).innerHTML = updatedUser.role.name;
            else
                document.getElementById("role" + i).innerHTML = oldUserValue.role.name;
            if (updatedUser.status !== "")
                document.getElementById("status" + i).innerHTML = updatedUser.status;
            else
                document.getElementById("status" + i).innerHTML = oldUserValue.status;
        }

        function setDisplayOfButtons() {
            document.getElementById("edit_button" + i).style.display = "block";
            document.getElementById("save_button" + i).style.display = "none";
            document.getElementById("cancel_button" + i).style.display = "none";
        }
    }

    function delete_row(r) {
        let i = r.parentNode.parentNode;
        document.getElementById("userTable").deleteRow(i.rowIndex);
        let userEmail = document.getElementById("email" + i);
        let user = {"status": "deleted", "email": userEmail};
        sendActionToServer("createDropUser", user);
    }

    //
    // function add_row() {
    //     let newUser = {
    //         "firstName": document.getElementById("newFirstName").value,
    //         "lastName": document.getElementById("newLastName").value,
    //         "Email": document.getElementById("newEmail").value,
    //         "password": document.getElementById("newPassword").value,
    //         "role": {
    //             "name": document.getElementById("newRole").value,
    //         },
    //         "status": document.getElementById("newStatus").value,
    //     }
    //
    //     let table = document.getElementById("userTable");
    //     let i = (table.rows.length) - 1;
    //
    //     table.insertRow(i).outerHTML =
    //         "<tr id='row" + i + "'>" +
    //         "<td id='firstName" + i + "'>" + newUser["firstName"] + "</td>" +
    //         "<td id='lastName" + i + "'>" + newUser["lastName"] + "</td>" +
    //         "<td id='email" + i + "'>" + newUser["email"] + "</td>" +
    //         "<td id='password" + i + "'>" + newUser["password"] + "</td>" +
    //         "<td id='role" + i + "'>" + newUser["role"].name + "</td>" +
    //         "<td id='status" + i + "'>" + newUser["status"] + "</td>" +
    //         '<td >' +
    //         '<input type="button" class="btn btn-default btn-xs" id="edit_button' + i + '" value="edit this user" onclick="edit_row(' + i + ')">' +
    //         '<input type="button" class="btn btn-default btn-xs" id="save_button' + i + '" style="display: none" value="save" onclick="save_row(' + i + ')">' +
    //         '<input type="button" class="btn btn-default btn-xs" id="cancel_button' + i + '" style="display: none" value="cancel" onclick="cancel_save(' + i + ')">' +
    //         '<input type="button" class="btn btn-default btn-xs" id="delete_button' + i + '" value="delete this user" onclick="delete_row(this)">' +
    //         '</td>' +
    //         '</tr>'
    //     document.getElementById("newFirstName").value = "";
    //     document.getElementById("newLastName").value = "";
    //     document.getElementById("newEmail").value = "";
    //     document.getElementById("newPassword").value = "";
    //
    //     // ajaxCUD("userCD", newUser);
    //
    // }

    function sendActionToServer(url, json) {
        let request = new XMLHttpRequest();
        request.onreadystatechange = function () {
            if (this.readyState === 4 && this.status !== 200) {
                window.alert(this.response);
            }
        }
        request.open("Post", url, true);
        request.setRequestHeader("Content-type", "application/json");
        request.dataType = "json";
        request.responseType = "json";
        let jsonString = JSON.stringify(json);
        request.send(jsonString);
    }

</script>
</body>
</html>
