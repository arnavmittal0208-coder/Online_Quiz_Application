package com.quiz.servlet;

import com.quiz.model.Quiz;
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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/student/dashboard")
public class StudentDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dataPath = SessionUtil.getDataPath(getServletContext());
        User student = SessionUtil.getLoggedInUser(req.getSession());

        try {
            List<Quiz> quizzes = XMLHelper.getPublishedQuizzes(dataPath);
            List<QuizAttempt> myAttempts = XMLHelper.getAttemptsByUser(dataPath, student.getUsername());

            // Map quizId to latest attempt
            Map<Integer, QuizAttempt> latestAttempts = new HashMap<>();
            for (QuizAttempt qa : myAttempts) {
                latestAttempts.put(qa.getQuizId(), qa);
            }

            // Stats
            int completedCount = myAttempts.size();
            long passedCount = myAttempts.stream().filter(QuizAttempt::isPassed).count();
            double avgScore = myAttempts.isEmpty() ? 0.0 :
                    myAttempts.stream().mapToDouble(QuizAttempt::getPercentage).average().orElse(0.0);
            double highestScore = myAttempts.isEmpty() ? 0.0 :
                    myAttempts.stream().mapToDouble(QuizAttempt::getPercentage).max().orElse(0.0);

            req.setAttribute("quizzes", quizzes);
            req.setAttribute("myAttempts", myAttempts);
            req.setAttribute("latestAttempts", latestAttempts);
            req.setAttribute("completedCount", completedCount);
            req.setAttribute("passedCount", passedCount);
            req.setAttribute("avgScore", Math.round(avgScore * 10.0) / 10.0);
            req.setAttribute("highestScore", Math.round(highestScore * 10.0) / 10.0);

            req.getRequestDispatcher("/WEB-INF/jsp/student/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error loading student dashboard", e);
        }
    }
}

