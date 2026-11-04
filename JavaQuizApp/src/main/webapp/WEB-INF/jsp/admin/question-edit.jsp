<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="com.quiz.model.Option" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    Question question = (Question) request.getAttribute("question");
    boolean isEdit = Boolean.TRUE.equals(request.getAttribute("isEdit"));
    request.setAttribute("pageTitle", (isEdit ? "Edit Question Item" : "Create Question Item") + " - Admin Portal");

    String optA = "", optB = "", optC = "", optD = "";
    String correctId = "a";

    if (question != null && question.getOptions() != null) {
        for (Option o : question.getOptions()) {
            if ("a".equalsIgnoreCase(o.getId())) optA = o.getText();
            if ("b".equalsIgnoreCase(o.getId())) optB = o.getText();
            if ("c".equalsIgnoreCase(o.getId())) optC = o.getText();
            if ("d".equalsIgnoreCase(o.getId())) optD = o.getText();
            if (o.isCorrect()) correctId = o.getId();
        }
    }
%>
<jsp:include page="header.jsp" />

<div style="max-width: 720px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
        <div>
            <h1 style="font-size: 1.25rem; font-weight: 700; color: var(--dark);">
                <%= isEdit ? "Edit Question Item" : "Add Question Item" %>
            </h1>
            <p style="color: var(--gray); font-size: 0.8rem;">Target Quiz: <strong><%= quiz.getTitle() %></strong></p>
        </div>
        <a href="<%= request.getContextPath() %>/admin/questions?quizId=<%= quiz.getId() %>" class="btn btn-outline btn-sm">&larr; Back to Questions</a>
    </div>

    <div class="card" style="padding: 1.25rem;">
        <form action="<%= request.getContextPath() %>/admin/question/save" method="post">
            <input type="hidden" name="quizId" value="<%= quiz.getId() %>">
            <input type="hidden" name="questionId" value="<%= question != null ? question.getId() : 0 %>">

            <div class="form-group">
                <label for="text">Question Statement *</label>
                <textarea id="text" name="text" class="form-control" rows="2" required placeholder="Type the question statement..."><%= question != null && question.getText() != null ? question.getText() : "" %></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="marks">Weight / Marks *</label>
                    <input type="number" id="marks" name="marks" class="form-control" min="1" max="100" value="<%= question != null && question.getMarks() > 0 ? question.getMarks() : 10 %>" required>
                </div>
                <div class="form-group">
                    <label for="timeLimit">Item Timer (Seconds)</label>
                    <input type="number" id="timeLimit" name="timeLimit" class="form-control" min="0" step="5" value="<%= question != null ? question.getTimeLimit() : quiz.getTimePerQuestion() %>">
                    <span style="color: var(--gray); font-size: 0.74rem;">0 inherits quiz-wide pace.</span>
                </div>
            </div>

            <div style="margin: 1rem 0 0.5rem 0;">
                <label style="font-size: 0.82rem; font-weight: 700; color: var(--dark);">Answer Options & Key</label>
                <p style="font-size: 0.76rem; color: var(--gray); margin-bottom: 0.65rem;">Select the radio button next to the <strong>correct key</strong>.</p>
            </div>

            <!-- Option A -->
            <div class="form-group" style="display: flex; align-items: center; gap: 0.55rem; background: var(--gray-light); padding: 0.45rem 0.65rem; border: 1px solid var(--border); border-radius: var(--radius-xs); margin-bottom: 0.45rem;">
                <input type="radio" name="correctOption" id="correct_a" value="a" style="accent-color: var(--primary);" <%= "a".equalsIgnoreCase(correctId) ? "checked" : "" %> required>
                <label for="correct_a" style="font-weight: 700; width: 20px; margin-bottom: 0; font-size: 0.82rem;">A.</label>
                <input type="text" name="option_a" class="form-control" placeholder="Option A text" value="<%= optA %>" required>
            </div>

            <!-- Option B -->
            <div class="form-group" style="display: flex; align-items: center; gap: 0.55rem; background: var(--gray-light); padding: 0.45rem 0.65rem; border: 1px solid var(--border); border-radius: var(--radius-xs); margin-bottom: 0.45rem;">
                <input type="radio" name="correctOption" id="correct_b" value="b" style="accent-color: var(--primary);" <%= "b".equalsIgnoreCase(correctId) ? "checked" : "" %>>
                <label for="correct_b" style="font-weight: 700; width: 20px; margin-bottom: 0; font-size: 0.82rem;">B.</label>
                <input type="text" name="option_b" class="form-control" placeholder="Option B text" value="<%= optB %>" required>
            </div>

            <!-- Option C -->
            <div class="form-group" style="display: flex; align-items: center; gap: 0.55rem; background: var(--gray-light); padding: 0.45rem 0.65rem; border: 1px solid var(--border); border-radius: var(--radius-xs); margin-bottom: 0.45rem;">
                <input type="radio" name="correctOption" id="correct_c" value="c" style="accent-color: var(--primary);" <%= "c".equalsIgnoreCase(correctId) ? "checked" : "" %>>
                <label for="correct_c" style="font-weight: 700; width: 20px; margin-bottom: 0; font-size: 0.82rem;">C.</label>
                <input type="text" name="option_c" class="form-control" placeholder="Option C text" value="<%= optC %>" required>
            </div>

            <!-- Option D -->
            <div class="form-group" style="display: flex; align-items: center; gap: 0.55rem; background: var(--gray-light); padding: 0.45rem 0.65rem; border: 1px solid var(--border); border-radius: var(--radius-xs); margin-bottom: 0.45rem;">
                <input type="radio" name="correctOption" id="correct_d" value="d" style="accent-color: var(--primary);" <%= "d".equalsIgnoreCase(correctId) ? "checked" : "" %>>
                <label for="correct_d" style="font-weight: 700; width: 20px; margin-bottom: 0; font-size: 0.82rem;">D.</label>
                <input type="text" name="option_d" class="form-control" placeholder="Option D text" value="<%= optD %>" required>
            </div>

            <div class="form-group" style="margin-top: 0.85rem;">
                <label for="explanation">Explanation / Solution Rationale</label>
                <textarea id="explanation" name="explanation" class="form-control" rows="2" placeholder="Theoretical solution shown to students during grade review..."><%= question != null && question.getExplanation() != null ? question.getExplanation() : "" %></textarea>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 0.65rem; margin-top: 1.25rem;">
                <a href="<%= request.getContextPath() %>/admin/questions?quizId=<%= quiz.getId() %>" class="btn btn-outline btn-sm">Cancel</a>
                <button type="submit" class="btn btn-primary btn-sm"><%= isEdit ? "Save Item" : "Create Item" %></button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
