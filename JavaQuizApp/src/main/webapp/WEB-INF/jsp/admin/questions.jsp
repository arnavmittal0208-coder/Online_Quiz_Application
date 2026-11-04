<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="com.quiz.model.Option" %>
<%@ page import="java.util.List" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    request.setAttribute("pageTitle", "Question Bank: " + quiz.getTitle());
%>
<jsp:include page="header.jsp" />

<div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
    <div>
        <div style="margin-bottom: 0.25rem;">
            <a href="<%= request.getContextPath() %>/admin/quizzes" style="color: var(--primary); text-decoration: none; font-size: 0.8rem;">&larr; Back to Quizzes</a>
        </div>
        <h1 style="font-size: 1.35rem; font-weight: 700; color: var(--dark); letter-spacing: -0.2px;">
            Question Bank: <%= quiz.getTitle() %>
        </h1>
        <p style="color: var(--gray); font-size: 0.82rem; margin-top: 0.15rem;">
            Bank Size: <strong><%= quiz.getQuestionCount() %> questions</strong> &bull; Total Points: <strong><%= quiz.getTotalMarks() %> pts</strong> &bull; Duration: <strong><%= quiz.getTimeLimitDisplay() %></strong>
        </p>
    </div>
    <div style="display: flex; gap: 0.5rem;">
        <a href="<%= request.getContextPath() %>/admin/quiz/edit?id=<%= quiz.getId() %>" class="btn btn-outline btn-sm">Edit Quiz Parameters</a>
        <a href="<%= request.getContextPath() %>/admin/question/new?quizId=<%= quiz.getId() %>" class="btn btn-primary btn-sm">+ Add Question</a>
    </div>
</div>

<%
    List<Question> questions = quiz.getQuestions();
    if (questions != null && !questions.isEmpty()) {
        int index = 1;
        for (Question q : questions) {
%>
<div class="card" style="margin-bottom: 0.85rem; padding: 1rem 1.25rem;">
    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 0.65rem;">
        <div style="display: flex; align-items: center; gap: 0.5rem;">
            <span style="background: var(--primary-subtle); color: var(--primary); font-weight: 700; padding: 0.15rem 0.5rem; border-radius: var(--radius-xs); font-size: 0.75rem;">
                Q<%= index++ %>
            </span>
            <span style="font-size: 0.95rem; color: var(--dark); font-weight: 600;"><%= q.getText() %></span>
        </div>
        <div style="display: flex; align-items: center; gap: 0.4rem; white-space: nowrap;">
            <span class="badge badge-primary"><%= q.getMarks() %> pts</span>
            <% if (q.getTimeLimit() > 0) { %>
                <span class="badge badge-warning">⏱ <%= q.getTimeLimit() %>s</span>
            <% } %>
            <a href="<%= request.getContextPath() %>/admin/question/edit?quizId=<%= quiz.getId() %>&questionId=<%= q.getId() %>" class="btn btn-outline btn-sm">Edit</a>
            <a href="<%= request.getContextPath() %>/admin/question/delete?quizId=<%= quiz.getId() %>&questionId=<%= q.getId() %>" class="btn btn-danger btn-sm" onclick="return confirm('Delete Question <%= index - 1 %>?');">Delete</a>
        </div>
    </div>

    <!-- Options Compact Grid -->
    <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.45rem; margin-top: 0.5rem;">
        <%
            if (q.getOptions() != null) {
                for (Option opt : q.getOptions()) {
                    boolean isCorrect = opt.isCorrect();
        %>
        <div style="padding: 0.45rem 0.65rem; border-radius: var(--radius-xs); border: 1px solid <%= isCorrect ? "#10b981" : "var(--border)" %>; background: <%= isCorrect ? "var(--success-subtle)" : "var(--white)" %>; display: flex; align-items: center; gap: 0.5rem; font-size: 0.82rem;">
            <strong style="color: <%= isCorrect ? "var(--success)" : "var(--gray)" %>; text-transform: uppercase;">
                <%= opt.getId() %>.
            </strong>
            <span style="flex: 1; color: <%= isCorrect ? "var(--success-text)" : "var(--dark)" %>; font-weight: <%= isCorrect ? "600" : "normal" %>;">
                <%= opt.getText() %>
            </span>
            <% if (isCorrect) { %>
                <span style="color: var(--success); font-weight: 700; font-size: 0.72rem;">&#10003; CORRECT</span>
            <% } %>
        </div>
        <%
                }
            }
        %>
    </div>

    <% if (q.getExplanation() != null && !q.getExplanation().trim().isEmpty()) { %>
        <div class="explanation-box" style="margin-top: 0.65rem;">
            <strong>Solution Rationale:</strong> <%= q.getExplanation() %>
        </div>
    <% } %>
</div>
<%
        }
    } else {
%>
<div class="card" style="text-align: center; padding: 2.5rem 1rem;">
    <h3 style="color: var(--dark); margin-bottom: 0.35rem; font-size: 1.05rem;">No Questions in this Assessment</h3>
    <p style="color: var(--gray); font-size: 0.84rem; margin-bottom: 1rem;">
        Add questions with multiple choice options and automated evaluation keys.
    </p>
    <a href="<%= request.getContextPath() %>/admin/question/new?quizId=<%= quiz.getId() %>" class="btn btn-primary btn-sm">+ Add First Question</a>
</div>
<% } %>

<jsp:include page="footer.jsp" />
