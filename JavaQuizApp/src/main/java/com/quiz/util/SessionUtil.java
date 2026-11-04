package com.quiz.util;

import com.quiz.model.User;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    public static final String SESSION_USER = "loggedInUser";

    public static User getLoggedInUser(HttpSession session) {
        return (User) session.getAttribute(SESSION_USER);
    }

    public static void setLoggedInUser(HttpSession session, User user) {
        session.setAttribute(SESSION_USER, user);
    }

    public static boolean isLoggedIn(HttpSession session) {
        return getLoggedInUser(session) != null;
    }

    public static boolean isAdmin(HttpSession session) {
        User u = getLoggedInUser(session);
        return u != null && u.isAdmin();
    }

    public static boolean isStudent(HttpSession session) {
        User u = getLoggedInUser(session);
        return u != null && u.isStudent();
    }

    public static void logout(HttpSession session) {
        session.invalidate();
    }

    public static String getDataPath(jakarta.servlet.ServletContext ctx) {
        // Data stored in WEB-INF/data
        return ctx.getRealPath("/WEB-INF/data");
    }
}

