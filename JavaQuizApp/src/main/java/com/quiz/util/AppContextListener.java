package com.quiz.util;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext ctx = sce.getServletContext();
        String dataPath = ctx.getRealPath("/WEB-INF/data");
        if (dataPath == null) {
            // In case getRealPath is null in some containers, fallback to temp dir or user dir
            dataPath = System.getProperty("user.dir") + File.separator + "data";
        }

        File dataDir = new File(dataPath);
        if (!dataDir.exists()) {
            dataDir.mkdirs();
        }

        initializeFile(ctx, dataDir, "users.xml", getDefaultUsersXml());
        initializeFile(ctx, dataDir, "quizzes.xml", getDefaultQuizzesXml());
        initializeFile(ctx, dataDir, "attempts.xml", "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<attempts>\n</attempts>\n");
        
        System.out.println("Online Quiz Application initialized. Data directory: " + dataDir.getAbsolutePath());
    }

    private void initializeFile(ServletContext ctx, File dataDir, String fileName, String defaultContent) {
        File target = new File(dataDir, fileName);
        if (!target.exists() || target.length() == 0) {
            try {
                // Try reading from classpath first
                InputStream in = getClass().getClassLoader().getResourceAsStream("data/" + fileName);
                if (in != null) {
                    Files.copy(in, target.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    in.close();
                } else {
                    // Fallback to default string
                    try (FileWriter writer = new FileWriter(target)) {
                        writer.write(defaultContent);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private String getDefaultUsersXml() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
               "<users>\n" +
               "    <user>\n" +
               "        <id>1</id>\n" +
               "        <username>admin</username>\n" +
               "        <password>admin123</password>\n" +
               "        <email>admin@quiz.com</email>\n" +
               "        <role>ADMIN</role>\n" +
               "        <fullName>Administrator</fullName>\n" +
               "        <createdAt>2026-01-01</createdAt>\n" +
               "    </user>\n" +
               "    <user>\n" +
               "        <id>2</id>\n" +
               "        <username>student1</username>\n" +
               "        <password>student123</password>\n" +
               "        <email>student1@quiz.com</email>\n" +
               "        <role>STUDENT</role>\n" +
               "        <fullName>John Doe</fullName>\n" +
               "        <createdAt>2026-01-15</createdAt>\n" +
               "    </user>\n" +
               "</users>\n";
    }

    private String getDefaultQuizzesXml() {
        return "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n" +
               "<quizzes>\n" +
               "    <quiz>\n" +
               "        <id>1</id>\n" +
               "        <title>Java Core Fundamentals</title>\n" +
               "        <description>Evaluate core Java concepts including OOP principles, syntax, memory management, and control structures.</description>\n" +
               "        <category>Java Programming</category>\n" +
               "        <totalTimeLimit>300</totalTimeLimit>\n" +
               "        <timePerQuestion>60</timePerQuestion>\n" +
               "        <published>true</published>\n" +
               "        <createdBy>admin</createdBy>\n" +
               "        <createdAt>2026-10-01</createdAt>\n" +
               "        <passingScore>60</passingScore>\n" +
               "        <questions>\n" +
               "            <question>\n" +
               "                <id>1</id>\n" +
               "                <text>Which of the following is NOT a Java primitive data type?</text>\n" +
               "                <type>MCQ</type>\n" +
               "                <marks>10</marks>\n" +
               "                <timeLimit>60</timeLimit>\n" +
               "                <options>\n" +
               "                    <option id=\"a\" correct=\"false\">int</option>\n" +
               "                    <option id=\"b\" correct=\"true\">String</option>\n" +
               "                    <option id=\"c\" correct=\"false\">boolean</option>\n" +
               "                    <option id=\"d\" correct=\"false\">double</option>\n" +
               "                </options>\n" +
               "                <explanation>In Java, String is an object/class, not a primitive type.</explanation>\n" +
               "            </question>\n" +
               "            <question>\n" +
               "                <id>2</id>\n" +
               "                <text>Which keyword is used to prevent method overriding in Java?</text>\n" +
               "                <type>MCQ</type>\n" +
               "                <marks>10</marks>\n" +
               "                <timeLimit>60</timeLimit>\n" +
               "                <options>\n" +
               "                    <option id=\"a\" correct=\"false\">static</option>\n" +
               "                    <option id=\"b\" correct=\"false\">abstract</option>\n" +
               "                    <option id=\"c\" correct=\"true\">final</option>\n" +
               "                    <option id=\"d\" correct=\"false\">synchronized</option>\n" +
               "                </options>\n" +
               "                <explanation>The 'final' keyword on a method prevents subclasses from overriding it.</explanation>\n" +
               "            </question>\n" +
               "            <question>\n" +
               "                <id>3</id>\n" +
               "                <text>What is the default value of an uninitialized boolean instance variable in Java?</text>\n" +
               "                <type>MCQ</type>\n" +
               "                <marks>10</marks>\n" +
               "                <timeLimit>60</timeLimit>\n" +
               "                <options>\n" +
               "                    <option id=\"a\" correct=\"false\">true</option>\n" +
               "                    <option id=\"b\" correct=\"true\">false</option>\n" +
               "                    <option id=\"c\" correct=\"false\">null</option>\n" +
               "                    <option id=\"d\" correct=\"false\">0</option>\n" +
               "                </options>\n" +
               "                <explanation>In Java, default value for boolean member variables is false.</explanation>\n" +
               "            </question>\n" +
               "        </questions>\n" +
               "    </quiz>\n" +
               "</quizzes>\n";
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
    }
}

