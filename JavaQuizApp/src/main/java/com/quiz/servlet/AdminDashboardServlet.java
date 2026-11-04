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
import java.util.List;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dataPath = SessionUtil.getDataPath(getServletContext());
        try {
            List<Quiz> quizzes = XMLHelper.getAllQuizzes(dataPath);
            List<User> users = XMLHelper.getAllUsers(dataPath);
            List<QuizAttempt> attempts = XMLHelper.getAllAttempts(dataPath);

            long studentCount = users.stream().filter(User::isStudent).count();
            long totalQuestions = quizzes.stream().mapToInt(Quiz::getQuestionCount).sum();
            long publishedQuizzes = quizzes.stream().filter(Quiz::isPublished).count();

            double avgScore = 0.0;
            if (!attempts.isEmpty()) {
                avgScore = attempts.stream().mapToDouble(QuizAttempt::getPercentage).average().orElse(0.0);
            }

            req.setAttribute("quizzes", quizzes);
            req.setAttribute("totalQuizzes", quizzes.size());
            req.setAttribute("publishedQuizzes", publishedQuizzes);
            req.setAttribute("studentCount", studentCount);
            req.setAttribute("totalQuestions", totalQuestions);
            req.setAttribute("totalAttempts", attempts.size());
            req.setAttribute("avgScore", Math.round(avgScore * 10.0) / 10.0);
            req.setAttribute("recentAttempts", attempts.size() > 5 ? attempts.subList(attempts.size() - 5, attempts.size()) : attempts);

            req.getRequestDispatcher("/WEB-INF/jsp/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Error loading admin dashboard", e);
        }
    }
}

