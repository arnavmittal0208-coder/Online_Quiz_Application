package com.quiz.servlet;

import com.quiz.model.Quiz;
import com.quiz.model.User;
import com.quiz.util.SessionUtil;
import com.quiz.util.XMLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/quizzes",
    "/admin/quiz/new",
    "/admin/quiz/edit",
    "/admin/quiz/save",
    "/admin/quiz/delete",
    "/admin/quiz/toggle-publish"
})
public class AdminQuizServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            if (uri.endsWith("/new")) {
                req.setAttribute("quiz", new Quiz());
                req.setAttribute("isEdit", false);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/quiz-edit.jsp").forward(req, resp);
            } else if (uri.endsWith("/edit")) {
                int id = Integer.parseInt(req.getParameter("id"));
                Quiz quiz = XMLHelper.getQuizById(dataPath, id);
                if (quiz == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/quizzes?error=Quiz+not+found");
                    return;
                }
                req.setAttribute("quiz", quiz);
                req.setAttribute("isEdit", true);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/quiz-edit.jsp").forward(req, resp);
            } else if (uri.endsWith("/delete")) {
                int id = Integer.parseInt(req.getParameter("id"));
                XMLHelper.deleteQuiz(dataPath, id);
                resp.sendRedirect(req.getContextPath() + "/admin/quizzes?msg=Quiz+deleted+successfully");
            } else if (uri.endsWith("/toggle-publish")) {
                int id = Integer.parseInt(req.getParameter("id"));
                Quiz quiz = XMLHelper.getQuizById(dataPath, id);
                if (quiz != null) {
                    quiz.setPublished(!quiz.isPublished());
                    XMLHelper.saveQuiz(dataPath, quiz);
                }
                resp.sendRedirect(req.getContextPath() + "/admin/quizzes?msg=Status+updated");
            } else {
                // List quizzes
                List<Quiz> quizzes = XMLHelper.getAllQuizzes(dataPath);
                req.setAttribute("quizzes", quizzes);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/quizzes.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Error processing quiz request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dataPath = SessionUtil.getDataPath(getServletContext());
        User currentUser = SessionUtil.getLoggedInUser(req.getSession());

        try {
            String idStr = req.getParameter("id");
            String title = req.getParameter("title");
            String description = req.getParameter("description");
            String category = req.getParameter("category");
            int totalTimeLimit = Integer.parseInt(req.getParameter("totalTimeLimit"));
            int timePerQuestion = Integer.parseInt(req.getParameter("timePerQuestion"));
            int passingScore = Integer.parseInt(req.getParameter("passingScore"));
            boolean published = "on".equals(req.getParameter("published")) || "true".equalsIgnoreCase(req.getParameter("published"));

            Quiz quiz;
            boolean isNew = (idStr == null || idStr.trim().isEmpty() || "0".equals(idStr));
            if (isNew) {
                quiz = new Quiz();
                quiz.setId(XMLHelper.getNextQuizId(dataPath));
                quiz.setCreatedBy(currentUser != null ? currentUser.getUsername() : "admin");
                quiz.setCreatedAt(LocalDate.now().toString());
            } else {
                int id = Integer.parseInt(idStr);
                quiz = XMLHelper.getQuizById(dataPath, id);
                if (quiz == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/quizzes?error=Quiz+not+found");
                    return;
                }
            }

            quiz.setTitle(title);
            quiz.setDescription(description);
            quiz.setCategory(category);
            quiz.setTotalTimeLimit(totalTimeLimit);
            quiz.setTimePerQuestion(timePerQuestion);
            quiz.setPassingScore(passingScore);
            quiz.setPublished(published);

            XMLHelper.saveQuiz(dataPath, quiz);
            resp.sendRedirect(req.getContextPath() + "/admin/quizzes?msg=Quiz+saved+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Error saving quiz: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/admin/quiz-edit.jsp").forward(req, resp);
        }
    }
}

