<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    boolean isEdit = Boolean.TRUE.equals(request.getAttribute("isEdit"));
    request.setAttribute("pageTitle", (isEdit ? "Edit Quiz Specification" : "Create New Quiz") + " - Admin Portal");
%>
<jsp:include page="header.jsp" />

<div style="max-width: 680px; margin: 0 auto;">
    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem; border-bottom: 1px solid var(--border); padding-bottom: 0.75rem;">
        <div>
            <h1 style="font-size: 1.25rem; font-weight: 700; color: var(--dark);">
                <%= isEdit ? "Edit Assessment Parameters" : "Define New Assessment" %>
            </h1>
            <p style="color: var(--gray); font-size: 0.8rem;">Configure academic parameters, timer limits, and passing benchmarks.</p>
        </div>
        <a href="<%= request.getContextPath() %>/admin/quizzes" class="btn btn-outline btn-sm">&larr; Back to List</a>
    </div>

    <div class="card" style="padding: 1.25rem;">
        <form action="<%= request.getContextPath() %>/admin/quiz/save" method="post">
            <input type="hidden" name="id" value="<%= quiz != null ? quiz.getId() : 0 %>">

            <div class="form-group">
                <label for="title">Assessment Title *</label>
                <input type="text" id="title" name="title" class="form-control" value="<%= quiz != null && quiz.getTitle() != null ? quiz.getTitle() : "" %>" required placeholder="e.g. Java Fundamentals & Object-Oriented Principles">
            </div>

            <div class="form-group">
                <label for="description">Course Syllabus / Description</label>
                <textarea id="description" name="description" class="form-control" rows="2" placeholder="Brief overview of evaluation scope..."><%= quiz != null && quiz.getDescription() != null ? quiz.getDescription() : "" %></textarea>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">Subject Category</label>
                    <input type="text" id="category" name="category" class="form-control" value="<%= quiz != null && quiz.getCategory() != null ? quiz.getCategory() : "Computer Science" %>" placeholder="e.g. Java Programming">
                </div>
                <div class="form-group">
                    <label for="passingScore">Passing Benchmark (%) *</label>
                    <input type="number" id="passingScore" name="passingScore" class="form-control" min="1" max="100" value="<%= quiz != null && quiz.getPassingScore() > 0 ? quiz.getPassingScore() : 60 %>" required>
                </div>
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="totalTimeLimit">Overall Time Limit (Seconds)</label>
                    <input type="number" id="totalTimeLimit" name="totalTimeLimit" class="form-control" min="0" step="10" value="<%= quiz != null ? quiz.getTotalTimeLimit() : 300 %>" required>
                    <span style="color: var(--gray); font-size: 0.74rem;">e.g., 300s = 5 minutes (0 for untimed).</span>
                </div>
                <div class="form-group">
                    <label for="timePerQuestion">Time Allocation / Question (Seconds)</label>
                    <input type="number" id="timePerQuestion" name="timePerQuestion" class="form-control" min="0" step="5" value="<%= quiz != null ? quiz.getTimePerQuestion() : 60 %>" required>
                    <span style="color: var(--gray); font-size: 0.74rem;">e.g., 60s recommended pace.</span>
                </div>
            </div>

            <div class="form-group" style="display: flex; align-items: center; gap: 0.65rem; margin-top: 0.75rem; padding: 0.65rem 0.85rem; background: var(--gray-light); border: 1px solid var(--border); border-radius: var(--radius-xs);">
                <input type="checkbox" id="published" name="published" style="width: 16px; height: 16px; accent-color: var(--primary);" <%= quiz != null && quiz.isPublished() ? "checked" : "" %>>
                <label for="published" style="margin-bottom: 0; cursor: pointer; font-size: 0.82rem;">
                    <strong>Publish Assessment Immediately</strong> &bull; <span style="color: var(--gray);">Make visible on all student dashboards.</span>
                </label>
            </div>

            <div style="display: flex; justify-content: flex-end; gap: 0.65rem; margin-top: 1.25rem;">
                <a href="<%= request.getContextPath() %>/admin/quizzes" class="btn btn-outline btn-sm">Cancel</a>
                <button type="submit" class="btn btn-primary btn-sm"><%= isEdit ? "Save Parameters" : "Create & Add Questions" %></button>
            </div>
        </form>
    </div>
</div>

<jsp:include page="footer.jsp" />
