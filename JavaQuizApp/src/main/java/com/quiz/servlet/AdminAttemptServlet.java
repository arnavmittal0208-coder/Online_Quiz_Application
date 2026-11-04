package com.quiz.servlet;

import com.quiz.model.Quiz;
import com.quiz.model.QuizAttempt;
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
    "/admin/attempts",
    "/admin/attempt/detail"
})
public class AdminAttemptServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            if (uri.endsWith("/detail")) {
                String attemptId = req.getParameter("id");
                QuizAttempt attempt = XMLHelper.getAttemptById(dataPath, attemptId);
                if (attempt == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/attempts?error=Attempt+not+found");
                    return;
                }
                req.setAttribute("attempt", attempt);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/attempt-detail.jsp").forward(req, resp);
            } else {
                String quizIdStr = req.getParameter("quizId");
                List<QuizAttempt> attempts;
                if (quizIdStr != null && !quizIdStr.isEmpty()) {
                    int quizId = Integer.parseInt(quizIdStr);
                    attempts = XMLHelper.getAttemptsByQuiz(dataPath, quizId);
                    req.setAttribute("selectedQuizId", quizId);
                } else {
                    attempts = XMLHelper.getAllAttempts(dataPath);
                }
                List<Quiz> quizzes = XMLHelper.getAllQuizzes(dataPath);
                req.setAttribute("quizzes", quizzes);
                req.setAttribute("attempts", attempts);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/attempts.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Error in attempts servlet", e);
        }
    }
}

