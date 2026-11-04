<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%
    QuizAttempt attempt = (QuizAttempt) request.getAttribute("attempt");
    request.setAttribute("pageTitle", "Submission Analysis - Admin Portal");
%>
<jsp:include page="header.jsp" />

<div style="max-width: 1040px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
        <div>
            <div style="margin-bottom: 0.25rem;">
                <a href="<%= request.getContextPath() %>/admin/attempts" style="color: var(--primary); text-decoration: none; font-size: 0.8rem;">&larr; Back to All Submissions</a>
            </div>
            <h1 style="font-size: 1.25rem; font-weight: 700; color: var(--dark);">
                Evaluation Review: <%= attempt.getStudentName() %>
            </h1>
            <p style="color: var(--gray); font-size: 0.8rem;">Quiz: <strong><%= attempt.getQuizTitle() %></strong> &bull; Attempt ID: <code><%= attempt.getId() %></code></p>
        </div>
        <div>
            <% if (attempt.isPassed()) { %>
                <span class="badge badge-success">&#10003; PASSED</span>
            <% } else { %>
                <span class="badge badge-danger">&#10007; FAILED</span>
            <% } %>
        </div>
    </div>

    <!-- Compact 4-Stat Strip -->
    <div class="stats-grid">
        <div class="stat-card primary">
            <span class="label">Total Score</span>
            <span class="value"><%= attempt.getObtainedMarks() %> / <%= attempt.getTotalMarks() %></span>
        </div>
        <div class="stat-card success">
            <span class="label">Grade Percentage</span>
            <span class="value"><%= attempt.getPercentage() %>%</span>
        </div>
        <div class="stat-card secondary">
            <span class="label">Time Taken</span>
            <span class="value" style="font-size: 1.25rem;"><%= attempt.getTimeTakenDisplay() %></span>
        </div>
        <div class="stat-card warning">
            <span class="label">Correct / Incorrect</span>
            <span class="value" style="font-size: 1.25rem;"><%= attempt.getCorrectCount() %> / <%= attempt.getWrongCount() %></span>
        </div>
    </div>

    <div style="margin: 1.25rem 0 0.75rem 0;">
        <h2 style="font-size: 0.95rem; font-weight: 700; color: var(--dark); text-transform: uppercase; letter-spacing: 0.4px;">
            Submitted Responses & Keys
        </h2>
    </div>

    <%
        if (attempt.getQuestionAttempts() != null) {
            int qIndex = 1;
            for (QuizAttempt.QuestionAttempt qa : attempt.getQuestionAttempts()) {
                boolean isCorrect = qa.isCorrect();
                boolean isSkipped = qa.getSelectedOption() == null || qa.getSelectedOption().isEmpty();
    %>
    <div class="review-card <%= isCorrect ? "correct" : (isSkipped ? "skipped" : "wrong") %>">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.5rem;">
            <div style="display: flex; align-items: flex-start; gap: 0.5rem;">
                <span style="font-weight: 700; color: var(--gray); font-size: 0.82rem; min-width: 24px;">Q<%= qIndex++ %>:</span>
                <span style="color: var(--dark); font-size: 0.9rem; font-weight: 600;"><%= qa.getQuestionText() %></span>
            </div>
            <div style="margin-left: 0.75rem;">
                <% if (isCorrect) { %>
                    <span class="badge badge-success">&#10003; +<%= qa.getMarksObtained() %> pts</span>
                <% } else if (isSkipped) { %>
                    <span class="badge badge-warning">Skipped (0 pts)</span>
                <% } else { %>
                    <span class="badge badge-danger">&#10007; 0 / <%= qa.getMaxMarks() %> pts</span>
                <% } %>
            </div>
        </div>

        <div style="font-size: 0.82rem; display: flex; gap: 1.5rem; background: var(--gray-light); padding: 0.55rem 0.75rem; border: 1px solid var(--border); border-radius: var(--radius-xs);">
            <div>
                <span style="color: var(--gray);">Student Response: </span>
                <% if (isSkipped) { %>
                    <strong style="color: var(--warning);">(No response recorded)</strong>
                <% } else { %>
                    <strong style="text-transform: uppercase; color: <%= isCorrect ? "var(--success)" : "var(--danger)" %>;">
                        Option <%= qa.getSelectedOption() %>
                    </strong>
                <% } %>
            </div>
            <div>
                <span style="color: var(--gray);">Master Key: </span>
                <strong style="text-transform: uppercase; color: var(--success);">
                    Option <%= qa.getCorrectOption() %>
                </strong>
            </div>
        </div>
    </div>
    <%
            }
        }
    %>
</div>

<jsp:include page="footer.jsp" />
