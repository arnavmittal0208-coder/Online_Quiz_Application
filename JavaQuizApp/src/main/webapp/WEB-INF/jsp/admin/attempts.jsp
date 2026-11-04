<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Student Submissions - Admin Portal");
    List<QuizAttempt> attempts = (List<QuizAttempt>) request.getAttribute("attempts");
    List<Quiz> quizzes = (List<Quiz>) request.getAttribute("quizzes");
    Integer selectedQuizId = (Integer) request.getAttribute("selectedQuizId");
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Examination Submissions
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Review student attempt scores, completion durations, and question evaluations.
        </p>
    </div>
    <div>
        <form action="<%= request.getContextPath() %>/admin/attempts" method="get">
            <select name="quizId" class="form-control" onchange="this.form.submit()" style="min-width: 200px; height: 32px; font-size: 0.82rem;">
                <option value="">-- Filter by Assessment --</option>
                <%
                    if (quizzes != null) {
                        for (Quiz q : quizzes) {
                            boolean sel = selectedQuizId != null && selectedQuizId == q.getId();
                %>
                <option value="<%= q.getId() %>" <%= sel ? "selected" : "" %>><%= q.getTitle() %></option>
                <%
                        }
                    }
                %>
            </select>
        </form>
    </div>
</div>

<div class="card" style="padding: 0; overflow: hidden;">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 80px;">Attempt</th>
                    <th>Student Name</th>
                    <th>Quiz Title</th>
                    <th>Score / Max</th>
                    <th>Grade</th>
                    <th>Duration</th>
                    <th>Status</th>
                    <th>Timestamp</th>
                    <th style="text-align: right;">Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if (attempts != null && !attempts.isEmpty()) {
                        for (QuizAttempt a : attempts) {
                %>
                <tr>
                    <td><code><%= a.getId() %></code></td>
                    <td>
                        <strong><%= a.getStudentName() %></strong>
                        <div style="font-size: 0.74rem; color: var(--gray);"><%= a.getUsername() %></div>
                    </td>
                    <td><strong><%= a.getQuizTitle() %></strong></td>
                    <td><%= a.getObtainedMarks() %> / <%= a.getTotalMarks() %></td>
                    <td><strong><%= a.getPercentage() %>%</strong></td>
                    <td><%= a.getTimeTakenDisplay() %></td>
                    <td>
                        <% if (a.isPassed()) { %>
                            <span class="badge badge-success">&#10003; Passed</span>
                        <% } else { %>
                            <span class="badge badge-danger">&#10007; Failed</span>
                        <% } %>
                    </td>
                    <td><%= a.getCompletedAt() %></td>
                    <td style="text-align: right;">
                        <a href="<%= request.getContextPath() %>/admin/attempt/detail?id=<%= a.getId() %>" class="btn btn-outline btn-sm">Review &rarr;</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" style="text-align: center; color: var(--gray); padding: 2.5rem 1rem;">
                        No student submissions match the active filter criteria.
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
