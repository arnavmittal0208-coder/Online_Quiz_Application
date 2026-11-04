<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%
    QuizAttempt attempt = (QuizAttempt) request.getAttribute("attempt");
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    request.setAttribute("pageTitle", "Grade Report - " + attempt.getQuizTitle());
%>
<jsp:include page="header.jsp" />

<div style="max-width: 1040px; margin: 0 auto;">

    <!-- Breadcrumb -->
    <div class="breadcrumb-nav">
        <a href="<%= request.getContextPath() %>/student/dashboard">
            <span>&larr; Back to Catalog</span>
        </a>
        <span class="breadcrumb-divider">/</span>
        <span class="breadcrumb-current">Examination Grade Report</span>
    </div>

    <!-- Compact Result Banner Strip (Space-Saving) -->
    <div class="lms-result-strip <%= attempt.isPassed() ? "passed" : "failed" %>">
        <div style="display: flex; align-items: center; gap: 1.25rem;">
            <div style="font-size: 2rem; font-weight: 800; color: <%= attempt.isPassed() ? "var(--success)" : "var(--danger)" %>; line-height: 1;">
                <%= attempt.getPercentage() %>%
            </div>
            <div>
                <div style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.2rem;">
                    <% if (attempt.isPassed()) { %>
                        <span class="badge badge-success">&#10003; Assessment Passed</span>
                    <% } else { %>
                        <span class="badge badge-danger">&#10007; Assessment Incomplete / Failed</span>
                    <% } %>
                    <span style="font-size: 0.82rem; color: var(--gray);">Attempt ID: <code><%= attempt.getId() %></code></span>
                </div>
                <div style="font-size: 0.95rem; font-weight: 700; color: var(--dark);">
                    <%= attempt.getQuizTitle() %>
                </div>
                <div style="font-size: 0.8rem; color: var(--gray);">
                    Scored <strong><%= attempt.getObtainedMarks() %></strong> out of <strong><%= attempt.getTotalMarks() %></strong> points &bull; Required benchmark: <%= quiz != null ? quiz.getPassingScore() : 60 %>%
                </div>
            </div>
        </div>

        <div style="display: flex; gap: 0.5rem;">
            <% if (quiz != null) { %>
                <a href="<%= request.getContextPath() %>/student/quiz/start?id=<%= quiz.getId() %>" class="btn btn-outline btn-sm">Retake Exam</a>
            <% } %>
            <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-primary btn-sm">Dashboard &rarr;</a>
        </div>
    </div>

    <!-- Compact 4-Stat Metric Row -->
    <div class="stats-grid">
        <div class="stat-card success">
            <span class="label">Correct Answers</span>
            <span class="value" style="color: var(--success);">&#10003; <%= attempt.getCorrectCount() %></span>
        </div>
        <div class="stat-card" style="border-left: 3px solid var(--danger);">
            <span class="label">Incorrect Answers</span>
            <span class="value" style="color: var(--danger);">&#10007; <%= attempt.getWrongCount() %></span>
        </div>
        <div class="stat-card warning">
            <span class="label">Unanswered Questions</span>
            <span class="value" style="color: var(--warning);">&#8722; <%= attempt.getSkippedCount() %></span>
        </div>
        <div class="stat-card primary">
            <span class="label">Duration Taken</span>
            <span class="value" style="font-size: 1.25rem;"><%= attempt.getTimeTakenDisplay() %></span>
        </div>
    </div>

    <!-- Section Header -->
    <div style="display: flex; justify-content: space-between; align-items: center; margin: 1.5rem 0 0.85rem 0;">
        <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--dark);">
            Item-by-Item Evaluation
        </h2>
        <span style="font-size: 0.78rem; color: var(--gray);">
            Showing <%= attempt.getQuestionAttempts() != null ? attempt.getQuestionAttempts().size() : 0 %> Evaluated Items
        </span>
    </div>

    <!-- Compact Question Cards -->
    <%
        if (attempt.getQuestionAttempts() != null) {
            int qNum = 1;
            for (QuizAttempt.QuestionAttempt qa : attempt.getQuestionAttempts()) {
                boolean isCorrect = qa.isCorrect();
                boolean isSkipped = qa.getSelectedOption() == null || qa.getSelectedOption().isEmpty();

                String explanation = null;
                if (quiz != null && quiz.getQuestions() != null) {
                    Question matchedQ = quiz.getQuestions().stream()
                            .filter(q -> q.getId() == qa.getQuestionId())
                            .findFirst().orElse(null);
                    if (matchedQ != null) {
                        explanation = matchedQ.getExplanation();
                    }
                }
    %>
    <div class="review-card <%= isCorrect ? "correct" : (isSkipped ? "skipped" : "wrong") %>">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.65rem;">
            <div style="display: flex; align-items: flex-start; gap: 0.5rem;">
                <span style="font-weight: 700; color: var(--primary); font-size: 0.85rem; min-width: 28px;">Q<%= qNum++ %>:</span>
                <span style="font-size: 0.95rem; font-weight: 600; color: var(--dark); line-height: 1.35;"><%= qa.getQuestionText() %></span>
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

        <div style="background: var(--gray-light); border: 1px solid var(--border); padding: 0.65rem 0.85rem; border-radius: var(--radius-xs); font-size: 0.82rem;">
            <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem;">
                <div>
                    <span style="color: var(--gray);">Your Choice: </span>
                    <% if (isSkipped) { %>
                        <strong style="color: var(--warning);">(No option selected)</strong>
                    <% } else { %>
                        <strong style="text-transform: uppercase; color: <%= isCorrect ? "var(--success)" : "var(--danger)" %>;">
                            Option <%= qa.getSelectedOption() %> <%= isCorrect ? "✓ (Correct)" : "✗ (Incorrect)" %>
                        </strong>
                    <% } %>
                </div>
                <div>
                    <span style="color: var(--gray);">Correct Answer: </span>
                    <strong style="text-transform: uppercase; color: var(--success);">
                        Option <%= qa.getCorrectOption() %> ✓
                    </strong>
                </div>
            </div>

            <% if (explanation != null && !explanation.trim().isEmpty()) { %>
                <div class="explanation-box" style="margin-top: 0.5rem;">
                    <strong>Academic Rationale:</strong> <%= explanation %>
                </div>
            <% } %>
        </div>
    </div>
    <%
            }
        }
    %>

</div>

<jsp:include page="footer.jsp" />
