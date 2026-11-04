<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.quiz.model.Quiz" %>
<%@ page import="com.quiz.model.Question" %>
<%@ page import="com.quiz.model.Option" %>
<%@ page import="java.util.List" %>
<%
    Quiz quiz = (Quiz) request.getAttribute("quiz");
    int totalQuestions = quiz != null && quiz.getQuestions() != null ? quiz.getQuestions().size() : 0;
    int totalSeconds = quiz != null && quiz.getTotalTimeLimit() > 0 ? quiz.getTotalTimeLimit() : (totalQuestions * 60);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= quiz.getTitle() %> - Examination</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body style="background: #f8fafc;">

<!-- Compact Navigation Bar -->
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/student/dashboard" class="navbar-brand">
        <div class="brand-icon">Q</div>
        <span>SkillForge LMS</span>
    </a>
    <div style="font-size: 0.82rem; color: var(--gray); font-weight: 500;">
        Online Assessment Session
    </div>
    <div>
        <a href="<%= request.getContextPath() %>/student/dashboard" class="btn btn-outline btn-sm" onclick="return confirm('Do you want to exit? Active responses will not be saved.');">Exit Exam</a>
    </div>
</nav>

<div class="container" style="max-width: 1140px; padding-top: 0.85rem;">

    <!-- Breadcrumb Navigation -->
    <div class="breadcrumb-nav">
        <a href="<%= request.getContextPath() %>/student/dashboard">
            <span>&larr; Back to Catalog</span>
        </a>
        <span class="breadcrumb-divider">/</span>
        <span class="breadcrumb-current"><%= quiz.getTitle() %></span>
    </div>

    <!-- 2-Column Examination Stage Grid -->
    <div class="quiz-layout-grid">

        <!-- Left Column: Main Question Stage -->
        <div class="lms-quiz-main">
            <!-- Header -->
            <div class="lms-quiz-header">
                <div>
                    <h1 class="lms-quiz-title"><%= quiz.getTitle() %></h1>
                    <div class="lms-quiz-subtitle" id="questionCounterText">
                        Question 1 of <%= totalQuestions %>
                    </div>
                </div>

                <!-- Timer Pill on Top Right -->
                <div class="lms-timer-pill" id="timerContainer">
                    <span style="font-size: 0.85rem;">⏱</span>
                    <span id="quizTimerText">--:--</span>
                </div>
            </div>

            <!-- Slim Progress Bar -->
            <div class="lms-progress-container">
                <div class="lms-progress-bar" id="quizProgressBar"></div>
            </div>

            <!-- Quiz Questions Form -->
            <form id="lmsQuizForm" action="<%= request.getContextPath() %>/student/quiz/submit" method="post">
                <input type="hidden" name="quizId" value="<%= quiz.getId() %>">
                <input type="hidden" name="timeTaken" id="timeTakenInput" value="0">

                <%
                    List<Question> questions = quiz.getQuestions();
                    if (questions != null) {
                        for (int i = 0; i < questions.size(); i++) {
                            Question q = questions.get(i);
                %>
                <!-- Individual Question Step Container -->
                <div class="question-step-card" id="q_step_<%= i %>" style="<%= i == 0 ? "display:block;" : "display:none;" %>">
                    <div class="lms-question-statement">
                        <%= q.getText() %>
                    </div>

                    <div class="lms-options-group">
                        <%
                            if (q.getOptions() != null) {
                                for (Option opt : q.getOptions()) {
                        %>
                        <label class="lms-option-card">
                            <input type="radio" name="question_<%= q.getId() %>" value="<%= opt.getId() %>">
                            <div class="lms-option-badge"><%= opt.getId().toUpperCase() %></div>
                            <div class="lms-option-text"><%= opt.getText() %></div>
                        </label>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <%
                        }
                    }
                %>

                <!-- Footer Navigation Buttons -->
                <div class="lms-nav-footer">
                    <button type="button" id="btnPrevQuestion" class="btn btn-outline btn-sm" style="visibility: hidden;">
                        &larr; Previous
                    </button>
                    <button type="button" id="btnNextQuestion" class="btn btn-primary btn-sm">
                        Next Question &rarr;
                    </button>
                </div>
            </form>
        </div>

        <!-- Right Column: Sidebar Component (Matching LMS layout) -->
        <div class="lms-sidebar-card">
            <!-- Sidebar Tab Strip -->
            <div class="lms-sidebar-tabs">
                <div class="lms-sidebar-tab">Modules</div>
                <div class="lms-sidebar-tab active">Exam Navigator</div>
            </div>

            <div class="lms-sidebar-body">
                <div class="lms-sidebar-section-title">Assessment Summary</div>

                <div class="lms-sidebar-item">
                    <span class="lms-radio-indicator"></span>
                    <div>
                        <div class="lms-sidebar-item-title"><%= quiz.getTitle() %></div>
                        <div class="lms-sidebar-item-meta">
                            Passing: <%= quiz.getPassingScore() %>% &bull; Total Marks: <%= quiz.getTotalMarks() %>
                        </div>
                    </div>
                </div>

                <div class="lms-sidebar-section-title" style="margin-top: 1rem;">Question Matrix</div>
                <div class="palette-grid">
                    <%
                        for (int i = 0; i < totalQuestions; i++) {
                    %>
                    <button type="button" class="palette-btn <%= i == 0 ? "current" : "" %>" data-index="<%= i %>">
                        <%= i + 1 %>
                    </button>
                    <% } %>
                </div>

                <div class="palette-legend">
                    <div class="legend-item">
                        <span class="legend-dot answered"></span>
                        <span>Answered</span>
                    </div>
                    <div class="legend-item">
                        <span class="legend-dot current"></span>
                        <span>Active</span>
                    </div>
                    <div class="legend-item">
                        <span class="legend-dot unanswered"></span>
                        <span>Pending</span>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<script src="<%= request.getContextPath() %>/js/quiz-timer.js"></script>
<script>
    QuizController.init({
        totalQuestions: <%= totalQuestions %>,
        totalSeconds: <%= totalSeconds %>,
        formId: 'lmsQuizForm',
        timerDisplayId: 'quizTimerText'
    });
</script>

</body>
</html>
