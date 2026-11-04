package com.quiz.servlet;

import com.quiz.model.QuizAttempt;
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

@WebServlet("/student/history")
public class StudentHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dataPath = SessionUtil.getDataPath(getServletContext());
        User student = SessionUtil.getLoggedInUser(req.getSession());

        try {
            List<QuizAttempt> attempts = XMLHelper.getAttemptsByUser(dataPath, student.getUsername());
            req.setAttribute("attempts", attempts);
            req.getRequestDispatcher("/WEB-INF/jsp/student/history.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error loading student history", e);
        }
    }
}

