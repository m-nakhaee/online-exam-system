<%@ taglib prefix="c" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%--
  Created by IntelliJ IDEA.
  User: Marzieh
  Date: 9/8/2020
  Time: 10:52 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form:form modelAttribute="user2" action="/aaa" method="post">
<%--    <form:input path="firstName" value="${user.firstName}"></form:input>--%>
    <form:input path="courseSet" value="${user.courseSet}"></form:input>
    <form:button>submit</form:button>
</form:form>
</body>
</html>
