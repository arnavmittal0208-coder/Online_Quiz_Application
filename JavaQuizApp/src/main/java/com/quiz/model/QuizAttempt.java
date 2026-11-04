package com.quiz.model;

import java.util.ArrayList;
import java.util.List;

public class QuizAttempt {
    private String id;
    private int quizId;
    private String quizTitle;
    private String username;
    private String studentName;
    private String startedAt;
    private String completedAt;
    private int timeTaken; // seconds
    private List<QuestionAttempt> questionAttempts;
    private int totalMarks;
    private int obtainedMarks;
    private double percentage;
    private boolean passed;

    public QuizAttempt() {
        this.questionAttempts = new ArrayList<>();
    }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public int getQuizId() { return quizId; }
    public void setQuizId(int quizId) { this.quizId = quizId; }

    public String getQuizTitle() { return quizTitle; }
    public void setQuizTitle(String quizTitle) { this.quizTitle = quizTitle; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getStudentName() { return studentName; }
    public void setStudentName(String studentName) { this.studentName = studentName; }

    public String getStartedAt() { return startedAt; }
    public void setStartedAt(String startedAt) { this.startedAt = startedAt; }

    public String getCompletedAt() { return completedAt; }
    public void setCompletedAt(String completedAt) { this.completedAt = completedAt; }

    public int getTimeTaken() { return timeTaken; }
    public void setTimeTaken(int timeTaken) { this.timeTaken = timeTaken; }

    public List<QuestionAttempt> getQuestionAttempts() { return questionAttempts; }
    public void setQuestionAttempts(List<QuestionAttempt> questionAttempts) {
        this.questionAttempts = questionAttempts;
    }

    public int getTotalMarks() { return totalMarks; }
    public void setTotalMarks(int totalMarks) { this.totalMarks = totalMarks; }

    public int getObtainedMarks() { return obtainedMarks; }
    public void setObtainedMarks(int obtainedMarks) { this.obtainedMarks = obtainedMarks; }

    public double getPercentage() { return percentage; }
    public void setPercentage(double percentage) { this.percentage = percentage; }

    public boolean isPassed() { return passed; }
    public void setPassed(boolean passed) { this.passed = passed; }

    public int getCorrectCount() {
        if (questionAttempts == null) return 0;
        return (int) questionAttempts.stream().filter(QuestionAttempt::isCorrect).count();
    }

    public int getWrongCount() {
        if (questionAttempts == null) return 0;
        return (int) questionAttempts.stream().filter(qa -> !qa.isCorrect() && qa.getSelectedOption() != null && !qa.getSelectedOption().isEmpty()).count();
    }

    public int getSkippedCount() {
        if (questionAttempts == null) return 0;
        return (int) questionAttempts.stream().filter(qa -> qa.getSelectedOption() == null || qa.getSelectedOption().isEmpty()).count();
    }

    public String getTimeTakenDisplay() {
        int mins = timeTaken / 60;
        int secs = timeTaken % 60;
        return String.format("%d min %02d sec", mins, secs);
    }

    // Inner class for each question's answer
    public static class QuestionAttempt {
        private int questionId;
        private String questionText;
        private String selectedOption;
        private String correctOption;
        private boolean correct;
        private int marksObtained;
        private int maxMarks;

        public int getQuestionId() { return questionId; }
        public void setQuestionId(int questionId) { this.questionId = questionId; }

        public String getQuestionText() { return questionText; }
        public void setQuestionText(String questionText) { this.questionText = questionText; }

        public String getSelectedOption() { return selectedOption; }
        public void setSelectedOption(String selectedOption) { this.selectedOption = selectedOption; }

        public String getCorrectOption() { return correctOption; }
        public void setCorrectOption(String correctOption) { this.correctOption = correctOption; }

        public boolean isCorrect() { return correct; }
        public void setCorrect(boolean correct) { this.correct = correct; }

        public int getMarksObtained() { return marksObtained; }
        public void setMarksObtained(int marksObtained) { this.marksObtained = marksObtained; }

        public int getMaxMarks() { return maxMarks; }
        public void setMaxMarks(int maxMarks) { this.maxMarks = maxMarks; }
    }
}

