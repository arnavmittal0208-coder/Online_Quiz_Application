package com.quiz.servlet;

import com.quiz.model.Option;
import com.quiz.model.Question;
import com.quiz.model.Quiz;
import com.quiz.util.SessionUtil;
import com.quiz.util.XMLHelper;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(urlPatterns = {
    "/admin/questions",
    "/admin/question/new",
    "/admin/question/edit",
    "/admin/question/save",
    "/admin/question/delete"
})
public class AdminQuestionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            int quizId = Integer.parseInt(req.getParameter("quizId"));
            Quiz quiz = XMLHelper.getQuizById(dataPath, quizId);
            if (quiz == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/quizzes?error=Quiz+not+found");
                return;
            }
            req.setAttribute("quiz", quiz);

            if (uri.endsWith("/new")) {
                Question q = new Question();
                q.setMarks(10);
                q.setTimeLimit(quiz.getTimePerQuestion());
                req.setAttribute("question", q);
                req.setAttribute("isEdit", false);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/question-edit.jsp").forward(req, resp);
            } else if (uri.endsWith("/edit")) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                Question question = quiz.getQuestions().stream()
                        .filter(q -> q.getId() == questionId)
                        .findFirst().orElse(null);
                if (question == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/questions?quizId=" + quizId + "&error=Question+not+found");
                    return;
                }
                req.setAttribute("question", question);
                req.setAttribute("isEdit", true);
                req.getRequestDispatcher("/WEB-INF/jsp/admin/question-edit.jsp").forward(req, resp);
            } else if (uri.endsWith("/delete")) {
                int questionId = Integer.parseInt(req.getParameter("questionId"));
                quiz.getQuestions().removeIf(q -> q.getId() == questionId);
                XMLHelper.saveQuiz(dataPath, quiz);
                resp.sendRedirect(req.getContextPath() + "/admin/questions?quizId=" + quizId + "&msg=Question+deleted");
            } else {
                // List questions for this quiz
                req.getRequestDispatcher("/WEB-INF/jsp/admin/questions.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Error in question servlet", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            int quizId = Integer.parseInt(req.getParameter("quizId"));
            Quiz quiz = XMLHelper.getQuizById(dataPath, quizId);
            if (quiz == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/quizzes?error=Quiz+not+found");
                return;
            }

            String qIdStr = req.getParameter("questionId");
            String text = req.getParameter("text");
            int marks = Integer.parseInt(req.getParameter("marks"));
            int timeLimit = Integer.parseInt(req.getParameter("timeLimit"));
            String explanation = req.getParameter("explanation");
            String correctOptionId = req.getParameter("correctOption");

            List<Option> options = new ArrayList<>();
            String[] optionKeys = {"a", "b", "c", "d"};
            for (String key : optionKeys) {
                String optText = req.getParameter("option_" + key);
                if (optText != null && !optText.trim().isEmpty()) {
                    boolean isCorrect = key.equalsIgnoreCase(correctOptionId);
                    options.add(new Option(key, optText.trim(), isCorrect));
                }
            }

            boolean isNew = (qIdStr == null || qIdStr.trim().isEmpty() || "0".equals(qIdStr));
            Question question;

            if (isNew) {
                question = new Question();
                int nextQId = quiz.getQuestions().stream().mapToInt(Question::getId).max().orElse(0) + 1;
                question.setId(nextQId);
                quiz.getQuestions().add(question);
            } else {
                int qId = Integer.parseInt(qIdStr);
                question = quiz.getQuestions().stream()
                        .filter(q -> q.getId() == qId)
                        .findFirst()
                        .orElse(null);
                if (question == null) {
                    resp.sendRedirect(req.getContextPath() + "/admin/questions?quizId=" + quizId + "&error=Question+not+found");
                    return;
                }
            }

            question.setText(text);
            question.setType("MCQ");
            question.setMarks(marks);
            question.setTimeLimit(timeLimit);
            question.setExplanation(explanation);
            question.setOptions(options);

            XMLHelper.saveQuiz(dataPath, quiz);
            resp.sendRedirect(req.getContextPath() + "/admin/questions?quizId=" + quizId + "&msg=Question+saved+successfully");
        } catch (Exception e) {
            req.setAttribute("error", "Error saving question: " + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/jsp/admin/question-edit.jsp").forward(req, resp);
        }
    }
}

