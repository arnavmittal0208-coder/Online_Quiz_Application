<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.util.SessionUtil" %>
<%
    User currentUser = SessionUtil.getLoggedInUser(session);
    String currentUri = request.getRequestURI();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "SkillForge LMS - Online Examination Portal" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="<%= request.getContextPath() %>/student/dashboard" class="navbar-brand">
        <div class="brand-icon">Q</div>
        <span>SkillForge LMS</span>
    </a>
    <ul class="navbar-nav">
        <li><a href="<%= request.getContextPath() %>/student/dashboard" class="<%= currentUri.contains("/dashboard") ? "active" : "" %>">Assessments</a></li>
        <li><a href="<%= request.getContextPath() %>/student/history" class="<%= currentUri.contains("/history") ? "active" : "" %>">My Grades</a></li>
        <li>
            <span class="user-badge">
                <span class="user-avatar"><%= currentUser != null && currentUser.getFullName() != null && !currentUser.getFullName().isEmpty() ? currentUser.getFullName().substring(0, 1).toUpperCase() : "S" %></span>
                <%= currentUser != null ? currentUser.getFullName() : "Student" %>
            </span>
        </li>
        <li><a href="<%= request.getContextPath() %>/logout" class="btn btn-outline btn-sm">Sign Out</a></li>
    </ul>
</nav>

<div class="container">
    <% String alertMsg = request.getParameter("msg");
       if (alertMsg != null && !alertMsg.isEmpty()) { %>
        <div class="alert alert-success"><%= alertMsg %></div>
    <% } %>
    <% String alertErr = request.getParameter("error");
       if (alertErr != null && !alertErr.isEmpty()) { %>
        <div class="alert alert-danger"><%= alertErr %></div>
    <% } %>
