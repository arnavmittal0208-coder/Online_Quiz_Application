package com.quiz.servlet;

import com.quiz.model.Option;
import com.quiz.model.Question;
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
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@WebServlet(urlPatterns = {
    "/student/quiz/start",
    "/student/quiz/submit",
    "/student/quiz/result"
})
public class StudentQuizServlet extends HttpServlet {

    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());

        try {
            if (uri.endsWith("/result")) {
                String attemptId = req.getParameter("attemptId");
                QuizAttempt attempt = XMLHelper.getAttemptById(dataPath, attemptId);
                if (attempt == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=Attempt+not+found");
                    return;
                }
                Quiz quiz = XMLHelper.getQuizById(dataPath, attempt.getQuizId());
                req.setAttribute("attempt", attempt);
                req.setAttribute("quiz", quiz);
                req.getRequestDispatcher("/WEB-INF/jsp/student/quiz-result.jsp").forward(req, resp);
            } else if (uri.endsWith("/start")) {
                int quizId = Integer.parseInt(req.getParameter("id"));
                Quiz quiz = XMLHelper.getQuizById(dataPath, quizId);
                if (quiz == null || !quiz.isPublished()) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=Quiz+is+not+available");
                    return;
                }
                if (quiz.getQuestions() == null || quiz.getQuestions().isEmpty()) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=Quiz+has+no+questions+yet");
                    return;
                }

                // Store start time in session
                req.getSession().setAttribute("quizStartTime_" + quizId, System.currentTimeMillis());
                req.getSession().setAttribute("quizStartDate_" + quizId, LocalDateTime.now().format(FORMATTER));

                req.setAttribute("quiz", quiz);
                req.getRequestDispatcher("/WEB-INF/jsp/student/quiz-attempt.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            throw new ServletException("Error handling quiz request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String uri = req.getRequestURI();
        String dataPath = SessionUtil.getDataPath(getServletContext());
        User student = SessionUtil.getLoggedInUser(req.getSession());

        if (uri.endsWith("/submit")) {
            try {
                int quizId = Integer.parseInt(req.getParameter("quizId"));
                Quiz quiz = XMLHelper.getQuizById(dataPath, quizId);
                if (quiz == null) {
                    resp.sendRedirect(req.getContextPath() + "/student/dashboard?error=Quiz+not+found");
                    return;
                }

                Long startTimeMillis = (Long) req.getSession().getAttribute("quizStartTime_" + quizId);
                String startedAt = (String) req.getSession().getAttribute("quizStartDate_" + quizId);
                if (startedAt == null) {
                    startedAt = LocalDateTime.now().format(FORMATTER);
                }

                int timeTaken = 0;
                if (startTimeMillis != null) {
                    timeTaken = (int) ((System.currentTimeMillis() - startTimeMillis) / 1000);
                } else {
                    String timeTakenParam = req.getParameter("timeTaken");
                    if (timeTakenParam != null) {
                        try {
                            timeTaken = Integer.parseInt(timeTakenParam);
                        } catch (Exception ignored) {}
                    }
                }

                String completedAt = LocalDateTime.now().format(FORMATTER);

                QuizAttempt attempt = new QuizAttempt();
                attempt.setId(UUID.randomUUID().toString().substring(0, 8));
                attempt.setQuizId(quizId);
                attempt.setQuizTitle(quiz.getTitle());
                attempt.setUsername(student.getUsername());
                attempt.setStudentName(student.getFullName());
                attempt.setStartedAt(startedAt);
                attempt.setCompletedAt(completedAt);
                attempt.setTimeTaken(timeTaken);

                int totalMarks = 0;
                int obtainedMarks = 0;
                List<QuizAttempt.QuestionAttempt> questionAttempts = new ArrayList<>();

                for (Question q : quiz.getQuestions()) {
                    totalMarks += q.getMarks();
                    String selectedOption = req.getParameter("question_" + q.getId());
                    if (selectedOption != null) {
                        selectedOption = selectedOption.trim();
                    }

                    String correctOption = q.getCorrectOptionId();
                    boolean isCorrect = correctOption != null && correctOption.equalsIgnoreCase(selectedOption);

                    int marks = isCorrect ? q.getMarks() : 0;
                    obtainedMarks += marks;

                    QuizAttempt.QuestionAttempt qa = new QuizAttempt.QuestionAttempt();
                    qa.setQuestionId(q.getId());
                    qa.setQuestionText(q.getText());
                    qa.setSelectedOption(selectedOption != null ? selectedOption : "");
                    qa.setCorrectOption(correctOption != null ? correctOption : "");
                    qa.setCorrect(isCorrect);
                    qa.setMarksObtained(marks);
                    qa.setMaxMarks(q.getMarks());
                    questionAttempts.add(qa);
                }

                double percentage = totalMarks > 0 ? ((double) obtainedMarks / totalMarks) * 100.0 : 0.0;
                boolean passed = percentage >= quiz.getPassingScore();

                attempt.setTotalMarks(totalMarks);
                attempt.setObtainedMarks(obtainedMarks);
                attempt.setPercentage(Math.round(percentage * 10.0) / 10.0);
                attempt.setPassed(passed);
                attempt.setQuestionAttempts(questionAttempts);

                // Persist attempt to XML
                XMLHelper.saveAttempt(dataPath, attempt);

                // Clean session
                req.getSession().removeAttribute("quizStartTime_" + quizId);
                req.getSession().removeAttribute("quizStartDate_" + quizId);

                // Redirect to results
                resp.sendRedirect(req.getContextPath() + "/student/quiz/result?attemptId=" + attempt.getId());

            } catch (Exception e) {
                throw new ServletException("Error submitting quiz", e);
            }
        }
    }
}

