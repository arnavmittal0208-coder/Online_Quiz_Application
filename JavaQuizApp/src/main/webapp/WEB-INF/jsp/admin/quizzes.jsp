<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="java.util.List" %>
<%
    request.setAttribute("pageTitle", "Curriculum Quizzes - Instructor Portal");
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Curriculum Quizzes & Tests
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Configure assessments, timing constraints, question banks, and live visibility.
        </p>
    </div>
    <div>
        <a href="<%= request.getContextPath() %>/admin/quiz/new" class="btn btn-primary btn-sm">+ Create New Quiz</a>
    </div>
</div>

<div class="card" style="padding: 0; overflow: hidden;">
    <div class="table-responsive">
        <table class="table">
            <thead>
                <tr>
                    <th style="width: 50px;">ID</th>
                    <th>Quiz Title & Scope</th>
                    <th>Subject Category</th>
                    <th>Items</th>
                    <th>Time Limit</th>
                    <th>Time / Item</th>
                    <th>Pass %</th>
                    <th>Catalog State</th>
                    <th style="text-align: right;">Actions</th>
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
                    <td>
                        <strong><%= q.getTitle() %></strong>
                        <div style="font-size: 0.78rem; color: var(--gray); max-width: 280px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis;">
                            <%= q.getDescription() %>
                        </div>
                    </td>
                    <td><span class="badge badge-primary"><%= q.getCategory() %></span></td>
                    <td><%= q.getQuestionCount() %> questions (<%= q.getTotalMarks() %> pts)</td>
                    <td><%= q.getTimeLimitDisplay() %></td>
                    <td><%= q.getTimePerQuestion() > 0 ? q.getTimePerQuestion() + "s" : "Default" %></td>
                    <td><%= q.getPassingScore() %>%</td>
                    <td>
                        <a href="<%= request.getContextPath() %>/admin/quiz/toggle-publish?id=<%= q.getId() %>" style="text-decoration: none;">
                            <% if (q.isPublished()) { %>
                                <span class="badge badge-success" title="Click to Unpublish">&#10003; Published</span>
                            <% } else { %>
                                <span class="badge badge-secondary" title="Click to Publish">Draft</span>
                            <% } %>
                        </a>
                    </td>
                    <td style="text-align: right; white-space: nowrap;">
                        <a href="<%= request.getContextPath() %>/admin/questions?quizId=<%= q.getId() %>" class="btn btn-outline btn-sm">Questions (<%= q.getQuestionCount() %>)</a>
                        <a href="<%= request.getContextPath() %>/admin/quiz/edit?id=<%= q.getId() %>" class="btn btn-outline btn-sm">Edit</a>
                        <a href="<%= request.getContextPath() %>/admin/quiz/delete?id=<%= q.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete this assessment and its questions?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" style="text-align: center; color: var(--gray); padding: 2rem;">No quizzes created yet.</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="footer.jsp" />
