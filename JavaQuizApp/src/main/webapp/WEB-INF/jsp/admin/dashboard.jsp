<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Instructor Administration Console");
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Instructor Administration Console
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Academic curriculum control, automated grading benchmarks, and real-time student evaluation.
        </p>
    </div>
    <div>
        <a href="<%= request.getContextPath() %>/admin/quiz/new" class="btn btn-primary btn-sm">+ Create New Quiz</a>
    </div>
</div>

<!-- Compact 6-Metric Strip -->
<div style="display: grid; grid-template-columns: repeat(6, 1fr); gap: 0.65rem; margin-bottom: 1.25rem;">
    <div class="stat-card primary" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Total Quizzes</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("totalQuizzes") %></span>
    </div>
    <div class="stat-card success" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Published</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("publishedQuizzes") %></span>
    </div>
    <div class="stat-card secondary" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Bank Questions</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("totalQuestions") %></span>
    </div>
    <div class="stat-card warning" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Students</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("studentCount") %></span>
    </div>
    <div class="stat-card primary" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Submissions</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("totalAttempts") %></span>
    </div>
    <div class="stat-card success" style="min-height: 64px; padding: 0.65rem 0.85rem;">
        <span class="label">Average Grade</span>
        <span class="value" style="font-size: 1.35rem;"><%= request.getAttribute("avgScore") %>%</span>
    </div>
</div>

<!-- Compact Quizzes Table -->
<div class="card" style="padding: 0; overflow: hidden; margin-bottom: 1.25rem;">
    <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.85rem 1rem; border-bottom: 1px solid var(--border);">
        <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--dark); margin: 0;">Curriculum Assessments</h3>
        <a href="<%= request.getContextPath() %>/admin/quizzes" class="btn btn-outline btn-sm">Manage All Quizzes &rarr;</a>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 50px;">ID</th>
                    <th>Quiz Title</th>
                    <th>Category</th>
                    <th>Items / Weight</th>
                    <th>Timer Limit</th>
                    <th>Status</th>
                    <th style="text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
                    if (quizzes != null && !quizzes.isEmpty()) {
                        for (Quiz q : quizzes) {
                %>
                <tr>
                    <td>#<%= q.getId() %></td>
                    <td><strong><%= q.getTitle() %></strong></td>
                    <td><span class="badge badge-primary"><%= q.getCategory() %></span></td>
                    <td><%= q.getQuestionCount() %> questions (<%= q.getTotalMarks() %> pts)</td>
                    <td><%= q.getTimeLimitDisplay() %></td>
                    <td>
                        <% if (q.isPublished()) { %>
                            <span class="badge badge-success">Published</span>
                        <% } else { %>
                            <span class="badge badge-secondary">Draft</span>
                        <% } %>
                    </td>
                    <td style="text-align: right;">
                        <a href="<%= request.getContextPath() %>/admin/questions?quizId=<%= q.getId() %>" class="btn btn-outline btn-sm">Questions (<%= q.getQuestionCount() %>)</a>
                        <a href="<%= request.getContextPath() %>/admin/quiz/edit?id=<%= q.getId() %>" class="btn btn-outline btn-sm">Edit</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" style="text-align: center; color: var(--gray); padding: 1.5rem;">No assessments created yet.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<!-- Compact Recent Submissions Table -->
<div class="card" style="padding: 0; overflow: hidden;">
    <div style="display: flex; justify-content: space-between; align-items: center; padding: 0.85rem 1rem; border-bottom: 1px solid var(--border);">
        <h3 style="font-size: 0.95rem; font-weight: 700; color: var(--dark); margin: 0;">Recent Student Examination Submissions</h3>
        <a href="<%= request.getContextPath() %>/admin/attempts" class="btn btn-outline btn-sm">All Records &rarr;</a>
    </div>
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Record</th>
                    <th>Student Name</th>
                    <th>Assessment</th>
                    <th>Score</th>
                    <th>Grade</th>
                    <th>Status</th>
                    <th>Submitted</th>
                    <th style="text-align: right;">Detail</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<QuizAttempt> recent = (List<QuizAttempt>) request.getAttribute("recentAttempts");
                    if (recent != null && !recent.isEmpty()) {
                        for (QuizAttempt a : recent) {
                %>
                <tr>
                    <td><code><%= a.getId() %></code></td>
                    <td><strong><%= a.getStudentName() %></strong> (<%= a.getUsername() %>)</td>
                    <td><%= a.getQuizTitle() %></td>
                    <td><%= a.getObtainedMarks() %> / <%= a.getTotalMarks() %></td>
                    <td><strong><%= a.getPercentage() %>%</strong></td>
                    <td>
                        <% if (a.isPassed()) { %>
                            <span class="badge badge-success">Passed</span>
                        <% } else { %>
                            <span class="badge badge-danger">Failed</span>
                        <% } %>
                    </td>
                    <td><%= a.getCompletedAt() %></td>
                    <td style="text-align: right;">
                        <a href="<%= request.getContextPath() %>/admin/attempt/detail?id=<%= a.getId() %>" class="btn btn-outline btn-sm">Evaluation</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" style="text-align: center; color: var(--gray); padding: 1.5rem;">No student attempts logged yet.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
