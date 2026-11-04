package com.quiz.model;

import java.util.ArrayList;
import java.util.List;

public class Question {
    private int id;
    private String text;
    private String type; // MCQ
    private int marks;
    private int timeLimit; // per-question override in seconds (0 = use quiz default)
    private List<Option> options;
    private String explanation;

    public Question() {
        this.options = new ArrayList<>();
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getText() { return text; }
    public void setText(String text) { this.text = text; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public int getMarks() { return marks; }
    public void setMarks(int marks) { this.marks = marks; }

    public int getTimeLimit() { return timeLimit; }
    public void setTimeLimit(int timeLimit) { this.timeLimit = timeLimit; }

    public List<Option> getOptions() { return options; }
    public void setOptions(List<Option> options) { this.options = options; }

    public String getExplanation() { return explanation; }
    public void setExplanation(String explanation) { this.explanation = explanation; }

    public String getCorrectOptionId() {
        if (options == null) return null;
        return options.stream()
                .filter(Option::isCorrect)
                .map(Option::getId)
                .findFirst()
                .orElse(null);
    }

    public Option getCorrectOption() {
        if (options == null) return null;
        return options.stream()
                .filter(Option::isCorrect)
                .findFirst()
                .orElse(null);
    }
}

