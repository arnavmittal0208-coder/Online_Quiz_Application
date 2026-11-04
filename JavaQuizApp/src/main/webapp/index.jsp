<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.util.SessionUtil" %>
<%
    User user = SessionUtil.getLoggedInUser(session);
    if (user != null) {
        if (user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        } else {
            response.sendRedirect(request.getContextPath() + "/student/dashboard");
        }
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>

