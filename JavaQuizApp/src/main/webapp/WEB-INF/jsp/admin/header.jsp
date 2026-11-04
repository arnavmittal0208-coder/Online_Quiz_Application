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
    <title><%= request.getAttribute("pageTitle") != null ? request.getAttribute("pageTitle") : "SkillForge LMS - Instructor Portal" %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="<%= request.getContextPath() %>/admin/dashboard" class="navbar-brand">
        <div class="brand-icon">Q</div>
        <span>SkillForge Admin</span>
    </a>
    <ul class="navbar-nav">
        <li><a href="<%= request.getContextPath() %>/admin/dashboard" class="<%= currentUri.contains("/dashboard") ? "active" : "" %>">Dashboard</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/quizzes" class="<%= currentUri.contains("/quiz") ? "active" : "" %>">Curriculum & Quizzes</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/attempts" class="<%= currentUri.contains("/attempt") ? "active" : "" %>">Submissions</a></li>
        <li><a href="<%= request.getContextPath() %>/admin/users" class="<%= currentUri.contains("/users") ? "active" : "" %>">Enrollment</a></li>
        <li>
            <span class="user-badge">
                <span class="user-avatar" style="background: var(--dark);">A</span>
                <%= currentUser != null ? currentUser.getFullName() : "Admin" %>
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
