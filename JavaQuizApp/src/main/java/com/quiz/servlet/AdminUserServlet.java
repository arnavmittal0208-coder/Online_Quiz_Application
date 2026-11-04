package com.quiz.servlet;

import com.quiz.model.User;
import com.quiz.util.SessionUtil;
import com.quiz.util.XMLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/users",
    "/admin/user/delete"
})
public class AdminUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            if (uri.endsWith("/delete")) {
                int userId = Integer.parseInt(req.getParameter("id"));
                User current = SessionUtil.getLoggedInUser(req.getSession());
                if (current != null && current.getId() == userId) {
                    resp.sendRedirect(req.getContextPath() + "/admin/users?error=Cannot+delete+logged-in+admin");
                    return;
                }
                XMLHelper.deleteUser(dataPath, userId);
                resp.sendRedirect(req.getContextPath() + "/admin/users?msg=User+deleted");
            } else {
                List<User> users = XMLHelper.getAllUsers(dataPath);
                req.setAttribute("users", users);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/users.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Error in user management", e);
        }
    }
}

