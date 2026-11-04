<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.QuizAttempt" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Academic Performance Records - Student History");
    List<QuizAttempt> attempts = (List<QuizAttempt>) request.getAttribute("attempts");
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Academic Grade History
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Official transcript of completed assessments, grade percentages, and completion logs.
        </p>
    </div>
    <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-outline btn-sm">&larr; Return to Assessments</a>
</div>

<div class="card" style="padding: 0; overflow: hidden;">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th>Record ID</th>
                    <th>Assessment Title</th>
                    <th>Score / Max</th>
                    <th>Percentage</th>
                    <th>Time Spent</th>
                    <th>Evaluation Status</th>
                    <th>Submission Timestamp</th>
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
                        <a href="<%= request.getContextPath() %>/student/quiz/result?attemptId=<%= a.getId() %>" class="btn btn-outline btn-sm">
                            Full Report &rarr;
                        </a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="8" style="text-align: center; color: var(--gray); padding: 2.5rem 1rem;">
                        No completed assessment records found. <br>
                        <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-primary btn-sm" style="margin-top: 0.75rem;">View Assigned Quizzes</a>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
