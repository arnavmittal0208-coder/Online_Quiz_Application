package com.quiz.model;

import java.util.ArrayList;
import java.util.List;

public class Quiz {
    private int id;
    private String title;
    private String description;
    private String category;
    private int totalTimeLimit;    // seconds for entire quiz (0 = no limit)
    private int timePerQuestion;   // seconds per question (0 = no limit)
    private boolean published;
    private String createdBy;
    private String createdAt;
    private int passingScore;      // percentage
    private List<Question> questions;

    public Quiz() {
        this.questions = new ArrayList<>();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public int getTotalTimeLimit() { return totalTimeLimit; }
    public void setTotalTimeLimit(int totalTimeLimit) { this.totalTimeLimit = totalTimeLimit; }

    public int getTimePerQuestion() { return timePerQuestion; }
    public void setTimePerQuestion(int timePerQuestion) { this.timePerQuestion = timePerQuestion; }

    public boolean isPublished() { return published; }
    public void setPublished(boolean published) { this.published = published; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public int getPassingScore() { return passingScore; }
    public void setPassingScore(int passingScore) { this.passingScore = passingScore; }

    public List<Question> getQuestions() { return questions; }
    public void setQuestions(List<Question> questions) { this.questions = questions; }

    public int getQuestionCount() {
        return questions != null ? questions.size() : 0;
    }

    public int getTotalMarks() {
        if (questions == null) return 0;
        return questions.stream().mapToInt(Question::getMarks).sum();
    }

    public String getTimeLimitDisplay() {
        if (totalTimeLimit <= 0) return "No Limit";
        int mins = totalTimeLimit / 60;
        int secs = totalTimeLimit % 60;
        return mins > 0 ? mins + " min " + (secs > 0 ? secs + " sec" : "") : secs + " sec";
    }
}

