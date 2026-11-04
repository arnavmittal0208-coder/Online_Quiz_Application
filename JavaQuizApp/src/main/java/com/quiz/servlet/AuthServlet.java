package com.quiz.servlet;

import com.quiz.model.User;
import com.quiz.util.SessionUtil;
import com.quiz.util.XMLHelper;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDate;

@WebServlet(urlPatterns = {"/login", "/logout", "/register"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws IOException, jakarta.servlet.ServletException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/logout")) {
            SessionUtil.logout(req.getSession(false));
            res.sendRedirect(req.getContextPath() + "/login?msg=Logged+out+successfully");
        } else if (uri.endsWith("/register")) {
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, res);
        } else {
            // Check already logged in
            HttpSession session = req.getSession(false);
            if (session != null && SessionUtil.isLoggedIn(session)) {
                User u = SessionUtil.getLoggedInUser(session);
                redirectToDashboard(res, req, u);
                return;
            }
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
            throws IOException, jakarta.servlet.ServletException {
        String uri = req.getRequestURI();
        if (uri.endsWith("/register")) {
            handleRegister(req, res);
        } else {
            handleLogin(req, res);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse res)
            throws IOException, jakarta.servlet.ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            User user = XMLHelper.authenticateUser(dataPath, username, password);
            if (user != null) {
                HttpSession session = req.getSession(true);
                SessionUtil.setLoggedInUser(session, user);
                redirectToDashboard(res, req, user);
            } else {
                req.setAttribute("error", "Invalid username or password");
                req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
            }
        } catch (Exception e) {
            req.setAttribute("error", "System error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, res);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse res)
            throws IOException, jakarta.servlet.ServletException {
        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String email = req.getParameter("email");
        String fullName = req.getParameter("fullName");
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            // Check duplicate
            if (XMLHelper.getUserByUsername(dataPath, username) != null) {
                req.setAttribute("error", "Username already exists");
                req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, res);
                return;
            }

            User user = new User();
            user.setId(XMLHelper.getNextUserId(dataPath));
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setFullName(fullName);
            user.setRole("STUDENT");
            user.setCreatedAt(LocalDate.now().toString());
            XMLHelper.saveUser(dataPath, user);

            res.sendRedirect(req.getContextPath() + "/login?msg=Registration+successful!+Please+login.");
        } catch (Exception e) {
            req.setAttribute("error", "Error: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, res);
        }
    }

    private void redirectToDashboard(HttpServletResponse res, HttpServletRequest req, User u)
            throws IOException {
        if (u.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/admin/dashboard");
        } else {
            res.sendRedirect(req.getContextPath() + "/student/dashboard");
        }
    }
}

