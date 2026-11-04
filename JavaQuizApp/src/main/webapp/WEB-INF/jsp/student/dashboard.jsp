<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%@ page import="com.quiz.model.User" %>
<%@ page import="com.quiz.util.SessionUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    request.setAttribute("pageTitle", "Student Assessments Dashboard");
    User currentUser = SessionUtil.getLoggedInUser(session);
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    Map<Integer, QuizAttempt> latestAttempts = (Map<Integer, QuizAttempt>) request.getAttribute("latestAttempts");
%>
<jsp:include page="header.jsp" />

<!-- Compact Header with Student Summary -->
<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Assessment Center
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Welcome back, <strong><%= currentUser != null ? currentUser.getFullName() : "Student" %></strong> (<%= currentUser != null ? currentUser.getEmail() : "" %>) &bull; Role: Student
        </p>
    </div>
    <div style="font-size: 0.8rem; color: var(--gray);">
        Academic Term: <strong>2026-Semester 1</strong>
    </div>
</div>

<!-- Compact 4-Column Performance Metrics -->
<div class="stats-grid">
    <div class="stat-card primary">
        <span class="label">Quizzes Completed</span>
        <span class="value"><%= request.getAttribute("completedCount") %></span>
    </div>
    <div class="stat-card success">
        <span class="label">Passed Assessments</span>
        <span class="value"><%= request.getAttribute("passedCount") %></span>
    </div>
    <div class="stat-card secondary">
        <span class="label">Average Grade</span>
        <span class="value"><%= request.getAttribute("avgScore") %>%</span>
    </div>
    <div class="stat-card warning">
        <span class="label">Highest Grade</span>
        <span class="value"><%= request.getAttribute("highestScore") %>%</span>
    </div>
</div>

<!-- Section Header -->
<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.85rem;">
    <h2 style="font-size: 1.05rem; font-weight: 700; color: var(--dark);">
        Assigned Quizzes & Exams
    </h2>
    <span style="font-size: 0.78rem; color: var(--gray);">
        Showing <%= quizzes != null ? quizzes.size() : 0 %> Active <%= quizzes != null && quizzes.size() == 1 ? "Quiz" : "Quizzes" %>
    </span>
</div>

<!-- Compact Cards Grid (Balanced 3-column layout) -->
<div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
    <%
        if (quizzes != null && !quizzes.isEmpty()) {
            for (Quiz q : quizzes) {
                QuizAttempt attempt = latestAttempts != null ? latestAttempts.get(q.getId()) : null;
                boolean isAttempted = attempt != null;
    %>
    <div class="card" style="display: flex; flex-direction: column; justify-content: space-between; margin-bottom: 0; padding: 1.15rem 1.25rem;">
        <div>
            <!-- Header Badges -->
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.65rem;">
                <span class="badge badge-primary"><%= q.getCategory() %></span>
                <% if (isAttempted) { %>
                    <% if (attempt.isPassed()) { %>
                        <span class="badge badge-success">&#10003; Passed (<%= attempt.getPercentage() %>%)</span>
                    <% } else { %>
                        <span class="badge badge-danger">&#10007; Failed (<%= attempt.getPercentage() %>%)</span>
                    <% } %>
                <% } else { %>
                    <span class="badge badge-secondary">Pending</span>
                <% } %>
            </div>

            <!-- Quiz Title -->
            <h3 style="font-size: 1.05rem; font-weight: 700; color: var(--dark); margin-bottom: 0.4rem; line-height: 1.3;">
                <%= q.getTitle() %>
            </h3>

            <!-- Description -->
            <p style="color: var(--gray); font-size: 0.82rem; line-height: 1.45; margin-bottom: 0.95rem; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                <%= q.getDescription() != null && !q.getDescription().isEmpty() ? q.getDescription() : "Standard topic assessment covering core principles." %>
            </p>

            <!-- Metadata Strip -->
            <div style="background: var(--gray-light); border: 1px solid var(--border); padding: 0.55rem 0.75rem; border-radius: var(--radius-xs); font-size: 0.78rem; margin-bottom: 1rem;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.2rem;">
                    <span style="color: var(--gray);">Questions / Marks:</span>
                    <strong style="color: var(--dark);"><%= q.getQuestionCount() %> questions (<%= q.getTotalMarks() %> pts)</strong>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 0.2rem;">
                    <span style="color: var(--gray);">Time Allocation:</span>
                    <strong style="color: var(--dark);"><%= q.getTimeLimitDisplay() %></strong>
                </div>
                <div style="display: flex; justify-content: space-between;">
                    <span style="color: var(--gray);">Passing Threshold:</span>
                    <strong style="color: var(--primary);"><%= q.getPassingScore() %>%</strong>
                </div>
            </div>
        </div>

        <!-- Action Button -->
        <div>
            <% if (q.getQuestionCount() == 0) { %>
                <button class="btn btn-outline btn-sm" style="width: 100%;" disabled>No Questions Published</button>
            <% } else if (isAttempted) { %>
                <div style="display: flex; gap: 0.5rem;">
                    <a href="<%= request.getContextPath() %>/student/quiz/result?attemptId=<%= attempt.getId() %>" class="btn btn-outline btn-sm" style="flex: 1;">
                        View Results
                    </a>
                    <a href="<%= request.getContextPath() %>/student/quiz/start?id=<%= q.getId() %>" class="btn btn-primary btn-sm" style="flex: 1;" onclick="return confirm('Do you want to retake this quiz? Your latest attempt will be recorded.');">
                        Retake Exam
                    </a>
                </div>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/student/quiz/start?id=<%= q.getId() %>" class="btn btn-primary btn-sm" style="width: 100%;">
                    Start Examination &rarr;
                </a>
            <% } %>
        </div>
    </div>
    <%
            }
        } else {
    %>
    <div class="card" style="grid-column: 1 / -1; text-align: center; padding: 2.5rem 1rem;">
        <h3 style="color: var(--dark); margin-bottom: 0.35rem; font-size: 1.05rem;">No Published Quizzes Available</h3>
        <p style="color: var(--gray); font-size: 0.84rem;">
            Assessments will appear here once published by your course instructor.
        </p>
    </div>
    <% } %>
</div>

<jsp:include page="footer.jsp" />
